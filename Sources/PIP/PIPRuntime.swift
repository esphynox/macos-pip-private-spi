import Cocoa

enum PIPRuntime {
    enum RuntimeError: LocalizedError {
        case controllerUnavailable
        case requiredSelectorUnavailable(Selector)

        var errorDescription: String? {
            switch self {
            case .controllerUnavailable:
                return "PIPViewController is unavailable on this macOS installation."
            case .requiredSelectorUnavailable(let selector):
                return "PIPViewController does not implement \(NSStringFromSelector(selector))."
            }
        }
    }

    private static var isPrepared = false

    static func prepare() throws {
        if self.isPrepared {
            return
        }

        try PIPFrameworkLoader.load()
        _ = try self.controllerType()
        self.isPrepared = true
    }

    static func makeViewController() throws -> PIPViewController {
        try self.prepare()
        return try self.controllerType().init()
    }

    private static func controllerType() throws -> PIPViewController.Type {
        guard let controllerType = NSClassFromString("PIPViewController") as? PIPViewController.Type else {
            throw RuntimeError.controllerUnavailable
        }

        let requiredSelectors = [
            #selector(PIPViewController.presentAsPicture(inPicture:)),
            #selector(PIPViewController.updatePlaybackState(_:)),
        ]

        for selector in requiredSelectors where !controllerType.instancesRespond(to: selector) {
            throw RuntimeError.requiredSelectorUnavailable(selector)
        }

        return controllerType
    }
}
