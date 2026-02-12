# PR Draft Prompt

You are an AI assistant helping to create a Pull Request description.
    
TASK: [Feature] Onboarding: Welcome Screen & "Authentic Wisdom" Introduction
ISSUE: {
  "title": "[Feature] Onboarding: Welcome Screen & \"Authentic Wisdom\" Introduction",
  "number": 11,
  "body": ""
}

GIT CONTEXT:
COMMITS:
9ba6a38 chore(release): bump version to 0.6.0 and update changelog
79a4146 ✨ feat(repository): Introduce dependency injection for URLSession
010653b feat(wisdom-garden): add read-only toast notification support
2c24233 feat: add onboarding service and view components

STATS:
CHANGELOG.md                                       |  12 ++
 README.md                                          |   2 +
 TheMiddleWay.xcodeproj/project.pbxproj             |  20 ++-
 .../onboarding_path.imageset/Contents.json         |  21 ++++
 .../onboarding_path.imageset/image.png             | Bin 0 -> 31889 bytes
 .../onboarding_practice.imageset/Contents.json     |  21 ++++
 .../onboarding_practice.imageset/image.png         | Bin 0 -> 82036 bytes
 .../onboarding_welcome.imageset/Contents.json      |  21 ++++
 .../onboarding_welcome.imageset/image.png          | Bin 0 -> 20545 bytes
 .../onboarding_wisdom.imageset/Contents.json       |  21 ++++
 .../onboarding_wisdom.imageset/image.png           | Bin 0 -> 36364 bytes
 .../Sources/App/Core/Models/UserProgress.swift     |  23 ----
 .../App/Core/Services/PersistenceService.swift     |  54 --------
 .../Sources/App/Core/Theme/AppColors.swift         |  86 -------------
 TheMiddleWay/Sources/App/Core/Theme/AppTheme.swift |  24 ----
 .../Sources/App/Core/Theme/AppTypography.swift     |  66 ----------
 .../Sources/App/Core/Theme/ThemeConfig.swift       |  17 ---
 TheMiddleWay/Sources/App/TheMiddleWayApp.swift     |  10 +-
 .../Sources/Core/Services/OnboardingService.swift  |  18 +++
 .../Features/Onboarding/OnboardingView.swift       |  93 ++++++++++++++
 .../Data/NetworkWisdomGardenRepository.swift       |  78 +++++++++---
 .../WisdomGarden/Views/WisdomGardenView.swift      | 136 ++++++++++++---------
 .../WisdomGardenRepositoryTests.swift              | 108 ++++++++++++++++
 code_review.md                                     |  54 +-------
 24 files changed, 491 insertions(+), 394 deletions(-)

