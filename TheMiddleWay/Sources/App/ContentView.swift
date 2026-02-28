import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    @EnvironmentObject var viewModel: MainViewModel

    private var themeScheme: ColorScheme {
        viewModel.userProgress.themeMode == .dark ? .dark : .light
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ThemedNavigationStack {
                WisdomGardenView()
                    // .navigationTitle handling matches WisdomGardenView's internal setting
            }
            .tabItem {
                Label("Garden", systemImage: "leaf.fill")
            }
            .tag(Tab.home)
            
            ThemedNavigationStack {
                LibraryView()
                    .navigationTitle("Library")
            }
            .tabItem {
                Label("Library", systemImage: "books.vertical.fill")
            }
            .tag(Tab.library)
            
            ThemedNavigationStack {
                CoursesView()
                    .navigationTitle("Courses")
            }
            .tabItem {
                Label("Courses", systemImage: "book.fill")
            }
            .tag(Tab.courses)
            
            ThemedNavigationStack {
                ProfileView()
                    .navigationTitle("Profile")
            }
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
            .tag(Tab.profile)
        }
        .tint(AppColors.primary)
        .toolbarBackground(AppColors.background, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarColorScheme(themeScheme, for: .tabBar)
        .preferredColorScheme(themeScheme)
    }
}

enum Tab: Hashable {
    case home
    case library
    case courses
    case profile
}

// MARK: - Placeholder Views

struct LibraryView: View {
    var body: some View {
        Text("Library")
            .font(AppTypography.heading)
            .foregroundStyle(AppColors.textPrimary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColors.background)
    }
}

struct CoursesView: View {
    var body: some View {
        Text("Courses")
            .font(AppTypography.heading)
            .foregroundStyle(AppColors.textPrimary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColors.background)
    }
}



#Preview {
    ContentView()
        .environmentObject(MainViewModel())
}
