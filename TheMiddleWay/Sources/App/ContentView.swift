import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(Tab.home)
            
            LibraryView()
                .tabItem {
                    Label("Library", systemImage: "books.vertical.fill")
                }
                .tag(Tab.library)
            
            CoursesView()
                .tabItem {
                    Label("Courses", systemImage: "book.fill")
                }
                .tag(Tab.courses)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(Tab.profile)
        }
        .tint(AppColors.primary)
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
        NavigationStack {
            Text("Library")
                .font(AppTypography.heading)
                .foregroundStyle(AppColors.textPrimary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(AppColors.background)
                .navigationTitle("Library")
        }
    }
}

struct CoursesView: View {
    var body: some View {
        NavigationStack {
            Text("Courses")
                .font(AppTypography.heading)
                .foregroundStyle(AppColors.textPrimary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(AppColors.background)
                .navigationTitle("Courses")
        }
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            Text("Profile")
                .font(AppTypography.heading)
                .foregroundStyle(AppColors.textPrimary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(AppColors.background)
                .navigationTitle("Profile")
        }
    }
}

#Preview {
    ContentView()
}
