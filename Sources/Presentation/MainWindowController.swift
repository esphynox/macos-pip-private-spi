import Cocoa

final class MainWindowController: NSWindowController {
    private let viewModel: MainViewModel
    private let mainViewController: MainViewController

    var onStartPictureInPicture: (() -> Void)? {
        get { self.viewModel.onStartPictureInPicture }
        set { self.viewModel.onStartPictureInPicture = newValue }
    }

    var onTogglePlayback: (() -> Void)? {
        get { self.viewModel.onTogglePlayback }
        set { self.viewModel.onTogglePlayback = newValue }
    }

    var onSkipBackward: (() -> Void)? {
        get { self.viewModel.onSkipBackward }
        set { self.viewModel.onSkipBackward = newValue }
    }

    var onSkipForward: (() -> Void)? {
        get { self.viewModel.onSkipForward }
        set { self.viewModel.onSkipForward = newValue }
    }

    var onOpenVideo: (() -> Void)? {
        get { self.viewModel.onOpenVideo }
        set { self.viewModel.onOpenVideo = newValue }
    }

    init() {
        let viewModel = MainViewModel()
        self.viewModel = viewModel
        self.mainViewController = MainViewController(viewModel: viewModel)

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 700, height: 180),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )

        super.init(window: window)
        window.title = "PIP"
        window.contentViewController = self.mainViewController
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show() {
        self.window?.center()
        self.showWindow(nil)
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func setPictureInPictureAvailable(_ isAvailable: Bool) {
        self.viewModel.isPictureInPictureAvailable = isAvailable
    }

    func setStatus(_ status: String) {
        self.viewModel.status = status
    }

    func setTimeline(_ timeline: String) {
        self.viewModel.timeline = timeline
    }
}
