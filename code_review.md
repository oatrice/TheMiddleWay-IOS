# Luma Code Review Report

**Date:** 2026-02-11 11:30:37
**Files Reviewed:** ['TheMiddleWay/Sources/App/Core/Services/PersistenceService.swift', 'TheMiddleWay/Sources/App/Core/Models/UserProgress.swift', '.github/workflows/ios-testflight.yml', 'TheMiddleWay/Sources/App/TheMiddleWayApp.swift', 'TheMiddleWay/Sources/Core/ViewModels/MainViewModel.swift', 'TheMiddleWay/Sources/App/Core/Theme/ThemeConfig.swift', 'TheMiddleWay/Sources/App/Core/Theme/AppTypography.swift', 'TheMiddleWay/Sources/App/ContentView.swift', 'TheMiddleWay.xcodeproj/project.pbxproj', 'TheMiddleWay/Sources/App/Core/Theme/AppColors.swift', 'TheMiddleWay/Sources/App/Core/Theme/AppTheme.swift', 'TheMiddleWay/Sources/Core/Models/UserProgress.swift', 'TheMiddleWay/Sources/Core/Services/PersistenceService.swift', 'TheMiddleWay/Sources/Core/Theme/AppTheme.swift']

## 📝 Reviewer Feedback

There are two major logical issues in the submitted code related to state management that will lead to bugs and inconsistent application behavior.

### Issue 1: Unsafe State Modification in `MainViewModel`

**File:** `TheMiddleWay/Sources/Core/ViewModels/MainViewModel.swift`

**Problem:** The methods `completeLesson`, `toggleTheme`, and `resetProgress` modify the `userProgress` state in a non-atomic way. They read the `@Published` property into a local variable, modify the local variable, and then save it. If two of these methods are called in quick succession, a race condition can occur, causing one of the updates to be lost.

For example, if `completeLesson` is called, and then `toggleTheme` is called before `completeLesson` finishes saving, `toggleTheme` will read the *original* state (before the lesson was completed). When `toggleTheme` saves its changes, it will overwrite the changes made by `completeLesson`.

**Fix:** Use the atomic `updateProgress` function already defined in `PersistenceService`. This function encapsulates the read-modify-write cycle, preventing race conditions. Additionally, after a successful update, the ViewModel should reload the state from the persistence layer to ensure the UI is synchronized with the stored data.

**Example Refactor for `MainViewModel.swift`:**

```swift
import SwiftUI
import Combine

class MainViewModel: ObservableObject {
    @Published var userProgress: UserProgress
    private let persistenceService: PersistenceService
    
    init(service: PersistenceService = PersistenceServiceImpl()) {
        self.persistenceService = service
        self.userProgress = service.loadProgress() ?? UserProgress.defaultProgress
    }
    
    private func reloadProgress() {
        if let progress = persistenceService.loadProgress() {
            // Ensure UI updates happen on the main thread
            DispatchQueue.main.async {
                self.userProgress = progress
            }
        }
    }
    
    func completeLesson(_ lessonId: String) {
        let updated = persistenceService.updateProgress { progress in
            if !progress.completedLessons.contains(lessonId) {
                progress.completedLessons.append(lessonId)
                progress.lastVisited = Date()
            }
        }
        if updated {
            reloadProgress()
        }
    }
    
    func toggleTheme(isDark: Bool) {
        let updated = persistenceService.updateProgress { progress in
            progress.themeMode = isDark ? .dark : .light
        }
        if updated {
            reloadProgress()
        }
    }
    
    func resetProgress() {
        if persistenceService.clearProgress() {
            // After clearing, the new default state needs to be set
            DispatchQueue.main.async {
                self.userProgress = UserProgress.defaultProgress
            }
        }
    }
}
```

---

### Issue 2: Conflicting Sources of Truth for Theme State

**Files:** `TheMiddleWay/Sources/App/ContentView.swift`, `TheMiddleWay/Sources/App/Core/Theme/AppTheme.swift`

**Problem:** The application has two separate and unsynchronized sources of truth for the current theme (light/dark mode):
1.  `@AppStorage("isDarkMode")` is used directly in `ContentView` and `ThemedNavigationStack`.
2.  `MainViewModel.userProgress.themeMode` is stored as part of the user's progress via `PersistenceService`.

The `MainViewModel` has a `toggleTheme` method that updates `userProgress.themeMode`, but this will have no effect on the UI because the views are reading their theme state from `@AppStorage`. This leads to the UI theme being completely disconnected from the user's saved progress.

**Fix:** Remove the use of `@AppStorage` for theme management and establish `MainViewModel.userProgress` as the single source of truth. Views should observe the theme from the `MainViewModel` via `@EnvironmentObject`.

**1. Update `ContentView.swift`:**

```swift
import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    @EnvironmentObject var viewModel: MainViewModel // Use the ViewModel for state

    private var themeScheme: ColorScheme {
        // Read theme from the single source of truth
        viewModel.userProgress.themeMode == .dark ? .dark : .light
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // ... Tab items ...
        }
        .tint(AppColors.primary)
        .toolbarBackground(AppColors.background, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarColorScheme(themeScheme, for: .tabBar)
        .preferredColorScheme(themeScheme) // Apply the theme here
    }
}
```

**2. Update `ThemedNavigationStack.swift`:**

```swift
import SwiftUI

struct ThemedNavigationStack<Content: View>: View {
    @EnvironmentObject var viewModel: MainViewModel // Use the ViewModel for state
    private let content: Content

    private var themeScheme: ColorScheme {
        viewModel.userProgress.themeMode == .dark ? .dark : .light
    }
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack {
            content
                .background(AppColors.background)
                .toolbarBackground(AppColors.background, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(themeScheme, for: .navigationBar)
        }
    }
}
```

With these changes, the entire app's theme will be driven by the `userProgress` object in the `MainViewModel`, creating a single, consistent source of truth. You would then add a UI control (e.g., a `Toggle` in `ProfileView`) to call `viewModel.toggleTheme(isDark:)` to allow the user to change the theme.

## 🧪 Test Suggestions

*   **First-time update on a clean install:** Verify that calling `updateProgress` when no data exists in `UserDefaults` correctly creates a new `UserProgress` object using `UserProgress.defaultProgress`, applies the update, and saves it. For example, add a bookmark, then load the progress and assert that the bookmark is present *and* all other properties (like `themeMode` and `language`) have their default values.
*   **Handling corrupted or mismatched data:** Manually save malformed or outdated JSON data to the `UserDefaults` key. Verify that `loadProgress()` gracefully fails by returning `nil` instead of crashing. Then, confirm that a subsequent call to `updateProgress` correctly ignores the corrupted data and proceeds as if it were a first-time update, creating a new default progress object.
*   **State after clearing progress:** Save a custom `UserProgress` object, then call `clearProgress()`. Immediately after, call `loadProgress()` and assert that it returns `nil`. This ensures the data is completely removed and the state is reset.

