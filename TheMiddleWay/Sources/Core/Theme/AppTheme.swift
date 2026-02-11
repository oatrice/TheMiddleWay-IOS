import SwiftUI

struct ThemedNavigationStack<Content: View>: View {
    @AppStorage(ThemeConfig.storageKey) private var isDarkMode = false
    private let content: Content

    private var themeScheme: ColorScheme {
        ThemeConfig.colorScheme(isDarkMode: isDarkMode)
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