KEY FILE DIFFS:
diff --git a/TheMiddleWay/Sources/App/Core/Models/UserProgress.swift b/TheMiddleWay/Sources/App/Core/Models/UserProgress.swift
deleted file mode 100644
index 4486fd4..0000000
--- a/TheMiddleWay/Sources/App/Core/Models/UserProgress.swift
+++ /dev/null
@@ -1,23 +0,0 @@
-import Foundation
-
-struct UserProgress: Codable, Equatable {
-    var version: Int = 1
-    var themeMode: ThemeMode = .light
-    var language: Language = .thai
-    var completedLessons: [String] = []
-    var bookmarks: [String] = []
-    var lastVisited: Date?
-    
-    // Default values
-    static let defaultProgress = UserProgress()
-}
-
-enum ThemeMode: String, Codable {
-    case light
-    case dark
-}
-
-enum Language: String, Codable {
-    case thai = "th"
-    case english = "en"
-}
diff --git a/TheMiddleWay/Sources/App/Core/Services/PersistenceService.swift b/TheMiddleWay/Sources/App/Core/Services/PersistenceService.swift
deleted file mode 100644
index 1855e5c..0000000
--- a/TheMiddleWay/Sources/App/Core/Services/PersistenceService.swift
+++ /dev/null
@@ -1,54 +0,0 @@
-import Foundation
-
-protocol PersistenceService {
-    func saveProgress(_ progress: UserProgress) -> Bool
-    func loadProgress() -> UserProgress?
-    func clearProgress() -> Bool
-    func updateProgress(_ update: (inout UserProgress) -> Void) -> Bool
-}
-
-class PersistenceServiceImpl: PersistenceService {
-    
-    private let userDefaults: UserDefaults
-    private let key = "theMiddleWay.progress"
-    
-    init(userDefaults: UserDefaults = .standard) {
-        self.userDefaults = userDefaults
-    }
-    
-    func saveProgress(_ progress: UserProgress) -> Bool {
-        do {
-            let data = try JSONEncoder().encode(progress)
-            userDefaults.set(data, forKey: key)
-            return true
-        } catch {
-            print("Error saving progress: \(error)")
-            return false
-        }
-    }
-    
-    func loadProgress() -> UserProgress? {
-        guard let data = userDefaults.data(forKey: key) else {
-            return nil
-        }
-        
-        do {
-            let progress = try JSONDecoder().decode(UserProgress.self, from: data)
-            return progress
-        } catch {
-            print("Error loading progress: \(error)")
-            return nil
-        }
-    }
-    
-    func clearProgress() -> Bool {
-        userDefaults.removeObject(forKey: key)
-        return true
-    }
-    
-    func updateProgress(_ update: (inout UserProgress) -> Void) -> Bool {
-        var current = loadProgress() ?? UserProgress.defaultProgress
-        update(&current)
-        return saveProgress(current)
-    }
-}
diff --git a/TheMiddleWay/Sources/App/Core/Theme/AppColors.swift b/TheMiddleWay/Sources/App/Core/Theme/AppColors.swift
deleted file mode 100644
index 9fcf118..0000000
--- a/TheMiddleWay/Sources/App/Core/Theme/AppColors.swift
+++ /dev/null
@@ -1,86 +0,0 @@
-import SwiftUI
-import UIKit
-
-/// The Middle Way - Adaptive Color Palette
-/// Light: Bright Sky (ฟ้าสดใส)
-/// Dark: Deep Cosmos (matching Web/Android design system)
-enum AppColors {
-    // MARK: - Light Palette — Bright Sky
-    
-    enum Light {
-        static let background = Color(hex: "#EFF6FF")   // Sky White
-        static let primary = Color(hex: "#2563EB")       // Bright Blue
-        static let surface = Color(hex: "#DBEAFE")       // Sky Surface
-        static let textPrimary = Color(hex: "#1E3A5F")   // Deep Blue
-        static let textSecondary = Color(hex: "#64748B")  // Blue Gray
-        static let border = Color(hex: "#BFDBFE")         // Sky Border
-        static let success = Color(hex: "#10B981")
-        static let warning = Color(hex: "#F59E0B")
-        static let error = Color(hex: "#EF4444")
-    }
-    
-    // MARK: - Dark Palette
-    
-    enum Dark {
-        static let background = Color(hex: "#0A192F") // Navy
-        static let primary = Color(hex: "#F59E0B") // Amber
-        static let surface = Color(hex: "#1E293B") // Slate Dark
-        static let textPrimary = Color(hex: "#F8FAFC") // Ivory
-        static let textSecondary = Color(hex: "#94A3B8") // Slate Light
-        static let border = Color(hex: "#334155")
-        static let success = Color(hex: "#10B981")
-        static let warning = Color(hex: "#F59E0B")
-        static let error = Color(hex: "#EF4444")
-    }
-    
-    // MARK: - Dynamic Tokens
-    
-    static let background = Color.dynamic(light: Light.background, dark: Dark.background)
-    static let primary = Color.dynamic(light: Light.primary, dark: Dark.primary)
-    static let surface = Color.dynamic(light: Light.surface, dark: Dark.surface)
-    static let textPrimary = Color.dynamic(light: Light.textPrimary, dark: Dark.textPrimary)
-    static let textSecondary = Color.dynamic(light: Light.textSecondary, dark: Dark.textSecondary)
-    static let border = Color.dynamic(light: Light.border, dark: Dark.border)
-    static let success = Color.dynamic(light: Light.success, dark: Dark.success)
-    static let warning = Color.dynamic(light: Light.warning, dark: Dark.warning)
-    static let error = Color.dynamic(light: Light.error, dark: Dark.error)
-}
-
-// MARK: - Color Extensions
-
-extension Color {
-    static func dynamic(light: Color, dark: Color) -> Color {
-        Color(UIColor { trait in
-            trait.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
-        })
-    }
-    
-    init(hex: String) {
-        self.init(UIColor(hex: hex))
-    }
-}
-
-extension UIColor {
-    convenience init(hex: String) {
-        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
-        var int: UInt64 = 0
-        Scanner(string: hex).scanHexInt64(&int)
-        let a, r, g, b: UInt64
-        switch hex.count {
-        case 3: // RGB (12-bit)
-            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
-        case 6: // RGB (24-bit)
-            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
-        case 8: // ARGB (32-bit)
-            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
-        default:
-            (a, r, g, b) = (255, 0, 0, 0)
-        }
-        self.init(
-            red: CGFloat(r) / 255,
-            green: CGFloat(g) / 255,
-            blue: CGFloat(b) / 255,
-            alpha: CGFloat(a) / 255
-        )
-    }
-}
diff --git a/TheMiddleWay/Sources/App/Core/Theme/AppTheme.swift b/TheMiddleWay/Sources/App/Core/Theme/AppTheme.swift
deleted file mode 100644
index 998b891..0000000
--- a/TheMiddleWay/Sources/App/Core/Theme/AppTheme.swift
+++ /dev/null
@@ -1,24 +0,0 @@
-import SwiftUI
-
-struct ThemedNavigationStack<Content: View>: View {
-    @AppStorage(ThemeConfig.storageKey) private var isDarkMode = false
-    private let content: Content
-
-    private var themeScheme: ColorScheme {
-        ThemeConfig.colorScheme(isDarkMode: isDarkMode)
-    }
-    
-    init(@ViewBuilder content: () -> Content) {
-        self.content = content()
-    }
-    
-    var body: some View {
-        NavigationStack {
-            content
-                .background(AppColors.background)
-                .toolbarBackground(AppColors.background, for: .navigationBar)
-                .toolbarBackground(.visible, for: .navigationBar)
-                .toolbarColorScheme(themeScheme, for: .navigationBar)
-        }
-    }
-}
diff --git a/TheMiddleWay/Sources/App/Core/Theme/AppTypography.swift b/TheMiddleWay/Sources/App/Core/Theme/AppTypography.swift
deleted file mode 100644
index 6a72562..0000000
--- a/TheMiddleWay/Sources/App/Core/Theme/AppTypography.swift
+++ /dev/null
@@ -1,66 +0,0 @@
-import SwiftUI
-
-/// The Middle Way - Typography System
-/// Matching the Web design system with Playfair Display (headings) and Inter (body)
-enum AppTypography {
-    // MARK: - Headings (Serif style - like Playfair Display)
-    
-    /// Large title - 34pt Bold Serif
-    static let largeTitle = Font.system(size: 34, weight: .bold, design: .serif)
-    
-    /// Title 1 - 28pt Bold Serif
-    static let title1 = Font.system(size: 28, weight: .bold, design: .serif)
-    
-    /// Title 2 - 22pt Semibold Serif
-    static let title2 = Font.system(size: 22, weight: .semibold, design: .serif)
-    
-    /// Title 3 - 20pt Semibold Serif
-    static let title3 = Font.system(size: 20, weight: .semibold, design: .serif)
-    
-    /// Heading - Default heading style
-    static let heading = Font.system(size: 24, weight: .bold, design: .serif)
-    
-    // MARK: - Body Text (Sans-serif style - like Inter)
-    
-    /// Body Large - 17pt Regular
-    static let bodyLarge = Font.system(size: 17, weight: .regular, design: .default)
-    
-    /// Body - Standard body text - 15pt Regular
-    static let body = Font.system(size: 15, weight: .regular, design: .default)
-    
-    /// Body Small - 13pt Regular
-    static let bodySmall = Font.system(size: 13, weight: .regular, design: .default)
-    
-    // MARK: - UI Elements
-    
-    /// Button text - 16pt Semibold
-    static let button = Font.system(size: 16, weight: .semibold, design: .default)
-    
-    /// Caption - 12pt Regular
-    static let caption = Font.system(size: 12, weight: .regular, design: .default)
-    
-    /// Label - 14pt Medium
-    static let label = Font.system(size: 14, weight: .medium, design: .default)
-}
-
-// MARK: - View Extension for Typography
-
-extension View {
-    func headingStyle() -> some View {
-        self
-            .font(AppTypography.heading)
-            .foregroundStyle(AppColors.textPrimary)
-    }
-    
-    func bodyStyle() -> some View {
-        self
-            .font(AppTypography.body)
-            .foregroundStyle(AppColors.textPrimary)
-    }
-    
-    func captionStyle() -> some View {
-        self
-            .font(AppTypography.caption)
-            .foregroundStyle(AppColors.textSecondary)
-    }
-}
diff --git a/TheMiddleWay/Sources/App/Core/Theme/ThemeConfig.swift b/TheMiddleWay/Sources/App/Core/Theme/ThemeConfig.swift
deleted file mode 100644
index 5fc429d..0000000
--- a/TheMiddleWay/Sources/App/Core/Theme/ThemeConfig.swift
+++ /dev/null
@@ -1,17 +0,0 @@
-import SwiftUI
-
-enum ThemeConfig {
-    static let storageKey = "isDarkMode"
-
-    static func colorScheme(isDarkMode: Bool) -> ColorScheme {
-        isDarkMode ? .dark : .light
-    }
-
-    static func toggleIconName(isDarkMode: Bool) -> String {
-        isDarkMode ? "sun.max.fill" : "moon.fill"
-    }
-
-    static func toggleLabel(isDarkMode: Bool) -> String {
-        isDarkMode ? "Switch to Light Mode" : "Switch to Dark Mode"
-    }
-}
diff --git a/TheMiddleWay/Sources/App/TheMiddleWayApp.swift b/TheMiddleWay/Sources/App/TheMiddleWayApp.swift
index 7467023..7d467b1 100644
--- a/TheMiddleWay/Sources/App/TheMiddleWayApp.swift
+++ b/TheMiddleWay/Sources/App/TheMiddleWayApp.swift
@@ -3,11 +3,17 @@ import SwiftUI
 @main
 struct TheMiddleWayApp: App {
     @StateObject private var viewModel = MainViewModel()
+    @StateObject private var onboardingService = OnboardingService()
 
     var body: some Scene {
         WindowGroup {
-            ContentView()
-                .environmentObject(viewModel)
+            if onboardingService.isOnboardingCompleted {
+                ContentView()
+                    .environmentObject(viewModel)
+            } else {
+                OnboardingView()
+                    .environmentObject(onboardingService)
+            }
         }
     }
 }
