import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ThemedNavigationStack {
                HomeView()
                    .navigationTitle("The Middle Way")
                    .navigationBarTitleDisplayMode(.large)
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
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
        .toolbarColorScheme(colorScheme, for: .tabBar)
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

struct ProfileView: View {
    var body: some View {
        Text("Profile")
            .font(AppTypography.heading)
            .foregroundStyle(AppColors.textPrimary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColors.background)
    }
}

#Preview {
    ContentView()
}
