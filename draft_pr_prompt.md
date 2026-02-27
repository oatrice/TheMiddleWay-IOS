# PR Draft Prompt

You are an AI assistant helping to create a Pull Request description.
    
TASK: 🔐 [Feature] ระบบสมาชิกและการรักษาความปลอดภัย (User Authentication & Sync)
ISSUE: {
  "title": "\ud83d\udd10 [Feature] \u0e23\u0e30\u0e1a\u0e1a\u0e2a\u0e21\u0e32\u0e0a\u0e34\u0e01\u0e41\u0e25\u0e30\u0e01\u0e32\u0e23\u0e23\u0e31\u0e01\u0e29\u0e32\u0e04\u0e27\u0e32\u0e21\u0e1b\u0e25\u0e2d\u0e14\u0e20\u0e31\u0e22 (User Authentication & Sync)",
  "number": 14,
  "body": "## \ud83d\udccb \u0e2a\u0e23\u0e38\u0e1b\u0e20\u0e32\u0e1e\u0e23\u0e27\u0e21\n\n\u0e2a\u0e23\u0e49\u0e32\u0e07\u0e23\u0e30\u0e1a\u0e1a\u0e17\u0e35\u0e48\u0e2d\u0e19\u0e38\u0e0d\u0e32\u0e15\u0e43\u0e2b\u0e49\u0e1c\u0e39\u0e49\u0e43\u0e0a\u0e49\u0e07\u0e32\u0e19\u0e2a\u0e21\u0e31\u0e04\u0e23\u0e2a\u0e21\u0e32\u0e0a\u0e34\u0e01\u0e41\u0e25\u0e30\u0e40\u0e02\u0e49\u0e32\u0e2a\u0e39\u0e48\u0e23\u0e30\u0e1a\u0e1a \u0e40\u0e1e\u0e37\u0e48\u0e2d\u0e1a\u0e31\u0e19\u0e17\u0e36\u0e01\u0e04\u0e27\u0e32\u0e21\u0e01\u0e49\u0e32\u0e27\u0e2b\u0e19\u0e49\u0e32\u0e43\u0e19\u0e01\u0e32\u0e23\u0e1b\u0e0f\u0e34\u0e1a\u0e31\u0e15\u0e34\u0e18\u0e23\u0e23\u0e21 (Progress) \u0e25\u0e07\u0e1a\u0e19 Cloud \u0e41\u0e17\u0e19\u0e01\u0e32\u0e23\u0e40\u0e01\u0e47\u0e1a\u0e44\u0e27\u0e49\u0e41\u0e04\u0e48\u0e43\u0e19\u0e40\u0e04\u0e23\u0e37\u0e48\u0e2d\u0e07 (LocalStorage) \u0e2d\u0e22\u0e48\u0e32\u0e07\u0e40\u0e14\u0e35\u0e22\u0e27\n\n## \ud83c\udfaf \u0e40\u0e1b\u0e49\u0e32\u0e2b\u0e21\u0e32\u0e22\n\n\u0e40\u0e1e\u0e37\u0e48\u0e2d\u0e43\u0e2b\u0e49\u0e1c\u0e39\u0e49\u0e43\u0e0a\u0e49\u0e07\u0e32\u0e19\u0e44\u0e21\u0e48\u0e2a\u0e39\u0e0d\u0e40\u0e2a\u0e35\u0e22\u0e02\u0e49\u0e2d\u0e21\u0e39\u0e25\u0e40\u0e21\u0e37\u0e48\u0e2d\u0e40\u0e1b\u0e25\u0e35\u0e48\u0e22\u0e19\u0e40\u0e04\u0e23\u0e37\u0e48\u0e2d\u0e07 \u0e2b\u0e23\u0e37\u0e2d\u0e25\u0e49\u0e32\u0e07 Cache \u0e02\u0e2d\u0e07 Browser \u0e41\u0e25\u0e30\u0e40\u0e1e\u0e37\u0e48\u0e2d\u0e23\u0e2d\u0e07\u0e23\u0e31\u0e1a\u0e1f\u0e35\u0e40\u0e08\u0e2d\u0e23\u0e4c \"\u0e2a\u0e21\u0e32\u0e0a\u0e34\u0e01\u0e1e\u0e23\u0e35\u0e40\u0e21\u0e35\u0e22\u0e21\" \u0e43\u0e19\u0e2d\u0e19\u0e32\u0e04\u0e15\n\n## \u2705 Tasks\n\n### 1. \u0e27\u0e34\u0e18\u0e35\u0e01\u0e32\u0e23\u0e40\u0e02\u0e49\u0e32\u0e2a\u0e39\u0e48\u0e23\u0e30\u0e1a\u0e1a (Auth Providers)\n\n- [ ] \u0e23\u0e2d\u0e07\u0e23\u0e31\u0e1a Social Login \u0e14\u0e49\u0e27\u0e22 **Google** \u0e41\u0e25\u0e30 **Apple ID**\n- [ ] \u0e23\u0e2d\u0e07\u0e23\u0e31\u0e1a **Magic Link** (\u0e2a\u0e48\u0e07 Link \u0e40\u0e02\u0e49\u0e32 Email \u0e40\u0e1e\u0e37\u0e48\u0e2d Login \u0e42\u0e14\u0e22\u0e44\u0e21\u0e48\u0e15\u0e49\u0e2d\u0e07\u0e08\u0e33 Password)\n\n### 2. \u0e2a\u0e48\u0e27\u0e19\u0e15\u0e34\u0e14\u0e15\u0e48\u0e2d\u0e1c\u0e39\u0e49\u0e43\u0e0a\u0e49 (UI Components)\n\n- [ ] \u0e2a\u0e23\u0e49\u0e32\u0e07\u0e2b\u0e19\u0e49\u0e32 Login/Sign-up (Minimalist design \u0e43\u0e0a\u0e49\u0e42\u0e17\u0e19\u0e2a\u0e35 Ivory \u0e41\u0e25\u0e30 Sage Green \u0e15\u0e32\u0e21\u0e18\u0e35\u0e21 \"The Warm Sanctuary\")\n- [ ] \u0e2a\u0e23\u0e49\u0e32\u0e07\u0e2b\u0e19\u0e49\u0e32 Profile (\u0e41\u0e2a\u0e14\u0e07\u0e02\u0e49\u0e2d\u0e21\u0e39\u0e25\u0e1e\u0e37\u0e49\u0e19\u0e10\u0e32\u0e19 + \u0e1b\u0e38\u0e48\u0e21 Log out)\n\n### 3. \u0e01\u0e32\u0e23\u0e40\u0e0a\u0e37\u0e48\u0e2d\u0e21\u0e42\u0e22\u0e07\u0e02\u0e49\u0e2d\u0e21\u0e39\u0e25 (Data Migration)\n\n- [ ] \u0e2a\u0e23\u0e49\u0e32\u0e07 Sync Logic: \u0e40\u0e21\u0e37\u0e48\u0e2d User \u0e40\u0e02\u0e49\u0e32\u0e2a\u0e39\u0e48\u0e23\u0e30\u0e1a\u0e1a\u0e04\u0e23\u0e31\u0e49\u0e07\u0e41\u0e23\u0e01 \u0e14\u0e36\u0e07\u0e02\u0e49\u0e2d\u0e21\u0e39\u0e25\u0e08\u0e32\u0e01 LocalStorage \u0e02\u0e36\u0e49\u0e19 Database\n- [ ] \u0e2a\u0e23\u0e49\u0e32\u0e07 Database Schema \u0e2a\u0e33\u0e2b\u0e23\u0e31\u0e1a\u0e40\u0e01\u0e47\u0e1a User data \u0e41\u0e25\u0e30 Progress (70 \u0e41\u0e15\u0e49\u0e21)\n\n## \ud83d\udd27 Technical Notes\n\n**Recommended Stack:**\n- **Auth Provider:** NextAuth.js (Auth.js) \u0e2b\u0e23\u0e37\u0e2d Clerk\n- **Database:** Supabase (PostgreSQL) \u0e2b\u0e23\u0e37\u0e2d Vercel Postgres\n- **Auth Methods:** Google OAuth, Apple Sign-in, Magic Link\n\n**UX Consideration:**\n- \u0e2d\u0e22\u0e48\u0e32\u0e1a\u0e31\u0e07\u0e04\u0e31\u0e1a\u0e43\u0e2b\u0e49 User \u0e15\u0e49\u0e2d\u0e07 Login \u0e15\u0e31\u0e49\u0e07\u0e41\u0e15\u0e48\u0e2b\u0e19\u0e49\u0e32\u0e41\u0e23\u0e01\n- \u0e43\u0e0a\u0e49 Progressive Profiling: \u0e1b\u0e25\u0e48\u0e2d\u0e22\u0e43\u0e2b\u0e49\u0e25\u0e2d\u0e07\u0e43\u0e0a\u0e49\u0e07\u0e32\u0e19\u0e41\u0e1a\u0e1a Guest \u0e01\u0e48\u0e2d\u0e19\n- Prompt \u0e01\u0e32\u0e23\u0e2a\u0e21\u0e31\u0e04\u0e23\u0e2a\u0e21\u0e32\u0e0a\u0e34\u0e01\u0e40\u0e21\u0e37\u0e48\u0e2d User \u0e40\u0e23\u0e34\u0e48\u0e21\u0e21\u0e35\u0e04\u0e30\u0e41\u0e19\u0e19\u0e2a\u0e30\u0e2a\u0e21\n\n## \u2753 Questions to Resolve\n\n1. \u0e08\u0e30\u0e43\u0e0a\u0e49\u0e23\u0e30\u0e1a\u0e1a Login \u0e02\u0e2d\u0e07 Google Workspace (\u0e2d\u0e07\u0e04\u0e4c\u0e01\u0e23) \u0e2b\u0e23\u0e37\u0e2d\u0e41\u0e1a\u0e1a\u0e17\u0e31\u0e48\u0e27\u0e44\u0e1b (Gmail \u0e2a\u0e48\u0e27\u0e19\u0e15\u0e31\u0e27)?\n2. \u0e15\u0e49\u0e2d\u0e07\u0e01\u0e32\u0e23 Database Schema \u0e23\u0e32\u0e22\u0e25\u0e30\u0e40\u0e2d\u0e35\u0e22\u0e14\u0e2a\u0e33\u0e2b\u0e23\u0e31\u0e1a\u0e15\u0e32\u0e23\u0e32\u0e07 Users \u0e41\u0e25\u0e30 Progress \u0e2b\u0e23\u0e37\u0e2d\u0e44\u0e21\u0e48?\n\n## \ud83d\udcce Related\n\n- \u0e02\u0e36\u0e49\u0e19\u0e2d\u0e22\u0e39\u0e48\u0e01\u0e31\u0e1a: LocalStorage Implementation (MVP)\n- \u0e40\u0e01\u0e35\u0e48\u0e22\u0e27\u0e02\u0e49\u0e2d\u0e07\u0e01\u0e31\u0e1a: Premium Features (Future)"
}

