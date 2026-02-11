import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    @AppStorage(ThemeConfig.storageKey) private var isDarkMode = false

    private var themeScheme: ColorScheme {
        ThemeConfig.colorScheme(isDarkMode: isDarkMode)
    }
    
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

struct ProfileView: View {
    @EnvironmentObject var mainVM: MainViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Profile")
                .font(AppTypography.heading)
                .foregroundStyle(AppColors.textPrimary)
            
            VStack {
                Text("Your Progress")
                    .font(AppTypography.title2)
                
                Text("Completed Lessons: \(mainVM.userProgress.completedLessons.count)")
                    .font(.title2)
                    .bold()
                
                Button("Complete Demo Lesson") {
                    mainVM.completeLesson("DEMO_IOS_\(Date().timeIntervalSince1970)")
                }
                .buttonStyle(.borderedProminent)
                .tint(AppColors.primary)
                
                Button("Reset Progress", role: .destructive) {
                    mainVM.resetProgress()
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
    }
}

#Preview {
    ContentView()
        .environmentObject(MainViewModel())
}
