# PR Draft Prompt

You are an AI assistant helping to create a Pull Request description.
    
TASK: [Data] CSV Data Ingestion & Logic: Mapping 11 Categories and 8-Week Content
ISSUE: {
  "title": "[Data] CSV Data Ingestion & Logic: Mapping 11 Categories and 8-Week Content",
  "number": 5
}

GIT CONTEXT:
COMMITS:
9a61914 chore(release): bump version to 0.3.1 and update changelog
cab2473 docs: Update code review report with auto-tag workflow analysis
8898420 ci: improve robustness of version extraction logic
76b2aec ci: add auto-tag workflow on version change

STATS:
.github/workflows/auto-tag.yml         |  68 +++++++++++++
 CHANGELOG.md                           |   5 +
 TheMiddleWay.xcodeproj/project.pbxproj |   4 +-
 code_review.md                         | 173 ++++++++-------------------------
 4 files changed, 116 insertions(+), 134 deletions(-)

KEY FILE DIFFS:
diff --git a/.github/workflows/auto-tag.yml b/.github/workflows/auto-tag.yml
new file mode 100644
index 0000000..b71e2f5
--- /dev/null
+++ b/.github/workflows/auto-tag.yml
@@ -0,0 +1,68 @@
+name: Auto Tag on Version Change
+
+on:
+  push:
+    branches: [main]
+    paths:
+      - '**/*.pbxproj'
+
+permissions:
+  contents: write
+
+jobs:
+  auto-tag:
+    name: Create Git Tag from MARKETING_VERSION
+    runs-on: ubuntu-latest
+
+    steps:
+      - uses: actions/checkout@v4
+        with:
+          fetch-depth: 0
+
+      - name: Extract and validate version from project.pbxproj
+        id: version
+        run: |
+          PBXPROJ=$(find . -name "project.pbxproj" | head -1)
+          if [ -z "$PBXPROJ" ]; then
+            echo "::error::project.pbxproj not found."
+            exit 1
+          fi
+
+          # Extract all marketing versions, clean them up, and find the unique ones
+          UNIQUE_VERSIONS=$(grep 'MARKETING_VERSION' "$PBXPROJ" | sed 's/.*= *\(.*\);/\1/' | tr -d '[:space:]' | uniq)
+          
+          # Count the number of unique, non-empty version strings found
+          NUM_UNIQUE=$(echo "$UNIQUE_VERSIONS" | grep -c .)
+
+          if [ "$NUM_UNIQUE" -ne 1 ]; then
+            echo "::error::Error: Found multiple different MARKETING_VERSION values or no value was found."
+            echo "Please ensure all build configurations have the same version number in $PBXPROJ."
+            echo "Unique versions found:"
+            echo "$UNIQUE_VERSIONS"
+            exit 1
+          fi
+
+          VERSION=$UNIQUE_VERSIONS
+          echo "version=$VERSION" >> $GITHUB_OUTPUT
+          echo "tag=v$VERSION" >> $GITHUB_OUTPUT
+          echo "📦 Detected version: $VERSION (from $PBXPROJ)"
+
+      - name: Check if tag already exists
+        id: check
+        run: |
+          if git rev-parse "v${{ steps.version.outputs.version }}" >/dev/null 2>&1; then
+            echo "exists=true" >> $GITHUB_OUTPUT
+            echo "⏩ Tag v${{ steps.version.outputs.version }} already exists, skipping."
+          else
+            echo "exists=false" >> $GITHUB_OUTPUT
+            echo "🆕 Tag v${{ steps.version.outputs.version }} does not exist yet."
+          fi
+
+      - name: Create and push tag
+        if: steps.check.outputs.exists == 'false'
+        run: |
+          git config user.name "github-actions[bot]"
+          git config user.email "github-actions[bot]@users.noreply.github.com"
+          git tag -a "v${{ steps.version.outputs.version }}" -m "Release v${{ steps.version.outputs.version }}"
+          git push origin "v${{ steps.version.outputs.version }}"
+          echo "✅ Tagged v${{ steps.version.outputs.version }}"
diff --git a/CHANGELOG.md b/CHANGELOG.md
index f1d1cf3..93e9a94 100644
--- a/CHANGELOG.md
+++ b/CHANGELOG.md
@@ -1,5 +1,10 @@
 # Changelog
 
+## [0.3.1] - 2026-02-11
+
+### Changed
+- Internal improvements to the continuous integration (CI) workflow for automated version tagging.
+
 ## [0.3.0] - 2026-02-11
 
 ### Added
