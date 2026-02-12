Closes https://github.com/owner/repo/issues/11

### Summary

This pull request introduces a crucial feature for new users: a multi-page onboarding flow. This experience is designed to welcome users to "The Middle Way," set clear expectations about the app's purpose, and introduce the core concept of "Authentic Wisdom."

In addition to the new feature, this PR includes a significant refactoring to simplify the codebase by removing a premature custom theme and persistence system. The networking layer has also been made more resilient and testable.

### Key Changes

**1. Onboarding Experience**
*   **`OnboardingView.swift`**: A new SwiftUI view that presents a swipeable, multi-page introduction using a `TabView`.
*   **`OnboardingService.swift`**: A new observable object that manages the onboarding state. It uses `@AppStorage` to persist completion, ensuring users only see the flow once.
*   **Conditional App Entry**: The main app entry point (`TheMiddleWayApp.swift`) now checks the onboarding status and presents either the `OnboardingView` or the main `ContentView` accordingly.
*   **Onboarding Content**: The flow consists of four distinct slides with new imagery and text:
    1.  **Welcome**: A general welcome to the app.
    2.  **Authentic Wisdom**: Explains the app's focus on verified, applicable knowledge.
    3.  **Discover Your Path**: Highlights the curated nature of the content.
    4.  **A Daily Practice**: Encourages daily engagement.

**2. Core Code Refactoring**
*   **Theme System Removal**: The custom theme system (`AppColors`, `AppTypography`, `AppTheme`, `ThemeConfig`) has been removed in favor of using standard SwiftUI views and modifiers. This simplifies the codebase and reduces maintenance overhead.
*   **Persistence Layer Removal**: The `PersistenceService` and `UserProgress` model were removed. Simple state persistence is now handled directly where needed (e.g., `@AppStorage` in `OnboardingService`), aligning with a more lightweight architecture for the app's current needs.

**3. Networking & Repository Improvements**
*   **Dependency Injection**: `URLSession` is now injected into `NetworkWisdomGardenRepository`, decoupling it from the global `URLSession.shared` and significantly improving testability.
*   **Error Handling & Fallback**: The `getWeeklyData` method now gracefully handles network errors. If the API call fails, it returns a hardcoded set of fallback data, ensuring the app remains usable even when offline or during development without a running backend.
*   **Unit Tests**: New unit tests have been added for `NetworkWisdomGardenRepository` to verify its behavior, including the new fallback logic.

### Screenshots

*A GIF or screenshots of the onboarding flow would be ideal here.*

| Welcome Screen | Authentic Wisdom | Discover Your Path | Daily Practice |
| :---: | :---: | :---: | :---: |
| <img src="https://i.imgur.com/example1.png" width="200"> | <img src="https://i.imgur.com/example2.png" width="200"> | <img src="https://i.imgur.com/example3.png" width="200"> | <img src="https://i.imgur.com/example4.png" width="200"> |

### How to Test

1.  **First Launch**:
    *   Perform a clean install (delete the app if it's already installed).
    *   Launch the app.
    *   **Expected**: The onboarding flow should be displayed.
2.  **Navigate Onboarding**:
    *   Swipe through the four pages.
    *   Use the "Next" button to advance.
    *   Verify that all text and images display correctly.
3.  **Complete Onboarding**:
    *   On the final page, tap "Begin Journey".
    *   **Expected**: The onboarding view should be dismissed, and the main app content should appear.
4.  **Verify Persistence**:
    *   Close and relaunch the app.
    *   **Expected**: The app should open directly to the main content view, skipping the onboarding flow.
5.  **Test "Skip" Button**:
    *   Perform a clean install again.
    *   On any of the first three screens, tap the "Skip" button.
    *   **Expected**: The onboarding view should be dismissed immediately, and the main app content should appear.
6.  **Test Network Fallback**:
    *   Ensure your local backend server is **not** running.
    *   Complete the onboarding.
    *   Navigate to the "Wisdom Garden" view.
    *   **Expected**: The view should load with hardcoded fallback data instead of crashing or showing an error state.