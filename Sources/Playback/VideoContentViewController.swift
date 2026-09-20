import AVKit
import Cocoa

final class VideoContentViewController: NSViewController {
    let playerView = AVPlayerView()
    var player: AVPlayer?

    var elapsed: TimeInterval {
        let time = self.player?.currentTime().seconds ?? 0
        return time.isFinite ? time : 0
    }

    var playing = false {
        didSet {
            if self.playing {
                self.player?.play()
            } else {
                self.player?.pause()
            }
        }
    }

    var duration: TimeInterval {
        guard let duration = self.player?.currentItem?.duration.seconds, duration.isFinite else {
            return 0
        }

        return duration
    }

    override func loadView() {
        let container = NSView(frame: NSRect(x: 0, y: 0, width: 640, height: 360))
        container.wantsLayer = true
        container.layer?.backgroundColor = NSColor.systemIndigo.cgColor
        self.playerView.frame = container.bounds
        self.playerView.autoresizingMask = [.width, .height]
        self.playerView.controlsStyle = .floating
        container.addSubview(self.playerView)
        self.view = container
    }

    func load(_ url: URL) {
        self.player = AVPlayer(url: url)
        self.playerView.player = self.player

        if self.playing {
            self.player?.play()
        }
    }

    func seek(_ seconds: TimeInterval, completion: @escaping () -> Void = {}) {
        guard let player = self.player else {
            completion()
            return
        }

        player.seek(to: CMTime(seconds: seconds, preferredTimescale: 600)) { _ in
            DispatchQueue.main.async(execute: completion)
        }
    }
}