diff --git a/TheMiddleWay.xcodeproj/project.pbxproj b/TheMiddleWay.xcodeproj/project.pbxproj
index 1e871a7..12a150e 100644
--- a/TheMiddleWay.xcodeproj/project.pbxproj
+++ b/TheMiddleWay.xcodeproj/project.pbxproj
@@ -394,7 +394,7 @@
 					"$(inherited)",
 					"@executable_path/Frameworks",
 				);
-				MARKETING_VERSION = 0.3.0;
+				MARKETING_VERSION = 0.3.1;
 				PRODUCT_BUNDLE_IDENTIFIER = com.oatrice.themiddleway;
 				PRODUCT_NAME = "$(TARGET_NAME)";
 				SWIFT_EMIT_LOC_STRINGS = YES;
@@ -423,7 +423,7 @@
 					"$(inherited)",
 					"@executable_path/Frameworks",
 				);
-				MARKETING_VERSION = 0.3.0;
+				MARKETING_VERSION = 0.3.1;
 				PRODUCT_BUNDLE_IDENTIFIER = com.oatrice.themiddleway;
 				PRODUCT_NAME = "$(TARGET_NAME)";
 				SWIFT_EMIT_LOC_STRINGS = YES;
diff --git a/code_review.md b/code_review.md
index 62fe4aa..14aecc9 100644
--- a/code_review.md
+++ b/code_review.md
@@ -1,153 +1,62 @@
 # Luma Code Review Report
 
-**Date:** 2026-02-11 11:30:37
-**Files Reviewed:** ['TheMiddleWay/Sources/App/Core/Services/PersistenceService.swift', 'TheMiddleWay/Sources/App/Core/Models/UserProgress.swift', '.github/workflows/ios-testflight.yml', 'TheMiddleWay/Sources/App/TheMiddleWayApp.swift', 'TheMiddleWay/Sources/Core/ViewModels/MainViewModel.swift', 'TheMiddleWay/Sources/App/Core/Theme/ThemeConfig.swift', 'TheMiddleWay/Sources/App/Core/Theme/AppTypography.swift', 'TheMiddleWay/Sources/App/ContentView.swift', 'TheMiddleWay.xcodeproj/project.pbxproj', 'TheMiddleWay/Sources/App/Core/Theme/AppColors.swift', 'TheMiddleWay/Sources/App/Core/Theme/AppTheme.swift', 'TheMiddleWay/Sources/Core/Models/UserProgress.swift', 'TheMiddleWay/Sources/Core/Services/PersistenceService.swift', 'TheMiddleWay/Sources/Core/Theme/AppTheme.swift']
+**Date:** 2026-02-11 15:45:25
+**Files Reviewed:** ['.github/workflows/auto-tag.yml']
 
 ## 📝 Reviewer Feedback
 
-There are two major logical issues in the submitted code related to state management that will lead to bugs and inconsistent application behavior.
-
-### Issue 1: Unsafe State Modification in `MainViewModel`
-
-**File:** `TheMiddleWay/Sources/Core/ViewModels/MainViewModel.swift`
-
-**Problem:** The methods `completeLesson`, `toggleTheme`, and `resetProgress` modify the `userProgress` state in a non-atomic way. They read the `@Published` property into a local variable, modify the local variable, and then save it. If two of these methods are called in quick succession, a race condition can occur, causing one of the updates to be lost.
-
-For example, if `completeLesson` is called, and then `toggleTheme` is called before `completeLesson` finishes saving, `toggleTheme` will read the *original* state (before the lesson was completed). When `toggleTheme` saves its changes, it will overwrite the changes made by `completeLesson`.
-
-**Fix:** Use the atomic `updateProgress` function already defined in `PersistenceService`. This function encapsulates the read-modify-write cycle, preventing race conditions. Additionally, after a successful update, the ViewModel should reload the state from the persistence layer to ensure the UI is synchronized with the stored data.
-
-**Example Refactor for `MainViewModel.swift`:**
-
-```swift
-import SwiftUI
-import Combine
-
-class MainViewModel: ObservableObject {
-    @Published var userProgress: UserProgress
-    private let persistenceService: PersistenceService
-    
-    init(service: PersistenceService = PersistenceServiceImpl()) {
-        self.persistenceService = service
-        self.userProgress = service.loadProgress() ?? UserProgress.defaultProgress
-    }
-    
-    private func reloadProgress() {
-        if let progress = persistenceService.loadProgress() {
-            // Ensure UI updates happen on the main thread
-            DispatchQueue.main.async {
-                self.userProgress = progress
-            }
-        }
-    }
-    
-    func completeLesson(_ lessonId: String) {
-        let updated = persistenceService.updateProgress { progress in
-            if !progress.completedLessons.contains(lessonId) {
-                progress.completedLessons.append(lessonId)
-                progress.lastVisited = Date()
-            }
-        }
-        if updated {
-            reloadProgress()
-        }
-    }
-    
-    func toggleTheme(isDark: Bool) {
-        let updated = persistenceService.updateProgress { progress in
-            progress.themeMode = isDark ? .dark : .light
-        }
-        if updated {
-            reloadProgress()
-        }
-    }
-    
-    func resetProgress() {
-        if persistenceService.clearProgress() {
-            // After clearing, the new default state needs to be set
-            DispatchQueue.main.async {
-                self.userProgress = UserProgress.defaultProgress
-            }
-        }
-    }
-}
-```
-
----
+The provided GitHub Actions workflow has a critical logic issue in its version extraction step that makes it brittle and prone to failure.
 
