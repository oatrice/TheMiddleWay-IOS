# PR Draft Prompt

You are an AI assistant helping to create a Pull Request description.
    
TASK: [Infrastructure] Persistence Layer: LocalStorage System for Progress Tracking
ISSUE: {
  "title": "[Infrastructure] Persistence Layer: LocalStorage System for Progress Tracking",
  "number": 6
}

GIT CONTEXT:
COMMITS:
a126505 feat: [Infrastructure] Persistence Layer: LocalStorage S...
afe4253 refactor: migrate theme to EnvironmentObject and improve thread safety
0b8f969 fix(theme): remove redundant toolbar background from navigation stack
3264dd9 feat(progress): add user progress tracking with persistence
690e822 feat(ios): add UserProgress model and PersistenceService
29187cd ci: update xcode version to latest-stable
9d387a5 ci: fix secrets access in condition
5723714 ci: add workflow_dispatch trigger
950f59e ci: enable PR builds with simulator check

STATS:
.github/workflows/ios-testflight.yml               |  21 +++-
 CHANGELOG.md                                       |  11 ++
 README.md                                          |   2 +
 TheMiddleWay.xcodeproj/project.pbxproj             |  42 ++++++-
 TheMiddleWay/Sources/App/ContentView.swift         |  42 +++++--
 .../Sources/App/Core/Models/UserProgress.swift     |  23 ++++
 .../App/Core/Services/PersistenceService.swift     |  54 +++++++++
 .../Sources/App/Core/Theme/AppColors.swift         |  86 ++++++++++++++
 TheMiddleWay/Sources/App/Core/Theme/AppTheme.swift |  24 ++++
 .../Sources/App/Core/Theme/AppTypography.swift     |  66 +++++++++++
 .../Sources/App/Core/Theme/ThemeConfig.swift       |  17 +++
 TheMiddleWay/Sources/App/TheMiddleWayApp.swift     |   3 +
 .../Sources/Core/Models/UserProgress.swift         |  23 ++++
 .../Sources/Core/Services/PersistenceService.swift |  54 +++++++++
 TheMiddleWay/Sources/Core/Theme/AppTheme.swift     |   6 +-
 .../Sources/Core/ViewModels/MainViewModel.swift    |  52 +++++++++
 code_review.md                                     | 127 +++++++++++++++++++--
 17 files changed, 626 insertions(+), 27 deletions(-)

