import Foundation

final class MediaAccessController {
    private var securityScopedURL: URL?

    func beginAccessing(_ url: URL) {
        self.stopAccessing()

        if url.startAccessingSecurityScopedResource() {
            self.securityScopedURL = url
        }
    }

    func stopAccessing() {
        self.securityScopedURL?.stopAccessingSecurityScopedResource()
        self.securityScopedURL = nil
    }
}