-### Issue 2: Conflicting Sources of Truth for Theme State
+**Problem:**
 
-**Files:** `TheMiddleWay/Sources/App/ContentView.swift`, `TheMiddleWay/Sources/App/Core/Theme/AppTheme.swift`
+The script uses a `grep | head -1 | sed` pipeline to find the version number. This approach has two main flaws:
 
-**Problem:** The application has two separate and unsynchronized sources of truth for the current theme (light/dark mode):
-1.  `@AppStorage("isDarkMode")` is used directly in `ContentView` and `ThemedNavigationStack`.
-2.  `MainViewModel.userProgress.themeMode` is stored as part of the user's progress via `PersistenceService`.
+1.  **Picks the First Match:** An Xcode project file (`.pbxproj`) often contains multiple `MARKETING_VERSION` entries, one for each build configuration (e.g., Debug, Release). If these versions ever differ, the script will arbitrarily pick the first one it finds, which may not be the intended version for tagging.
+2.  **No Validation:** If the `grep` and `sed` commands fail to extract a version for any reason (e.g., a change in the `.pbxproj` format), the `VERSION` variable will be empty. The script does not check for this, and will proceed to create and push an invalid tag named `v`.
 
-The `MainViewModel` has a `toggleTheme` method that updates `userProgress.themeMode`, but this will have no effect on the UI because the views are reading their theme state from `@AppStorage`. This leads to the UI theme being completely disconnected from the user's saved progress.
+**Fix:**
 
-**Fix:** Remove the use of `@AppStorage` for theme management and establish `MainViewModel.userProgress` as the single source of truth. Views should observe the theme from the `MainViewModel` via `@EnvironmentObject`.
+The version extraction step should be made more robust. It should verify that all `MARKETING_VERSION` entries in the file are identical and fail gracefully if they are not, or if no version is found.
 
-**1. Update `ContentView.swift`:**
+Replace the `Extract version from project.pbxproj` step with the following:
 
-```swift
-import SwiftUI
+```yaml
+      - name: Extract and validate version from project.pbxproj
+        id: version
+        run: |
+          PBXPROJ=$(find . -name "project.pbxproj" | head -1)
+          if [ -z "$PBXPROJ" ]; then
+            echo "::error::project.pbxproj not found."
+            exit 1
+          fi
 
