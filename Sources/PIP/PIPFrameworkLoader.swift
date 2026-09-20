import Foundation

enum PIPFrameworkLoader {
    static func load() throws {
        guard let bundle = Bundle(path: "/System/Library/PrivateFrameworks/PIP.framework") else {
            throw NSError(domain: "PIPPlusExample", code: 1, userInfo: [NSLocalizedDescriptionKey: "PIP.framework is unavailable."])
        }
        try bundle.loadAndReturnError()
    }
}
