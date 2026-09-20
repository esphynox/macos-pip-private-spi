final class AppCoordinator {
    private let windowController = MainWindowController()
    private let playbackController = PIPPlaybackController()

    init() {
        self.playbackController.replacementWindow = self.windowController.window

        self.windowController.onStartPictureInPicture = { [weak self] in
            self?.playbackController.startPictureInPicture()
        }
        self.windowController.onTogglePlayback = { [weak self] in
            self?.playbackController.togglePlayback()
        }
        self.windowController.onSkipBackward = { [weak self] in
            self?.playbackController.seek(by: -15)
        }
        self.windowController.onSkipForward = { [weak self] in
            self?.playbackController.seek(by: 15)
        }
        self.windowController.onOpenVideo = { [weak self] in
            self?.playbackController.openVideo()
        }

        self.playbackController.onStatusChange = { [weak self] status in
            self?.windowController.setStatus(status)
        }
        self.playbackController.onTimelineChange = { [weak self] timeline in
            self?.windowController.setTimeline(timeline)
        }
        self.playbackController.onPictureInPictureAvailabilityChange = { [weak self] isAvailable in
            self?.windowController.setPictureInPictureAvailable(isAvailable)
        }
    }

    func start() {
        self.playbackController.start()
        self.windowController.show()
    }

    func stop() {
        self.playbackController.stop()
    }
}
