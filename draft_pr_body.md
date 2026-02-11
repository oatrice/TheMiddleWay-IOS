Closes https://github.com/owner/repo/issues/6

### Summary

This pull request introduces a foundational persistence layer to the application using `UserDefaults`. The primary goal is to track and store user progress, settings, and preferences locally on the device. This includes completed lessons, theme selection (light/dark mode), and other user-specific data.

A centralized `MainViewModel` has been created to manage the application's state, acting as a single source of truth for user progress. This state is now propagated through the view hierarchy using SwiftUI's `EnvironmentObject`, ensuring a clean and scalable architecture.

### Key Changes

1.  **Persistence Service & User Progress Model**
    *   Introduced a `PersistenceService` protocol and a `PersistenceServiceImpl` that uses `UserDefaults` with `JSONEncoder`/`JSONDecoder` for storing data. This provides a type-safe and easily extensible way to manage stored data.
    *   Created a `Codable` `UserProgress` struct to model all persistable data, including `themeMode`, `completedLessons`, `bookmarks`, and `lastVisited` timestamp.

2.  **Centralized State Management (`MainViewModel`)**
    *   A new `MainViewModel` class, conforming to `ObservableObject`, has been implemented to manage the `userProgress` state.
    *   This ViewModel is injected as an `EnvironmentObject` at the root of the application (`TheMiddleWayApp.swift`), making it accessible to any view that needs it.
    *   It handles loading progress on app launch and provides methods to update the state (e.g., `completeLesson`, `toggleTheme`, `resetProgress`), which in turn saves the changes via the `PersistenceService`.

3.  **Theme System Refactor**
    *   The theme system has been completely overhauled. A new dynamic `AppColors` enum and `AppTypography` system have been established to support both light and dark modes consistently.
    *   Theme selection has been migrated from a simple `@AppStorage` boolean to being part of the `UserProgress` model. This allows the user's theme choice to be persisted along with their other data.
    *   Views like `ContentView` and `ThemedNavigationStack` now react to theme changes published by the `MainViewModel`.

4.  **UI Integration & Demonstration**
    *   The `ContentView` and its subviews have been refactored to consume the `MainViewModel` from the environment instead of managing their own state.
    *   The `ProfileView` has been updated to display the user's progress (e.g., number of completed lessons) and includes new buttons to "Complete Demo Lesson" and "Reset Progress" for testing the persistence functionality.

### Impact

*   **User Experience:** User settings and progress are now saved across app sessions, providing a continuous and personalized experience.
*   **Architecture:** Establishes a robust and scalable pattern for state management and data persistence, moving away from scattered `@AppStorage` properties.
*   **Maintainability:** Centralizing state logic in the `MainViewModel` makes the codebase easier to understand, debug, and extend in the future.

### How to Test

1.  Launch the app and navigate to the **Profile** tab.
2.  The "Completed Lessons" count should be 0.
3.  Tap the **"Complete Demo Lesson"** button. The count should increment.
4.  Force-quit and relaunch the app.
5.  Navigate back to the **Profile** tab and verify that the lesson count is preserved.
6.  Tap the **"Reset Progress"** button. The count should return to 0.
7.  Force-quit and relaunch again to confirm the progress has been cleared.