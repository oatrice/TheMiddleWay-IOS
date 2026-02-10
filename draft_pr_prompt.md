# PR Draft Prompt

You are an AI assistant helping to create a Pull Request description.
    
TASK: [Design] Design System Implementation: Colors (#0A192F, #F59E0B) and Typography
ISSUE: {
  "title": "[Design] Design System Implementation: Colors (#0A192F, #F59E0B) and Typography",
  "number": 4
}

GIT CONTEXT:
COMMITS:
004296e docs: add v0.2.0 release notes for theme system and dark mode
f31fa18 fix(theme): move toolbar modifiers inside NavigationStack content
5657691 docs: add code review report documenting NavigationStack toolbar fixes
744a684 feat(theme): update light mode palette to Bright Sky blue theme
7dfa441 feat(theme): add persistent dark mode toggle with ThemeConfig
f7d429d feat(ui): add AppTheme with themed navigation stack and tab bar styling

STATS:
CHANGELOG.md                                      |  37 ++------
 README.md                                         |  15 ++--
 TheMiddleWay.xcodeproj/project.pbxproj            |  12 ++-
 TheMiddleWay/Sources/App/ContentView.swift        | 101 ++++++++++++----------
 TheMiddleWay/Sources/Core/Theme/AppColors.swift   |  92 ++++++++++++--------
 TheMiddleWay/Sources/Core/Theme/AppTheme.swift    |  24 +++++
 TheMiddleWay/Sources/Core/Theme/ThemeConfig.swift |  17 ++++
 TheMiddleWay/Sources/Features/Home/HomeView.swift |  46 ++++++----
 code_review.md                                    |  50 +++++++++++
 9 files changed, 257 insertions(+), 137 deletions(-)

KEY FILE DIFFS:
diff --git a/TheMiddleWay/Sources/App/ContentView.swift b/TheMiddleWay/Sources/App/ContentView.swift
index 8831a55..eb569b2 100644
--- a/TheMiddleWay/Sources/App/ContentView.swift
+++ b/TheMiddleWay/Sources/App/ContentView.swift
@@ -2,34 +2,56 @@ import SwiftUI
 
 struct ContentView: View {
     @State private var selectedTab: Tab = .home
+    @AppStorage(ThemeConfig.storageKey) private var isDarkMode = false
+
+    private var themeScheme: ColorScheme {
+        ThemeConfig.colorScheme(isDarkMode: isDarkMode)
+    }
     
     var body: some View {
         TabView(selection: $selectedTab) {
-            HomeView()
-                .tabItem {
-                    Label("Home", systemImage: "house.fill")
-                }
-                .tag(Tab.home)
+            ThemedNavigationStack {
+                HomeView()
+                    .navigationTitle("The Middle Way")
+                    .navigationBarTitleDisplayMode(.large)
+            }
+            .tabItem {
+                Label("Home", systemImage: "house.fill")
+            }
+            .tag(Tab.home)
             
-            LibraryView()
-                .tabItem {
-                    Label("Library", systemImage: "books.vertical.fill")
-                }
-                .tag(Tab.library)
+            ThemedNavigationStack {
+                LibraryView()
+                    .navigationTitle("Library")
+            }
+            .tabItem {
+                Label("Library", systemImage: "books.vertical.fill")
+            }
+            .tag(Tab.library)
             
-            CoursesView()
-                .tabItem {
-                    Label("Courses", systemImage: "book.fill")
-                }
-                .tag(Tab.courses)
+            ThemedNavigationStack {
+                CoursesView()
+                    .navigationTitle("Courses")
+            }
+            .tabItem {
+                Label("Courses", systemImage: "book.fill")
+            }
+            .tag(Tab.courses)
             
-            ProfileView()
-                .tabItem {
-                    Label("Profile", systemImage: "person.fill")
-                }
-                .tag(Tab.profile)
+            ThemedNavigationStack {
+                ProfileView()
+                    .navigationTitle("Profile")
+            }
+            .tabItem {
+                Label("Profile", systemImage: "person.fill")
+            }
+            .tag(Tab.profile)
         }
         .tint(AppColors.primary)
+        .toolbarBackground(AppColors.background, for: .tabBar)
+        .toolbarBackground(.visible, for: .tabBar)
+        .toolbarColorScheme(themeScheme, for: .tabBar)
+        .preferredColorScheme(themeScheme)
     }
 }
 
@@ -44,40 +66,31 @@ enum Tab: Hashable {
 
 struct LibraryView: View {
     var body: some View {
-        NavigationStack {
-            Text("Library")
-                .font(AppTypography.heading)
-                .foregroundStyle(AppColors.textPrimary)
-                .frame(maxWidth: .infinity, maxHeight: .infinity)
-                .background(AppColors.background)
-                .navigationTitle("Library")
-        }
+        Text("Library")
+            .font(AppTypography.heading)
+            .foregroundStyle(AppColors.textPrimary)
+            .frame(maxWidth: .infinity, maxHeight: .infinity)
+            .background(AppColors.background)
     }
 }
 
 struct CoursesView: View {
     var body: some View {
-        NavigationStack {
-            Text("Courses")
-                .font(AppTypography.heading)
-                .foregroundStyle(AppColors.textPrimary)
-                .frame(maxWidth: .infinity, maxHeight: .infinity)
-                .background(AppColors.background)
-                .navigationTitle("Courses")
-        }
+        Text("Courses")
+            .font(AppTypography.heading)
+            .foregroundStyle(AppColors.textPrimary)
+            .frame(maxWidth: .infinity, maxHeight: .infinity)
+            .background(AppColors.background)
     }
 }
 
 struct ProfileView: View {
     var body: some View {
-        NavigationStack {
-            Text("Profile")
-                .font(AppTypography.heading)
-                .foregroundStyle(AppColors.textPrimary)
-                .frame(maxWidth: .infinity, maxHeight: .infinity)
-                .background(AppColors.background)
-                .navigationTitle("Profile")
-        }
+        Text("Profile")
+            .font(AppTypography.heading)
+            .foregroundStyle(AppColors.textPrimary)
+            .frame(maxWidth: .infinity, maxHeight: .infinity)
+            .background(AppColors.background)
     }
 }
 
diff --git a/TheMiddleWay/Sources/Core/Theme/AppColors.swift b/TheMiddleWay/Sources/Core/Theme/AppColors.swift
index a699f69..9fcf118 100644
--- a/TheMiddleWay/Sources/Core/Theme/AppColors.swift
+++ b/TheMiddleWay/Sources/Core/Theme/AppColors.swift
@@ -1,48 +1,67 @@
 import SwiftUI
+import UIKit
 
-/// The Middle Way - Warm Modern Sanctuary Color Palette
-/// Matching the Web and Android design system
+/// The Middle Way - Adaptive Color Palette
+/// Light: Bright Sky (ฟ้าสดใส)
+/// Dark: Deep Cosmos (matching Web/Android design system)
 enum AppColors {
-    // MARK: - Primary Palette
+    // MARK: - Light Palette — Bright Sky
     
-    /// Ivory - Background color
-    /// Hex: #FCF9F6
-    static let background = Color(red: 252/255, green: 249/255, blue: 246/255)
-    
-    /// Sage Green - Primary accent color
-    /// Hex: #8B9D83
-    static let primary = Color(red: 139/255, green: 157/255, blue: 131/255)
-    
-    /// Soft Sand - Surface/Cards color
-    /// Hex: #F3F0ED
-    static let surface = Color(red: 243/255, green: 240/255, blue: 237/255)
-    
-    /// Deep Slate - Primary text color
-    /// Hex: #2D3748
-    static let textPrimary = Color(red: 45/255, green: 55/255, blue: 72/255)
-    
-    // MARK: - Extended Palette
-    
-    /// Secondary text color (lighter)
-    static let textSecondary = Color(red: 113/255, green: 128/255, blue: 150/255)
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
     
-    /// Border/Divider color
-    static let border = Color(red: 226/255, green: 232/255, blue: 240/255)
+    // MARK: - Dark Palette
     
-    /// Success color
-    static let success = Color(red: 72/255, green: 187/255, blue: 120/255)
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
     
-    /// Warning color
-    static let warning = Color(red: 237/255, green: 137/255, blue: 54/255)
+    // MARK: - Dynamic Tokens
     
-    /// Error color
-    static let error = Color(red: 245/255, green: 101/255, blue: 101/255)
+    static let background = Color.dynamic(light: Light.background, dark: Dark.background)
+    static let primary = Color.dynamic(light: Light.primary, dark: Dark.primary)
+    static let surface = Color.dynamic(light: Light.surface, dark: Dark.surface)
+    static let textPrimary = Color.dynamic(light: Light.textPrimary, dark: Dark.textPrimary)
+    static let textSecondary = Color.dynamic(light: Light.textSecondary, dark: Dark.textSecondary)
+    static let border = Color.dynamic(light: Light.border, dark: Dark.border)
+    static let success = Color.dynamic(light: Light.success, dark: Dark.success)
+    static let warning = Color.dynamic(light: Light.warning, dark: Dark.warning)
+    static let error = Color.dynamic(light: Light.error, dark: Dark.error)
 }
 
-// MARK: - Color Extension for Hex Support
+// MARK: - Color Extensions
 
 extension Color {
+    static func dynamic(light: Color, dark: Color) -> Color {
+        Color(UIColor { trait in
+            trait.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
+        })
+    }
+    
     init(hex: String) {
+        self.init(UIColor(hex: hex))
+    }
+}
+
+extension UIColor {
+    convenience init(hex: String) {
         let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
         var int: UInt64 = 0
         Scanner(string: hex).scanHexInt64(&int)
@@ -58,11 +77,10 @@ extension Color {
             (a, r, g, b) = (255, 0, 0, 0)
         }
         self.init(
-            .sRGB,
-            red: Double(r) / 255,
-            green: Double(g) / 255,
-            blue: Double(b) / 255,
-            opacity: Double(a) / 255
+            red: CGFloat(r) / 255,
+            green: CGFloat(g) / 255,
+            blue: CGFloat(b) / 255,
+            alpha: CGFloat(a) / 255
         )
     }
 }
diff --git a/TheMiddleWay/Sources/Core/Theme/AppTheme.swift b/TheMiddleWay/Sources/Core/Theme/AppTheme.swift
new file mode 100644
index 0000000..998b891
--- /dev/null
+++ b/TheMiddleWay/Sources/Core/Theme/AppTheme.swift
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
diff --git a/TheMiddleWay/Sources/Core/Theme/ThemeConfig.swift b/TheMiddleWay/Sources/Core/Theme/ThemeConfig.swift
new file mode 100644
index 0000000..5fc429d
--- /dev/null
+++ b/TheMiddleWay/Sources/Core/Theme/ThemeConfig.swift
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
diff --git a/TheMiddleWay/Sources/Features/Home/HomeView.swift b/TheMiddleWay/Sources/Features/Home/HomeView.swift
index 9e7c39a..412f8f9 100644
--- a/TheMiddleWay/Sources/Features/Home/HomeView.swift
+++ b/TheMiddleWay/Sources/Features/Home/HomeView.swift
@@ -1,25 +1,33 @@
 import SwiftUI
 
 struct HomeView: View {
+    @AppStorage(ThemeConfig.storageKey) private var isDarkMode = false
+
     var body: some View {
-        NavigationStack {
-            ScrollView {
-                VStack(spacing: 24) {
-                    // Welcome Card
-                    WelcomeCard()
-                    
-                    // Quick Actions
-                    QuickActionsSection()
-                    
-                    // Recent Activity
-                    RecentActivitySection()
+        ScrollView {
+            VStack(spacing: 24) {
+                // Welcome Card
+                WelcomeCard()
+                
+                // Quick Actions
+                QuickActionsSection()
+                
+                // Recent Activity
+                RecentActivitySection()
+            }
+            .padding(.horizontal, 16)
+            .padding(.top, 16)
+        }
+        .background(AppColors.background)
+        .toolbar {
+            ToolbarItem(placement: .navigationBarTrailing) {
+                Button {
+                    isDarkMode.toggle()
+                } label: {
+                    Image(systemName: ThemeConfig.toggleIconName(isDarkMode: isDarkMode))
                 }
-                .padding(.horizontal, 16)
-                .padding(.top, 16)
+                .accessibilityLabel(ThemeConfig.toggleLabel(isDarkMode: isDarkMode))
             }
-            .background(AppColors.background)
-            .navigationTitle("The Middle Way")
-            .navigationBarTitleDisplayMode(.large)
         }
     }
 }
@@ -171,5 +179,9 @@ struct ActivityRow: View {
 }
 
 #Preview {
-    HomeView()
+    NavigationStack {
+        HomeView()
+            .navigationTitle("The Middle Way")
+            .navigationBarTitleDisplayMode(.large)
+    }
 }

PR TEMPLATE:


INSTRUCTIONS:
1. Generate a comprehensive PR description in Markdown format.
2. If a template is provided, fill it out intelligently.
3. If no template, use a standard structure: Summary, Changes, Impact.
4. Focus on 'Why' and 'What'.
5. Do not include 'Here is the PR description' preamble. Just the body.
6. IMPORTANT: Always use FULL URLs for links to issues and other PRs (e.g., https://github.com/owner/repo/issues/123), do NOT use short syntax (e.g., #123) to ensuring proper linking across platforms.
