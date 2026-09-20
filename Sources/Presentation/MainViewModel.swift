import Combine
import Foundation

final class MainViewModel: ObservableObject {
    @Published var status = ""
    @Published var timeline = ""
    @Published var isPictureInPictureAvailable = false

    var onStartPictureInPicture: (() -> Void)?
    var onTogglePlayback: (() -> Void)?
    var onSkipBackward: (() -> Void)?
    var onSkipForward: (() -> Void)?
    var onOpenVideo: (() -> Void)?
}