-struct ContentView: View {
-    @State private var selectedTab: Tab = .home
-    @EnvironmentObject var viewModel: MainViewModel // Use the ViewModel for state
+          # Extract all marketing versions, clean them up, and find the unique ones
+          UNIQUE_VERSIONS=$(grep 'MARKETING_VERSION' "$PBXPROJ" | sed 's/.*= *\(.*\);/\1/' | tr -d '[:space:]' | uniq)
+          
+          # Count the number of unique, non-empty version strings found
+          NUM_UNIQUE=$(echo "$UNIQUE_VERSIONS" | grep -c .)
 
-    private var themeScheme: ColorScheme {
-        // Read theme from the single source of truth
-        viewModel.userProgress.themeMode == .dark ? .dark : .light
-    }
-    
-    var body: some View {
-        TabView(selection: $selectedTab) {
-            // ... Tab items ...
-        }
-        .tint(AppColors.primary)
-        .toolbarBackground(AppColors.background, for: .tabBar)
-        .toolbarBackground(.visible, for: .tabBar)
-        .toolbarColorScheme(themeScheme, for: .tabBar)
-        .preferredColorScheme(themeScheme) // Apply the theme here
-    }
-}
-```
+          if [ "$NUM_UNIQUE" -ne 1 ]; then
+            echo "::error::Error: Found multiple different MARKETING_VERSION values or no value was found."
+            echo "Please ensure all build configurations have the same version number in $PBXPROJ."
+            echo "Unique versions found:"
+            echo "$UNIQUE_VERSIONS"
+            exit 1
+          fi
 
-**2. Update `ThemedNavigationStack.swift`:**
-
-```swift
-import SwiftUI
-
-struct ThemedNavigationStack<Content: View>: View {
-    @EnvironmentObject var viewModel: MainViewModel // Use the ViewModel for state
-    private let content: Content
-
-    private var themeScheme: ColorScheme {
-        viewModel.userProgress.themeMode == .dark ? .dark : .light
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
+          VERSION=$UNIQUE_VERSIONS
+          echo "version=$VERSION" >> $GITHUB_OUTPUT
+          echo "tag=v$VERSION" >> $GITHUB_OUTPUT
+          echo "📦 Detected version: $VERSION (from $PBXPROJ)"
 ```
 
-With these changes, the entire app's theme will be driven by the `userProgress` object in the `MainViewModel`, creating a single, consistent source of truth. You would then add a UI control (e.g., a `Toggle` in `ProfileView`) to call `viewModel.toggleTheme(isDark:)` to allow the user to change the theme.
+This revised script first finds all unique version strings. It then checks if exactly one unique version was found. If not (i.e., zero or more than one), it fails the workflow with a clear error message, preventing the creation of an incorrect or empty tag.
 
 ## 🧪 Test Suggestions
 
-*   **First-time update on a clean install:** Verify that calling `updateProgress` when no data exists in `UserDefaults` correctly creates a new `UserProgress` object using `UserProgress.defaultProgress`, applies the update, and saves it. For example, add a bookmark, then load the progress and assert that the bookmark is present *and* all other properties (like `themeMode` and `language`) have their default values.
-*   **Handling corrupted or mismatched data:** Manually save malformed or outdated JSON data to the `UserDefaults` key. Verify that `loadProgress()` gracefully fails by returning `nil` instead of crashing. Then, confirm that a subsequent call to `updateProgress` correctly ignores the corrupted data and proceeds as if it were a first-time update, creating a new default progress object.
-*   **State after clearing progress:** Save a custom `UserProgress` object, then call `clearProgress()`. Immediately after, call `loadProgress()` and assert that it returns `nil`. This ensures the data is completely removed and the state is reset.
+*   **Multiple `project.pbxproj` files:** Create a repository with two or more Xcode projects (e.g., `ProjectA/ProjectA.xcodeproj` and `ProjectB/ProjectB.xcodeproj`). Modify the `MARKETING_VERSION` only in the project that does not come first alphabetically (`ProjectB`). The test should verify that the workflow incorrectly extracts the version from the first project it finds (`ProjectA`) and either creates the wrong tag or skips the process.
+
+*   **Multiple `MARKETING_VERSION` entries in one file:** Modify a `project.pbxproj` to have different `MARKETING_VERSION` values for different build configurations (e.g., `1.2.3` for Release and `1.2.4-debug` for Debug). Ensure the Debug configuration appears before the Release configuration in the file. The test should verify that the workflow incorrectly extracts the first version it finds (`1.2.4-debug`) instead of the intended release version.
+
+*   **Version string containing quotes:** Set the version in the `.pbxproj` file with explicit quotes, such as `MARKETING_VERSION = "2.0.0";`. The test should verify that the script incorrectly extracts the version as `"2.0.0"` (including the quotes) and attempts to create an invalid tag like `v"2.0.0"`.

PR TEMPLATE:


INSTRUCTIONS:
1. Generate a comprehensive PR description in Markdown format.
2. If a template is provided, fill it out intelligently.
3. If no template, use a standard structure: Summary, Changes, Impact.
4. Focus on 'Why' and 'What'.
5. Do not include 'Here is the PR description' preamble. Just the body.
6. IMPORTANT: Always use FULL URLs for links to issues and other PRs (e.g., https://github.com/owner/repo/issues/123), do NOT use short syntax (e.g., #123) to ensuring proper linking across platforms.