KEY FILE DIFFS:
diff --git a/TheMiddleWay/Sources/App/ContentView.swift b/TheMiddleWay/Sources/App/ContentView.swift
index eb569b2..7448c39 100644
--- a/TheMiddleWay/Sources/App/ContentView.swift
+++ b/TheMiddleWay/Sources/App/ContentView.swift
@@ -2,10 +2,10 @@ import SwiftUI
 
 struct ContentView: View {
     @State private var selectedTab: Tab = .home
-    @AppStorage(ThemeConfig.storageKey) private var isDarkMode = false
+    @EnvironmentObject var viewModel: MainViewModel
 
     private var themeScheme: ColorScheme {
-        ThemeConfig.colorScheme(isDarkMode: isDarkMode)
+        viewModel.userProgress.themeMode == .dark ? .dark : .light
     }
     
     var body: some View {
@@ -85,15 +85,43 @@ struct CoursesView: View {
 }
 
 struct ProfileView: View {
+    @EnvironmentObject var mainVM: MainViewModel
+
     var body: some View {
-        Text("Profile")
-            .font(AppTypography.heading)
-            .foregroundStyle(AppColors.textPrimary)
-            .frame(maxWidth: .infinity, maxHeight: .infinity)
-            .background(AppColors.background)
+        VStack(spacing: 20) {
+            Text("Profile")
+                .font(AppTypography.heading)
+                .foregroundStyle(AppColors.textPrimary)
+            
+            VStack {
+                Text("Your Progress")
+                    .font(AppTypography.title2)
+                
+                Text("Completed Lessons: \(mainVM.userProgress.completedLessons.count)")
+                    .font(.title2)
+                    .bold()
+                
+                Button("Complete Demo Lesson") {
+                    mainVM.completeLesson("DEMO_IOS_\(Date().timeIntervalSince1970)")
+                }
+                .buttonStyle(.borderedProminent)
+                .tint(AppColors.primary)
+                
+                Button("Reset Progress", role: .destructive) {
+                    mainVM.resetProgress()
+                }
+                .buttonStyle(.bordered)
+            }
+            .padding()
+            .background(Color.secondary.opacity(0.1))
+            .cornerRadius(16)
+        }
+        .frame(maxWidth: .infinity, maxHeight: .infinity)
+        .background(AppColors.background)
     }
 }
 
 #Preview {
     ContentView()
+        .environmentObject(MainViewModel())
 }
diff --git a/TheMiddleWay/Sources/App/Core/Models/UserProgress.swift b/TheMiddleWay/Sources/App/Core/Models/UserProgress.swift
new file mode 100644
index 0000000..4486fd4
--- /dev/null
+++ b/TheMiddleWay/Sources/App/Core/Models/UserProgress.swift
@@ -0,0 +1,23 @@
+import Foundation
+
+struct UserProgress: Codable, Equatable {
+    var version: Int = 1
+    var themeMode: ThemeMode = .light
+    var language: Language = .thai
+    var completedLessons: [String] = []
+    var bookmarks: [String] = []
+    var lastVisited: Date?
+    
+    // Default values
+    static let defaultProgress = UserProgress()
+}
+
+enum ThemeMode: String, Codable {
+    case light
+    case dark
+}
+
+enum Language: String, Codable {
+    case thai = "th"
+    case english = "en"
+}
diff --git a/TheMiddleWay/Sources/App/Core/Services/PersistenceService.swift b/TheMiddleWay/Sources/App/Core/Services/PersistenceService.swift
new file mode 100644
index 0000000..1855e5c
--- /dev/null
+++ b/TheMiddleWay/Sources/App/Core/Services/PersistenceService.swift
@@ -0,0 +1,54 @@
+import Foundation
+
+protocol PersistenceService {
+    func saveProgress(_ progress: UserProgress) -> Bool
+    func loadProgress() -> UserProgress?
+    func clearProgress() -> Bool
+    func updateProgress(_ update: (inout UserProgress) -> Void) -> Bool
+}
+
+class PersistenceServiceImpl: PersistenceService {
+    
+    private let userDefaults: UserDefaults
+    private let key = "theMiddleWay.progress"
+    
+    init(userDefaults: UserDefaults = .standard) {
+        self.userDefaults = userDefaults
+    }
+    
+    func saveProgress(_ progress: UserProgress) -> Bool {
+        do {
+            let data = try JSONEncoder().encode(progress)
+            userDefaults.set(data, forKey: key)
+            return true
+        } catch {
+            print("Error saving progress: \(error)")
+            return false
+        }
+    }
+    
+    func loadProgress() -> UserProgress? {
+        guard let data = userDefaults.data(forKey: key) else {
+            return nil
+        }
+        
+        do {
+            let progress = try JSONDecoder().decode(UserProgress.self, from: data)
+            return progress
+        } catch {
+            print("Error loading progress: \(error)")
+            return nil
+        }
+    }
+    
+    func clearProgress() -> Bool {
+        userDefaults.removeObject(forKey: key)
+        return true
+    }
+    
+    func updateProgress(_ update: (inout UserProgress) -> Void) -> Bool {
+        var current = loadProgress() ?? UserProgress.defaultProgress
+        update(&current)
+        return saveProgress(current)
+    }
+}
diff --git a/TheMiddleWay/Sources/App/Core/Theme/AppColors.swift b/TheMiddleWay/Sources/App/Core/Theme/AppColors.swift
new file mode 100644
index 0000000..9fcf118
--- /dev/null
+++ b/TheMiddleWay/Sources/App/Core/Theme/AppColors.swift
@@ -0,0 +1,86 @@
+import SwiftUI
+import UIKit
+
+/// The Middle Way - Adaptive Color Palette
+/// Light: Bright Sky (ฟ้าสดใส)
+/// Dark: Deep Cosmos (matching Web/Android design system)
+enum AppColors {
+    // MARK: - Light Palette — Bright Sky
+    
+    enum Light {
+        static let background = Color(hex: "#EFF6FF")   // Sky White
+        static let primary = Color(hex: "#2563EB")       // Bright Blue
+        static let surface = Color(hex: "#DBEAFE")       // Sky Surface
+        static let textPrimary = Color(hex: "#1E3A5F")   // Deep Blue
+        static let textSecondary = Color(hex: "#64748B")  // Blue Gray
+        static let border = Color(hex: "#BFDBFE")         // Sky Border
+        static let success = Color(hex: "#10B981")
+        static let warning = Color(hex: "#F59E0B")
+        static let error = Color(hex: "#EF4444")
+    }
+    
+    // MARK: - Dark Palette
+    
+    enum Dark {
+        static let background = Color(hex: "#0A192F") // Navy
+        static let primary = Color(hex: "#F59E0B") // Amber
+        static let surface = Color(hex: "#1E293B") // Slate Dark
+        static let textPrimary = Color(hex: "#F8FAFC") // Ivory
+        static let textSecondary = Color(hex: "#94A3B8") // Slate Light
+        static let border = Color(hex: "#334155")
+        static let success = Color(hex: "#10B981")
+        static let warning = Color(hex: "#F59E0B")
+        static let error = Color(hex: "#EF4444")
+    }
+    
+    // MARK: - Dynamic Tokens
+    
+    static let background = Color.dynamic(light: Light.background, dark: Dark.background)
+    static let primary = Color.dynamic(light: Light.primary, dark: Dark.primary)
+    static let surface = Color.dynamic(light: Light.surface, dark: Dark.surface)
+    static let textPrimary = Color.dynamic(light: Light.textPrimary, dark: Dark.textPrimary)
+    static let textSecondary = Color.dynamic(light: Light.textSecondary, dark: Dark.textSecondary)
+    static let border = Color.dynamic(light: Light.border, dark: Dark.border)
+    static let success = Color.dynamic(light: Light.success, dark: Dark.success)
+    static let warning = Color.dynamic(light: Light.warning, dark: Dark.warning)
+    static let error = Color.dynamic(light: Light.error, dark: Dark.error)
+}
+
+// MARK: - Color Extensions
+
+extension Color {
+    static func dynamic(light: Color, dark: Color) -> Color {
+        Color(UIColor { trait in
+            trait.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
+        })
+    }
+    
+    init(hex: String) {
+        self.init(UIColor(hex: hex))
+    }
+}
+
+extension UIColor {
+    convenience init(hex: String) {
+        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
+        var int: UInt64 = 0
+        Scanner(string: hex).scanHexInt64(&int)
+        let a, r, g, b: UInt64
+        switch hex.count {
+        case 3: // RGB (12-bit)
+            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
+        case 6: // RGB (24-bit)
+            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
+        case 8: // ARGB (32-bit)
+            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
+        default:
+            (a, r, g, b) = (255, 0, 0, 0)
+        }
+        self.init(
+            red: CGFloat(r) / 255,
+            green: CGFloat(g) / 255,
+            blue: CGFloat(b) / 255,
+            alpha: CGFloat(a) / 255
+        )
+    }
+}
diff --git a/TheMiddleWay/Sources/App/Core/Theme/AppTheme.swift b/TheMiddleWay/Sources/App/Core/Theme/AppTheme.swift
new file mode 100644
index 0000000..998b891
--- /dev/null
+++ b/TheMiddleWay/Sources/App/Core/Theme/AppTheme.swift
@@ -0,0 +1,24 @@
+import SwiftUI
+
+struct ThemedNavigationStack<Content: View>: View {
+    @AppStorage(ThemeConfig.storageKey) private var isDarkMode = false
+    private let content: Content
+
+    private var themeScheme: ColorScheme {
+        ThemeConfig.colorScheme(isDarkMode: isDarkMode)
+    }
+    
+    init(@ViewBuilder content: () -> Content) {
+        self.content = content()
+    }
+    
+    var body: some View {
+        NavigationStack {
+            content
+                .background(AppColors.background)
+                .toolbarBackground(AppColors.background, for: .navigationBar)
+                .toolbarBackground(.visible, for: .navigationBar)
+                .toolbarColorScheme(themeScheme, for: .navigationBar)
+        }
+    }
+}
diff --git a/TheMiddleWay/Sources/App/Core/Theme/AppTypography.swift b/TheMiddleWay/Sources/App/Core/Theme/AppTypography.swift
new file mode 100644
index 0000000..6a72562
--- /dev/null
+++ b/TheMiddleWay/Sources/App/Core/Theme/AppTypography.swift
@@ -0,0 +1,66 @@
+import SwiftUI
+
+/// The Middle Way - Typography System
+/// Matching the Web design system with Playfair Display (headings) and Inter (body)
+enum AppTypography {
+    // MARK: - Headings (Serif style - like Playfair Display)
+    
+    /// Large title - 34pt Bold Serif
+    static let largeTitle = Font.system(size: 34, weight: .bold, design: .serif)
+    
+    /// Title 1 - 28pt Bold Serif
+    static let title1 = Font.system(size: 28, weight: .bold, design: .serif)
+    
+    /// Title 2 - 22pt Semibold Serif
+    static let title2 = Font.system(size: 22, weight: .semibold, design: .serif)
+    
+    /// Title 3 - 20pt Semibold Serif
+    static let title3 = Font.system(size: 20, weight: .semibold, design: .serif)
+    
+    /// Heading - Default heading style
+    static let heading = Font.system(size: 24, weight: .bold, design: .serif)
+    
+    // MARK: - Body Text (Sans-serif style - like Inter)
+    
+    /// Body Large - 17pt Regular
+    static let bodyLarge = Font.system(size: 17, weight: .regular, design: .default)
+    
+    /// Body - Standard body text - 15pt Regular
+    static let body = Font.system(size: 15, weight: .regular, design: .default)
+    
+    /// Body Small - 13pt Regular
+    static let bodySmall = Font.system(size: 13, weight: .regular, design: .default)
+    
+    // MARK: - UI Elements
+    
+    /// Button text - 16pt Semibold
+    static let button = Font.system(size: 16, weight: .semibold, design: .default)
+    
+    /// Caption - 12pt Regular
+    static let caption = Font.system(size: 12, weight: .regular, design: .default)
+    
+    /// Label - 14pt Medium
+    static let label = Font.system(size: 14, weight: .medium, design: .default)
+}
+
+// MARK: - View Extension for Typography
+
+extension View {
+    func headingStyle() -> some View {
+        self
+            .font(AppTypography.heading)
+            .foregroundStyle(AppColors.textPrimary)
+    }
+    
+    func bodyStyle() -> some View {
+        self
+            .font(AppTypography.body)
+            .foregroundStyle(AppColors.textPrimary)
+    }
+    
+    func captionStyle() -> some View {
+        self
+            .font(AppTypography.caption)
+            .foregroundStyle(AppColors.textSecondary)
+    }
+}
diff --git a/TheMiddleWay/Sources/App/Core/Theme/ThemeConfig.swift b/TheMiddleWay/Sources/App/Core/Theme/ThemeConfig.swift
new file mode 100644
index 0000000..5fc429d
--- /dev/null
+++ b/TheMiddleWay/Sources/App/Core/Theme/ThemeConfig.swift
@@ -0,0 +1,17 @@
+import SwiftUI
+
+enum ThemeConfig {
+    static let storageKey = "isDarkMode"
+
+    static func colorScheme(isDarkMode: Bool) -> ColorScheme {
+        isDarkMode ? .dark : .light
+    }
+
+    static func toggleIconName(isDarkMode: Bool) -> String {
+        isDarkMode ? "sun.max.fill" : "moon.fill"
+    }
+
+    static func toggleLabel(isDarkMode: Bool) -> String {
+        isDarkMode ? "Switch to Light Mode" : "Switch to Dark Mode"
+    }
+}
diff --git a/TheMiddleWay/Sources/App/TheMiddleWayApp.swift b/TheMiddleWay/Sources/App/TheMiddleWayApp.swift
index 19d4016..7467023 100644
--- a/TheMiddleWay/Sources/App/TheMiddleWayApp.swift
+++ b/TheMiddleWay/Sources/App/TheMiddleWayApp.swift
@@ -2,9 +2,12 @@ import SwiftUI
 
 @main
 struct TheMiddleWayApp: App {
+    @StateObject private var viewModel = MainViewModel()
+
     var body: some Scene {
         WindowGroup {
             ContentView()
+                .environmentObject(viewModel)
         }
     }
 }
diff --git a/TheMiddleWay/Sources/Core/Models/UserProgress.swift b/TheMiddleWay/Sources/Core/Models/UserProgress.swift
new file mode 100644
index 0000000..4486fd4
--- /dev/null
+++ b/TheMiddleWay/Sources/Core/Models/UserProgress.swift
@@ -0,0 +1,23 @@
+import Foundation
+
+struct UserProgress: Codable, Equatable {
+    var version: Int = 1
+    var themeMode: ThemeMode = .light
+    var language: Language = .thai
+    var completedLessons: [String] = []
+    var bookmarks: [String] = []
+    var lastVisited: Date?
+    
+    // Default values
+    static let defaultProgress = UserProgress()
+}
+
+enum ThemeMode: String, Codable {
+    case light
+    case dark
+}
+
+enum Language: String, Codable {
+    case thai = "th"
+    case english = "en"
+}
diff --git a/TheMiddleWay/Sources/Core/Services/PersistenceService.swift b/TheMiddleWay/Sources/Core/Services/PersistenceService.swift
new file mode 100644
index 0000000..1855e5c
--- /dev/null
+++ b/TheMiddleWay/Sources/Core/Services/PersistenceService.swift
@@ -0,0 +1,54 @@
+import Foundation
+
+protocol PersistenceService {
+    func saveProgress(_ progress: UserProgress) -> Bool
+    func loadProgress() -> UserProgress?
+    func clearProgress() -> Bool
+    func updateProgress(_ update: (inout UserProgress) -> Void) -> Bool
+}
+
+class PersistenceServiceImpl: PersistenceService {
+    
+    private let userDefaults: UserDefaults
+    private let key = "theMiddleWay.progress"
+    
+    init(userDefaults: UserDefaults = .standard) {
+        self.userDefaults = userDefaults
+    }
+    
+    func saveProgress(_ progress: UserProgress) -> Bool {
+        do {
+            let data = try JSONEncoder().encode(progress)
+            userDefaults.set(data, forKey: key)
+            return true
+        } catch {
+            print("Error saving progress: \(error)")
+            return false
+        }
+    }
+    
+    func loadProgress() -> UserProgress? {
+        guard let data = userDefaults.data(forKey: key) else {
+            return nil
+        }
+        
+        do {
+            let progress = try JSONDecoder().decode(UserProgress.self, from: data)
+            return progress
+        } catch {
+            print("Error loading progress: \(error)")
+            return nil
+        }
+    }
+    
+    func clearProgress() -> Bool {
+        userDefaults.removeObject(forKey: key)
+        return true
+    }
+    
+    func updateProgress(_ update: (inout UserProgress) -> Void) -> Bool {
+        var current = loadProgress() ?? UserProgress.defaultProgress
+        update(&current)
+        return saveProgress(current)
+    }
+}
diff --git a/TheMiddleWay/Sources/Core/Theme/AppTheme.swift b/TheMiddleWay/Sources/Core/Theme/AppTheme.swift
index 998b891..ad65dae 100644
--- a/TheMiddleWay/Sources/Core/Theme/AppTheme.swift
+++ b/TheMiddleWay/Sources/Core/Theme/AppTheme.swift
@@ -1,11 +1,11 @@
 import SwiftUI
 
 struct ThemedNavigationStack<Content: View>: View {
-    @AppStorage(ThemeConfig.storageKey) private var isDarkMode = false
+    @EnvironmentObject var viewModel: MainViewModel
     private let content: Content
 
     private var themeScheme: ColorScheme {
-        ThemeConfig.colorScheme(isDarkMode: isDarkMode)
+        viewModel.userProgress.themeMode == .dark ? .dark : .light
     }
     
     init(@ViewBuilder content: () -> Content) {
@@ -16,8 +16,6 @@ struct ThemedNavigationStack<Content: View>: View {
         NavigationStack {
             content
                 .background(AppColors.background)
-                .toolbarBackground(AppColors.background, for: .navigationBar)
-                .toolbarBackground(.visible, for: .navigationBar)
                 .toolbarColorScheme(themeScheme, for: .navigationBar)
         }
     }
diff --git a/TheMiddleWay/Sources/Core/ViewModels/MainViewModel.swift b/TheMiddleWay/Sources/Core/ViewModels/MainViewModel.swift
new file mode 100644
index 0000000..d71058f
--- /dev/null
+++ b/TheMiddleWay/Sources/Core/ViewModels/MainViewModel.swift
@@ -0,0 +1,52 @@
+import SwiftUI
+import Combine
+
+class MainViewModel: ObservableObject {
+    @Published var userProgress: UserProgress
+    private let persistenceService: PersistenceService
+    
+    init(service: PersistenceService = PersistenceServiceImpl()) {
+        self.persistenceService = service
+        // Load existing progress or default
+        self.userProgress = service.loadProgress() ?? UserProgress.defaultProgress
+    }
+    
+    private func reloadProgress() {
+        if let progress = persistenceService.loadProgress() {
+            // Ensure UI updates happen on the main thread
+            DispatchQueue.main.async {
+                self.userProgress = progress
+            }
+        }
+    }
+    
+    func completeLesson(_ lessonId: String) {
+        let updated = persistenceService.updateProgress { progress in
+            if !progress.completedLessons.contains(lessonId) {
+                progress.completedLessons.append(lessonId)
+                progress.lastVisited = Date()
+            }
+        }
+        if updated {
+            reloadProgress()
+        }
+    }
+    
+    func toggleTheme(isDark: Bool) {
+        let updated = persistenceService.updateProgress { progress in
+            progress.themeMode = isDark ? .dark : .light
+        }
+        if updated {
+            reloadProgress()
+        }
+    }
+    
+    func resetProgress() {
+        if persistenceService.clearProgress() {
+            // After clearing, the new default state needs to be set
+            DispatchQueue.main.async {
+                self.userProgress = UserProgress.defaultProgress
+            }
+        }
+    }
+}

PR TEMPLATE:


INSTRUCTIONS:
1. Generate a comprehensive PR description in Markdown format.
2. If a template is provided, fill it out intelligently.
3. If no template, use a standard structure: Summary, Changes, Impact.
4. Focus on 'Why' and 'What'.
5. Do not include 'Here is the PR description' preamble. Just the body.
6. IMPORTANT: Always use FULL URLs for links to issues and other PRs (e.g., https://github.com/owner/repo/issues/123), do NOT use short syntax (e.g., #123) to ensuring proper linking across platforms.