GIT CONTEXT:
COMMITS:
cf287d9 chore(release): prepare v0.7.0 release
9095e9e feat(wisdom-garden): add error handling for weekly data fetch failures
13cd804 feat(profile): add confirmation alert before signing out
9514b64 feat(auth): add loading state indicator for Google sign-in
80ec10f style(ios): remove trailing whitespace from Xcode project file
27dd558 security(ios): move API key to gitignored Secrets.swift
13e9d32 feat(ios): use master endpoint for unauthenticated users, add API key
7a7abf5 fix(ios): remove deleted FirestoreWisdomGardenRepository from Xcode project
bf492a2 feat(settings): add API environment selector with custom URL support
0d22571 chore: switch API endpoints from localhost to production Render
1420e55 🐛 fix(wisdom-garden): Correct ID parsing and error handling
a377dec refactor: remove score tracking and Profile dismiss functionality
ee97c80 feat: add Firestore repository and developer settings UI
92c9438 feat(auth): add Firebase Auth and Google Sign-In integration

STATS:
.gitignore                                         |   3 +
 CHANGELOG.md                                       |  17 +++
 README.md                                          |   7 +-
 TheMiddleWay.xcodeproj/project.pbxproj             | 155 ++++++++++++++++++-
 .../xcshareddata/xcschemes/TheMiddleWay.xcscheme   |  78 ++++++++++
 TheMiddleWay/GoogleService-Info.plist              |  36 +++++
 TheMiddleWay/Info.plist                            |  25 +++
 TheMiddleWay/Sources/App/ContentView.swift         |  35 -----
 TheMiddleWay/Sources/App/TheMiddleWayApp.swift     |  27 +++-
 TheMiddleWay/Sources/Config/Secrets-example.swift  |   7 +
 TheMiddleWay/Sources/Core/Auth/AuthService.swift   |  79 ++++++++++
 TheMiddleWay/Sources/Features/Home/HomeView.swift  |  24 ++-
 .../Features/Profile/Views/ProfileView.swift       | 168 +++++++++++++++++++++
 .../Features/Settings/DevSettingsViewModel.swift   |  30 ++++
 .../Features/Settings/Views/DevSettingsView.swift  |  34 +++++
 .../Data/NetworkWisdomGardenRepository.swift       |  88 +++++------
 .../WisdomGarden/Data/WisdomGardenData.swift       |  19 ++-
 .../Data/WisdomGardenRepositoryProtocol.swift      |   6 +
 .../WisdomGarden/Models/WisdomGardenModels.swift   |  26 ++--
 .../ViewModels/WisdomGardenViewModel.swift         |  34 ++++-
 .../WisdomGarden/Views/WisdomGardenView.swift      |  11 ++
 code_review.md                                     |  97 +++++++++++-
 22 files changed, 871 insertions(+), 135 deletions(-)

