import SwiftUI

struct ThemedNavigationStack<Content: View>: View {
    @EnvironmentObject var viewModel: MainViewModel
    private let content: Content

    private var themeScheme: ColorScheme {
        viewModel.userProgress.themeMode == .dark ? .dark : .light
    }
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack {
            content
                .background(AppColors.background)
                .toolbarColorScheme(themeScheme, for: .navigationBar)
        }
    }
}
