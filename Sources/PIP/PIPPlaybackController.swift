import Cocoa
import UniformTypeIdentifiers

final class PIPPlaybackController: NSObject {
    var onStatusChange: ((String) -> Void)?
    var onTimelineChange: ((String) -> Void)?
    var onPictureInPictureAvailabilityChange: ((Bool) -> Void)?
    weak var replacementWindow: NSWindow?

    private let mediaAccessController = MediaAccessController()
    private var pipController: PIPViewController?
    private var contentController: VideoContentViewController?
    private var timer: Timer?
    private var isPIPRuntimeAvailable = false
    private var isPlaying = true
    private var elapsedTime: TimeInterval = 0
    private var pendingSeekTime: TimeInterval?
    private var mediaURL: URL?
    private var statusMessage = "PIPViewController unavailable"

    func start() {
        do {
            try PIPRuntime.prepare()
            self.isPIPRuntimeAvailable = true
            self.statusMessage = "PIPViewController and playback-state SPI available"
        } catch {
            self.statusMessage = error.localizedDescription
        }

        self.timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] _ in
            self?.tick()
        }
        self.publishUserInterfaceState()
    }

    func stop() {
        self.timer?.invalidate()
        self.timer = nil
        self.contentController?.player?.pause()
        self.mediaAccessController.stopAccessing()
    }

    func startPictureInPicture() {
        guard self.pipController == nil, let mediaURL = self.mediaURL else {
            return
        }

        do {
            let pipController = try PIPRuntime.makeViewController()
            pipController.delegate = self
            pipController.userCanResize = false
            pipController.aspectRatio = NSSize(width: 16, height: 9)
            pipController.replacementWindow = self.replacementWindow
            pipController.replacementRect = self.replacementWindow?.contentView?.bounds ?? .zero

            let contentController = VideoContentViewController()
            contentController.playing = self.isPlaying
            contentController.load(mediaURL)

            self.pipController = pipController
            self.contentController = contentController
            pipController.presentAsPicture(inPicture: contentController)
            self.publishUserInterfaceState()
            self.updatePlaybackState()
        } catch {
            self.isPIPRuntimeAvailable = false
            self.statusMessage = error.localizedDescription
            self.publishUserInterfaceState()
        }
    }

    func togglePlayback() {
        self.isPlaying.toggle()
        self.publishUserInterfaceState()
        self.updatePlaybackState()
    }

    func seek(by interval: TimeInterval) {
        guard let contentController = self.contentController else {
            return
        }

        let duration = contentController.duration
        self.elapsedTime = min(duration, max(0, self.elapsedTime + interval))
        self.pendingSeekTime = self.elapsedTime
        contentController.seek(self.elapsedTime) { [weak self] in
            guard let self else {
                return
            }

            self.pendingSeekTime = nil
            self.elapsedTime = self.contentController?.elapsed ?? self.elapsedTime
            self.publishUserInterfaceState()
            self.updatePlaybackState()
        }
        self.publishUserInterfaceState()
        self.updatePlaybackState()
    }

    func openVideo() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowsMultipleSelection = false
        panel.allowedContentTypes = [.movie]

        guard panel.runModal() == .OK, let url = panel.url else {
            return
        }

        self.mediaAccessController.beginAccessing(url)
        self.mediaURL = url
        self.elapsedTime = 0
        self.pendingSeekTime = nil
        self.contentController?.load(url)
        self.publishUserInterfaceState()
        self.updatePlaybackState()
    }

    private func tick() {
        if let pendingSeekTime = self.pendingSeekTime {
            self.elapsedTime = pendingSeekTime
        } else if let contentController = self.contentController, contentController.player != nil {
            self.elapsedTime = contentController.elapsed
        }

        self.publishUserInterfaceState()
        self.updatePlaybackState()
    }

    private func publishUserInterfaceState() {
        self.onStatusChange?(self.statusMessage)
        self.onPictureInPictureAvailabilityChange?(self.isPIPRuntimeAvailable && self.mediaURL != nil)

        guard let mediaURL = self.mediaURL else {
            self.onTimelineChange?("Choose a video file to enable Picture in Picture.")
            return
        }

        let duration = self.contentController?.duration ?? 0
        let state = self.isPlaying ? "playing" : "paused"
        let timeline = String(
            format: "%@: %@  %.1f / %.1f sec",
            mediaURL.lastPathComponent,
            state,
            self.elapsedTime,
            duration
        )
        self.onTimelineChange?(timeline)
        self.pipController?.playing = self.isPlaying
        self.contentController?.playing = self.isPlaying
    }

    private func updatePlaybackState() {
        guard let pipController = self.pipController, let contentController = self.contentController else {
            return
        }

        pipController.playing = self.isPlaying
        pipController.updatePlaybackState { state in
            state.contentType = 1
            state.contentDuration = contentController.duration
            state.setPlaybackRate(
                self.isPlaying ? 1 : 0,
                elapsedTime: self.elapsedTime,
                timeControlStatus: self.isPlaying ? 2 : 0
            )
        }
    }
}

extension PIPPlaybackController: PIPViewControllerDelegate {
    func pipActionPlay(_ pip: PIPViewController) {
        self.isPlaying = true
    }

    func pipActionPause(_ pip: PIPViewController) {
        self.isPlaying = false
    }

    func pipActionStop(_ pip: PIPViewController) {
        self.isPlaying = false
    }

    func pipDidClose(_ pip: PIPViewController) {
        self.pipController = nil
        self.contentController = nil
        self.publishUserInterfaceState()
    }

    func pipAction(_ pip: PIPViewController, skipInterval: TimeInterval) {
        self.seek(by: skipInterval)
    }
}