KEY FILE DIFFS:
diff --git a/TheMiddleWay/Sources/App/ContentView.swift b/TheMiddleWay/Sources/App/ContentView.swift
index 1551368..1680ae9 100644
--- a/TheMiddleWay/Sources/App/ContentView.swift
+++ b/TheMiddleWay/Sources/App/ContentView.swift
@@ -83,42 +83,7 @@ struct CoursesView: View {
     }
 }
 
-struct ProfileView: View {
-    @EnvironmentObject var mainVM: MainViewModel
 
-    var body: some View {
-        VStack(spacing: 20) {
-            Text("Profile")
-                .font(AppTypography.heading)
-                .foregroundStyle(AppColors.textPrimary)
-            
-            VStack {
-                Text("Your Progress")
-                    .font(AppTypography.title2)
-                
-                Text("Completed Lessons: \(mainVM.userProgress.completedLessons.count)")
-                    .font(.title2)
-                    .bold()
-                
-                Button("Complete Demo Lesson") {
-                    mainVM.completeLesson("DEMO_IOS_\(Date().timeIntervalSince1970)")
-                }
-                .buttonStyle(.borderedProminent)
-                .tint(AppColors.primary)
-                
-                Button("Reset Progress", role: .destructive) {
-                    mainVM.resetProgress()
-                }
-                .buttonStyle(.bordered)
-            }
-            .padding()
-            .background(Color.secondary.opacity(0.1))
-            .cornerRadius(16)
-        }
-        .frame(maxWidth: .infinity, maxHeight: .infinity)
-        .background(AppColors.background)
-    }
-}
 
 #Preview {
     ContentView()
