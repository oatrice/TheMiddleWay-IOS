import SwiftUI

struct ThemedNavigationStack<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme
    private let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack {
            content
                .background(AppColors.background)
        }
        .toolbarBackground(AppColors.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(colorScheme, for: .navigationBar)
    }
}
