import SwiftUI

final class MainViewController: NSHostingController<MainView> {
    init(viewModel: MainViewModel) {
        super.init(rootView: MainView(viewModel: viewModel))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