diff --git a/TheMiddleWay/Sources/App/TheMiddleWayApp.swift b/TheMiddleWay/Sources/App/TheMiddleWayApp.swift
index 7d467b1..b9c4728 100644
--- a/TheMiddleWay/Sources/App/TheMiddleWayApp.swift
+++ b/TheMiddleWay/Sources/App/TheMiddleWayApp.swift
@@ -1,18 +1,33 @@
 import SwiftUI
 
+import FirebaseCore
+import GoogleSignIn
+
 @main
 struct TheMiddleWayApp: App {
     @StateObject private var viewModel = MainViewModel()
     @StateObject private var onboardingService = OnboardingService()
+    @StateObject private var authService = AuthService.shared
+    
+    init() {
+        FirebaseApp.configure()
+    }
 
     var body: some Scene {
         WindowGroup {
-            if onboardingService.isOnboardingCompleted {
-                ContentView()
-                    .environmentObject(viewModel)
-            } else {
-                OnboardingView()
-                    .environmentObject(onboardingService)
+            ZStack {
+                if onboardingService.isOnboardingCompleted {
+                    ContentView()
+                        .environmentObject(viewModel)
+                        .environmentObject(authService)
+                } else {
+                    OnboardingView()
+                        .environmentObject(onboardingService)
+                        .environmentObject(authService)
+                }
+            }
+            .onOpenURL { url in
+                GIDSignIn.sharedInstance.handle(url)
             }
         }
     }
diff --git a/TheMiddleWay/Sources/Config/Secrets-example.swift b/TheMiddleWay/Sources/Config/Secrets-example.swift
new file mode 100644
index 0000000..2094a4e
--- /dev/null
+++ b/TheMiddleWay/Sources/Config/Secrets-example.swift
@@ -0,0 +1,7 @@
+import Foundation
+
+/// App secrets template - Copy this file to Secrets.swift and fill in your values.
+/// Secrets.swift is gitignored and should NOT be committed.
+enum AppSecrets {
+    static let apiKey = "YOUR_API_KEY_HERE"
+}
diff --git a/TheMiddleWay/Sources/Core/Auth/AuthService.swift b/TheMiddleWay/Sources/Core/Auth/AuthService.swift
new file mode 100644
index 0000000..bce7e87
--- /dev/null
+++ b/TheMiddleWay/Sources/Core/Auth/AuthService.swift
@@ -0,0 +1,79 @@
+
+import Foundation
+import FirebaseAuth
+import GoogleSignIn
+import Combine
+
+class AuthService: ObservableObject {
+    @Published var currentUser: User?
+    @Published var isAuthenticated: Bool = false
+    @Published var isLoading: Bool = false
+    
+    private var cancellables = Set<AnyCancellable>()
+    static let shared = AuthService()
+    
+    init() {
+        Auth.auth().addStateDidChangeListener { [weak self] _, user in
+            DispatchQueue.main.async {
+                self?.currentUser = user
+                self?.isAuthenticated = user != nil
+            }
+        }
+    }
+    
+    @MainActor
+    func signInWithGoogle() {
+        self.isLoading = true
+        
+        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
+              let window = windowScene.windows.first,
+              let rootViewController = window.rootViewController else {
+            print("❌ No root view controller found")
+            self.isLoading = false
+            return
+        }
+        
+        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
+            if let error = error {
+                print("❌ Google Sign-In Error: \(error.localizedDescription)")
+                DispatchQueue.main.async { self?.isLoading = false }
+                return
+            }
+            
+            guard let user = result?.user,
+                  let idToken = user.idToken?.tokenString else {
+                DispatchQueue.main.async { self?.isLoading = false }
+                return
+            }
+            
+            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
+                                                           accessToken: user.accessToken.tokenString)
+            
+            Auth.auth().signIn(with: credential) { result, error in
+                DispatchQueue.main.async {
+                    self?.isLoading = false
+                    if let error = error {
+                        print("❌ Firebase Sign-In Error: \(error.localizedDescription)")
+                        return
+                    }
+                    print("✅ User signed in: \(result?.user.email ?? "No Email")")
+                }
+            }
+        }
+    }
+    
+    func signOut() {
+        do {
+            try Auth.auth().signOut()
+        } catch {
+            print("❌ Error signing out: \(error.localizedDescription)")
+        }
+    }
+    
+    func getIDToken() async throws -> String {
+        guard let user = Auth.auth().currentUser else {
+            throw NSError(domain: "AuthService", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])
+        }
+        return try await user.getIDToken()
+    }
+}
diff --git a/TheMiddleWay/Sources/Features/Home/HomeView.swift b/TheMiddleWay/Sources/Features/Home/HomeView.swift
index 412f8f9..389cad6 100644
--- a/TheMiddleWay/Sources/Features/Home/HomeView.swift
+++ b/TheMiddleWay/Sources/Features/Home/HomeView.swift
@@ -2,6 +2,7 @@ import SwiftUI
 
 struct HomeView: View {
     @AppStorage(ThemeConfig.storageKey) private var isDarkMode = false
+    @State private var showProfile = false
 
     var body: some View {
         ScrollView {
@@ -21,12 +22,25 @@ struct HomeView: View {
         .background(AppColors.background)
         .toolbar {
             ToolbarItem(placement: .navigationBarTrailing) {
-                Button {
-                    isDarkMode.toggle()
-                } label: {
-                    Image(systemName: ThemeConfig.toggleIconName(isDarkMode: isDarkMode))
+                HStack {
+                    Button {
+                        showProfile.toggle()
+                    } label: {
+                        Image(systemName: "person.crop.circle")
+                    }
+                    .sheet(isPresented: $showProfile) {
+                        NavigationStack {
+                            ProfileView()
+                        }
+                    }
+
+                    Button {
+                        isDarkMode.toggle()
+                    } label: {
+                        Image(systemName: ThemeConfig.toggleIconName(isDarkMode: isDarkMode))
+                    }
+                    .accessibilityLabel(ThemeConfig.toggleLabel(isDarkMode: isDarkMode))
                 }
-                .accessibilityLabel(ThemeConfig.toggleLabel(isDarkMode: isDarkMode))
             }
         }
     }
diff --git a/TheMiddleWay/Sources/Features/Profile/Views/ProfileView.swift b/TheMiddleWay/Sources/Features/Profile/Views/ProfileView.swift
new file mode 100644
index 0000000..fa84456
--- /dev/null
+++ b/TheMiddleWay/Sources/Features/Profile/Views/ProfileView.swift
@@ -0,0 +1,168 @@
+
+import SwiftUI
+import FirebaseAuth
+
+struct ProfileView: View {
+    @EnvironmentObject var authService: AuthService
+    @EnvironmentObject var viewModel: MainViewModel
+    
+    @State private var showingLogoutAlert = false
+
+    
+    var body: some View {
+        ScrollView {
+            VStack(spacing: 24) {
+                // MARK: - User Status Section
+                if authService.isLoading {
+                    // Loading State
+                    VStack(spacing: 16) {
+                        ProgressView()
+                            .scaleEffect(1.5)
+                        Text("Signing in...")
+                            .font(.body)
+                            .foregroundColor(.secondary)
+                    }
+                    .frame(maxWidth: .infinity, minHeight: 200)
+                    .padding()
+                    .background(AppColors.surface)
+                    .cornerRadius(16)
+                } else if let user = authService.currentUser {
+                    // Logged In State
+                    VStack(spacing: 16) {
+                        if let photoURL = user.photoURL {
+                            AsyncImage(url: photoURL) { image in
+                                image
+                                    .resizable()
+                                    .scaledToFill()
+                            } placeholder: {
+                                Image(systemName: "person.circle.fill")
+                                    .resizable()
+                            }
+                            .frame(width: 80, height: 80)
+                            .clipShape(Circle())
+                        } else {
+                            Image(systemName: "person.circle.fill")
+                                .resizable()
+                                .frame(width: 80, height: 80)
+                                .foregroundColor(.gray)
+                        }
+                        
+                        Text(user.displayName ?? "User")
+                            .font(.title2)
+                            .fontWeight(.bold)
+                        
+                        Text(user.email ?? "")
+                            .font(.body)
+                            .foregroundColor(.secondary)
+                        
+                        Button(action: {
+                            showingLogoutAlert = true
+                        }) {
+                            Text("Sign Out")
+                                .font(.headline)
+                                .foregroundColor(.red)
+                                .frame(maxWidth: .infinity)
+                                .padding()
+                                .background(Color(UIColor.secondarySystemBackground))
+                                .cornerRadius(12)
+                        }
+                    }
+                    .padding()
+                    .background(AppColors.surface)
+                    .cornerRadius(16)
+                    .alert("Sign Out", isPresented: $showingLogoutAlert) {
+                        Button("Cancel", role: .cancel) { }
+                        Button("Sign Out", role: .destructive) {
+                            authService.signOut()
+                        }
+                    } message: {
+                        Text("Are you sure you want to sign out?")
+                    }
+                    
+                } else {
+                    // Guest State
+                    VStack(spacing: 20) {
+                        Image(systemName: "person.crop.circle.badge.questionmark")
+                            .font(.system(size: 60))
+                            .foregroundColor(.secondary)
+                        
+                        Text("Sign In")
+                            .font(.title2)
+                            .fontWeight(.bold)
+                        
+                        Text("Sign in to sync your mindfulness progress across devices.")
+                            .multilineTextAlignment(.center)
+                            .foregroundColor(.secondary)
+                            .font(.body)
+                        
+                        Button(action: {
+                            authService.signInWithGoogle()
+                        }) {
+                            HStack {
+                                Image(systemName: "globe")
+                                Text("Sign in with Google")
+                            }
+                            .font(.headline)
+                            .foregroundColor(.white)
+                            .frame(maxWidth: .infinity)
+                            .padding()
+                            .background(Color.blue)
+                            .cornerRadius(12)
+                        }
+                    }
+                    .padding()
+                    .background(AppColors.surface)
+                    .cornerRadius(16)
+                }
+                
+                // MARK: - Progress Section (Restored)
+                VStack(spacing: 16) {
+                    Text("Your Progress")
+                        .font(AppTypography.title2)
+                        .frame(maxWidth: .infinity, alignment: .leading)
+                    
+                    Text("Completed Lessons: \(viewModel.userProgress.completedLessons.count)")
+                        .font(.title3)
+                        .bold()
+                        .frame(maxWidth: .infinity, alignment: .leading)
+                    
+                    Divider()
+                    
+                    Button("Complete Demo Lesson") {
+                        viewModel.completeLesson("DEMO_IOS_\(Date().timeIntervalSince1970)")
+                    }
+                    .buttonStyle(.borderedProminent)
+                    .tint(AppColors.primary)
+                    .frame(maxWidth: .infinity)
+                    
+                    Button("Reset Progress", role: .destructive) {
+                        viewModel.resetProgress()
+                    }
+                    .buttonStyle(.bordered)
+                    .frame(maxWidth: .infinity)
+                }
+                .padding()
+                .background(AppColors.surface)
+                .cornerRadius(16)
+                
+                // MARK: - Dev Settings
+                NavigationLink(destination: DevSettingsView()) {
+                    HStack {
+                        Image(systemName: "gearshape.2.fill")
+                        Text("Developer Settings")
+                    }
+                    .foregroundColor(.secondary)
+                    .padding()
+                    .frame(maxWidth: .infinity)
+                    .background(Color(UIColor.secondarySystemBackground))
+                    .cornerRadius(12)
+                }
+                
+                Spacer()
+            }
+            .padding()
+        }
+        .background(AppColors.background)
+        .navigationTitle("Profile")
+    }
+}
diff --git a/TheMiddleWay/Sources/Features/Settings/DevSettingsViewModel.swift b/TheMiddleWay/Sources/Features/Settings/DevSettingsViewModel.swift
new file mode 100644
index 0000000..2ce7c03
--- /dev/null
+++ b/TheMiddleWay/Sources/Features/Settings/DevSettingsViewModel.swift
@@ -0,0 +1,30 @@
+import Foundation
+import SwiftUI
+import Combine
+
+enum ApiEnvironment: String, CaseIterable, Identifiable {
+    case render = "render"
+    case local = "local"
+    case custom = "custom"
+    
+    var id: String { self.rawValue }
+}
+
+class DevSettingsViewModel: ObservableObject {
+    @AppStorage("apiEnvironment") var apiEnvironment: ApiEnvironment = .render
+    @AppStorage("customApiUrl") var customApiUrl: String = "http://localhost:8080/api/v1/wisdom-garden"
+    
+    // Singleton for easy access in other VMs
+    static let shared = DevSettingsViewModel()
+    
+    func getBaseUrl() -> String {
+        switch apiEnvironment {
+        case .render:
+            return "https://themiddleway-backend-djw7.onrender.com/api/v1/wisdom-garden"
+        case .local:
+            return "http://localhost:8080/api/v1/wisdom-garden"
+        case .custom:
+            return customApiUrl
+        }
+    }
+}
diff --git a/TheMiddleWay/Sources/Features/Settings/Views/DevSettingsView.swift b/TheMiddleWay/Sources/Features/Settings/Views/DevSettingsView.swift
new file mode 100644
index 0000000..663d69b
--- /dev/null
+++ b/TheMiddleWay/Sources/Features/Settings/Views/DevSettingsView.swift
@@ -0,0 +1,34 @@
+import SwiftUI
+
+struct DevSettingsView: View {
+    @StateObject private var viewModel = DevSettingsViewModel.shared
+    
+    var body: some View {
+        Form {
+            Section(header: Text("Network Environment")) {
+                Picker("Environment", selection: $viewModel.apiEnvironment) {
+                    Text("Render (PROD)").tag(ApiEnvironment.render)
+                    Text("Localhost (DEV)").tag(ApiEnvironment.local)
+                    Text("Custom URL").tag(ApiEnvironment.custom)
+                }
+                .pickerStyle(.inline)
+                
+                if viewModel.apiEnvironment == .custom {
+                    TextField("https://...", text: $viewModel.customApiUrl)
+                        .autocapitalization(.none)
+                        .disableAutocorrection(true)
+                        .keyboardType(.URL)
+                }
+                
+                Text("Current Base URL:\n\(viewModel.getBaseUrl())")
+                    .font(.caption)
+                    .foregroundColor(.secondary)
+            }
+            
+            Section(header: Text("Debug Info")) {
+                Text("Version: 1.0.0 (Dev)")
+            }
+        }
+        .navigationTitle("Developer Settings")
+    }
+}
diff --git a/TheMiddleWay/Sources/Features/WisdomGarden/Data/NetworkWisdomGardenRepository.swift b/TheMiddleWay/Sources/Features/WisdomGarden/Data/NetworkWisdomGardenRepository.swift
index 446b8ca..307e23e 100644
--- a/TheMiddleWay/Sources/Features/WisdomGarden/Data/NetworkWisdomGardenRepository.swift
+++ b/TheMiddleWay/Sources/Features/WisdomGarden/Data/NetworkWisdomGardenRepository.swift
@@ -1,24 +1,35 @@
-
 import Foundation
 import Combine
 
-protocol WisdomGardenRepository {
-    func getWeeklyData(week: Int) async throws -> WeeklyData
-    func togglePractice(id: String, isCompleted: Bool) async throws
-}
 
 class NetworkWisdomGardenRepository: WisdomGardenRepository {
-    // For Simulator, localhost works. For device, need IP.
-    // Ensure "App Transport Security Settings" allows Arbitrary Loads or configure localhost.
-    private let baseURL = "http://localhost:8080/api/v1/wisdom-garden"
+    private var baseURL: String {
+        DevSettingsViewModel.shared.getBaseUrl()
+    }
+    
     private let session: URLSession
+    private let authService: AuthService
     
-    init(session: URLSession = .shared) {
+    init(session: URLSession = .shared, authService: AuthService = .shared) {
         self.session = session
+        self.authService = authService
     }
     
+    private let apiKey = AppSecrets.apiKey
+    
     func getWeeklyData(week: Int) async throws -> WeeklyData {
-        guard let url = URL(string: "\(baseURL)/weeks/\(week)") else {
... (Diff truncated for size) ...


PR TEMPLATE:


INSTRUCTIONS:
1. Generate a comprehensive PR description in Markdown format.
2. If a template is provided, fill it out intelligently.
3. If no template, use a standard structure: Summary, Changes, Impact.
4. Focus on 'Why' and 'What'.
5. Do not include 'Here is the PR description' preamble. Just the body.
6. IMPORTANT: Always use FULL URLs for links to issues and other PRs (e.g., https://github.com/owner/repo/issues/123), do NOT use short syntax (e.g., #123) to ensuring proper linking across platforms.