diff --git a/TheMiddleWay/Sources/Core/Services/OnboardingService.swift b/TheMiddleWay/Sources/Core/Services/OnboardingService.swift
new file mode 100644
index 0000000..55af77a
--- /dev/null
+++ b/TheMiddleWay/Sources/Core/Services/OnboardingService.swift
@@ -0,0 +1,18 @@
+import SwiftUI
+import Combine
+
+class OnboardingService: ObservableObject {
+    @AppStorage("onboarding_completed") var isOnboardingCompleted: Bool = false
+    
+    func completeOnboarding() {
+        withAnimation {
+            isOnboardingCompleted = true
+        }
+    }
+    
+    func resetOnboarding() {
+         withAnimation {
+            isOnboardingCompleted = false
+        }
+    }
+}
diff --git a/TheMiddleWay/Sources/Features/Onboarding/OnboardingView.swift b/TheMiddleWay/Sources/Features/Onboarding/OnboardingView.swift
new file mode 100644
index 0000000..7bf2547
--- /dev/null
+++ b/TheMiddleWay/Sources/Features/Onboarding/OnboardingView.swift
@@ -0,0 +1,93 @@
+import SwiftUI
+
+struct OnboardingSlide: Identifiable {
+    let id = UUID()
+    let title: String
+    let description: String
+    let imageName: String
+}
+
+struct OnboardingView: View {
+    @EnvironmentObject var onboardingService: OnboardingService
+    @State private var currentPage = 0
+    
+    let slides = [
+        OnboardingSlide(title: "Welcome to The Middle Way", description: "Find balance and harmony in your daily life.", imageName: "onboarding_welcome"),
+        OnboardingSlide(title: "Authentic Wisdom", description: "It's more than just quotes. It's timeless knowledge, verified and applied to modern life.", imageName: "onboarding_wisdom"),
+        OnboardingSlide(title: "Discover Your Path", description: "Explore curated insights from philosophy, science, and art to find clarity.", imageName: "onboarding_path"),
+         OnboardingSlide(title: "A Daily Practice", description: "Engage with one profound idea each day to build a more meaningful life.", imageName: "onboarding_practice")
+    ]
+    
+    var body: some View {
+        VStack {
+            HStack {
+                Spacer()
+                if currentPage < slides.count - 1 {
+                    Button("Skip") {
+                        onboardingService.completeOnboarding()
+                    }
+                    .foregroundColor(.secondary)
+                } else {
+                     // Keep layout stable
+                     Text("").frame(height: 20)
+                }
+            }
+            .padding()
+            
+            TabView(selection: $currentPage) {
+                ForEach(0..<slides.count, id: \.self) { index in
+                    OnboardingPageView(slide: slides[index])
+                        .tag(index)
+                }
+            }
+            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
+            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
+            
+            Button(action: {
+                if currentPage < slides.count - 1 {
+                    withAnimation {
+                        currentPage += 1
+                    }
+                } else {
+                    onboardingService.completeOnboarding()
+                }
+            }) {
+                Text(currentPage == slides.count - 1 ? "Begin Journey" : "Next")
+                    .font(.headline)
+                    .frame(maxWidth: .infinity)
+                    .padding()
+                    .background(Color.accentColor)
+                    .foregroundColor(.white)
+                    .cornerRadius(12)
+            }
+            .padding()
+        }
+        .background(Color(UIColor.systemBackground))
+    }
+}
+
+struct OnboardingPageView: View {
+    let slide: OnboardingSlide
+    
+    var body: some View {
+        VStack(spacing: 20) {
+            Image(slide.imageName)
+                .resizable()
+                .scaledToFit()
+                .frame(maxHeight: 300)
+                .padding()
+                
+            Text(slide.title)
+                .font(.title)
+                .fontWeight(.bold)
+                .multilineTextAlignment(.center)
+                
+            Text(slide.description)
+                .font(.body)
+                .multilineTextAlignment(.center)
+                .foregroundColor(.secondary)
+                .padding(.horizontal)
+        }
+        .padding()
+    }
+}
diff --git a/TheMiddleWay/Sources/Features/WisdomGarden/Data/NetworkWisdomGardenRepository.swift b/TheMiddleWay/Sources/Features/WisdomGarden/Data/NetworkWisdomGardenRepository.swift
index 88726b1..446b8ca 100644
--- a/TheMiddleWay/Sources/Features/WisdomGarden/Data/NetworkWisdomGardenRepository.swift
+++ b/TheMiddleWay/Sources/Features/WisdomGarden/Data/NetworkWisdomGardenRepository.swift
@@ -11,6 +11,11 @@ class NetworkWisdomGardenRepository: WisdomGardenRepository {
     // For Simulator, localhost works. For device, need IP.
     // Ensure "App Transport Security Settings" allows Arbitrary Loads or configure localhost.
     private let baseURL = "http://localhost:8080/api/v1/wisdom-garden"
+    private let session: URLSession
+    
+    init(session: URLSession = .shared) {
+        self.session = session
+    }
     
     func getWeeklyData(week: Int) async throws -> WeeklyData {
         guard let url = URL(string: "\(baseURL)/weeks/\(week)") else {
@@ -22,26 +27,65 @@ class NetworkWisdomGardenRepository: WisdomGardenRepository {
         var request = URLRequest(url: url)
         request.httpMethod = "GET"
         
-        let (data, response) = try await URLSession.shared.data(for: request)
-        
-        guard let httpResponse = response as? HTTPURLResponse else {
-             print("❌ [Net] Fetch Week: Invalid Response")
-             throw URLError(.badServerResponse)
+        do {
+            let (data, response) = try await session.data(for: request)
+            
+            guard let httpResponse = response as? HTTPURLResponse else {
+                 print("❌ [Net] Fetch Week: Invalid Response")
+                 throw URLError(.badServerResponse)
+            }
+            
+            print("✅ [Net] Fetch Week: Status \(httpResponse.statusCode)")
+            
+            if httpResponse.statusCode != 200 {
+                 print("❌ [Net] Fetch Week: Error \(httpResponse.statusCode)")
+                 throw URLError(.badServerResponse)
+            }
+            
+            let decoder = JSONDecoder()
+            // decoder.keyDecodingStrategy = .convertFromSnakeCase // Backend uses camelCase for most, except created_at
+            
+            let result = try decoder.decode(WeeklyData.self, from: data)
+            print("✅ [Net] Fetch Week: Success (Decoded items: \(result.categories.count) categories)")
+            return result
+        } catch {
+            print("⚠️ [Net] Fetch Week Failed: \(error). Using Fallback Data.")
+            return getFallbackData(week: week)
         }
+    }
+    
+    private func getFallbackData(week: Int) -> WeeklyData {
+        let categories = [
+             PracticeCategory(
+                id: "mindfulness",
+                title: "Practicing Mindfulness",
+                items: [
+                    PracticeItem(id: "m1", title: "Morning Meditation (15 mins)", points: 10, isCompleted: false),
+                    PracticeItem(id: "m2", title: "Mindful Eating", points: 5, isCompleted: false),
+                    PracticeItem(id: "m3", title: "Evening Reflection", points: 5, isCompleted: false)
+                ]
+            ),
+             PracticeCategory(
+                id: "precepts",
+                title: "Keeping Precepts",
+                items: [
+                    PracticeItem(id: "p1", title: "Refrain from killing", points: 5, isCompleted: false),
+                    PracticeItem(id: "p2", title: "Refrain from stealing", points: 5, isCompleted: false),
+                    PracticeItem(id: "p3", title: "Refrain from lying", points: 5, isCompleted: false)
+                ]
+            )
+        ]
         
-        print("✅ [Net] Fetch Week: Status \(httpResponse.statusCode)")
-        
-        if httpResponse.statusCode != 200 {
-             print("❌ [Net] Fetch Week: Error \(httpResponse.statusCode)")
-             throw URLError(.badServerResponse)
+        let calculatedMaxScore = categories.reduce(0) { catSum, cat in
+            catSum + cat.items.reduce(0) { itemSum, item in itemSum + item
... (Diff truncated for size) ...


PR TEMPLATE:


INSTRUCTIONS:
1. Generate a comprehensive PR description in Markdown format.
2. If a template is provided, fill it out intelligently.
3. If no template, use a standard structure: Summary, Changes, Impact.
4. Focus on 'Why' and 'What'.
5. Do not include 'Here is the PR description' preamble. Just the body.
6. IMPORTANT: Always use FULL URLs for links to issues and other PRs (e.g., https://github.com/owner/repo/issues/123), do NOT use short syntax (e.g., #123) to ensuring proper linking across platforms.
