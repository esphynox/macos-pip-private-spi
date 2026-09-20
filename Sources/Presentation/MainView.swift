import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(self.viewModel.status)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(self.viewModel.timeline)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 8) {
                Button("Start Picture in Picture") {
                    self.viewModel.onStartPictureInPicture?()
                }
                .disabled(!self.viewModel.isPictureInPictureAvailable)

                Button("Play / Pause") {
                    self.viewModel.onTogglePlayback?()
                }

                Button("−15 sec") {
                    self.viewModel.onSkipBackward?()
                }

                Button("+15 sec") {
                    self.viewModel.onSkipForward?()
                }

                Button("Open Video…") {
                    self.viewModel.onOpenVideo?()
                }
            }
        }
        .padding(20)
        .frame(width: 700, height: 180, alignment: .topLeading)
    }
}
