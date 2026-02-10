This Pull Request implements a foundational design system, introducing a robust, dual-theme architecture with support for both light and dark modes. It establishes a consistent visual language for colors and typography, enhancing the user experience and developer workflow.

Closes: https://github.com/owner/repo/issues/4

### Summary

The primary goal of this PR is to implement the core components of our design system as specified in the issue. This includes:
- A dynamic color system that adapts to light and dark modes.
- The "Deep Cosmos" dark theme, featuring a Navy background (`#0A192F`) and Amber primary accent (`#F59E0B`).
- An updated "Bright Sky" light theme for a fresh, modern aesthetic.
- A persistent theme toggle, allowing users to switch between modes and have their preference saved.
- A reusable `ThemedNavigationStack` component to ensure consistent styling across all navigation flows.

### Key Changes

1.  **Dual-Theme Color System (`AppColors.swift`)**
    -   `AppColors` has been refactored to define separate color palettes for `Light` and `Dark` modes.
    -   A `Color.dynamic` extension was created, leveraging `UIColor`'s dynamic provider to automatically select the correct color based on the active `userInterfaceStyle`.
    -   This replaces the previous static color palette with a fully adaptive system.

2.  **Persistent Dark Mode Toggle**
    -   A theme toggle button has been added to the navigation bar on the `HomeView`.
    -   The user's theme preference is saved to `UserDefaults` via `@AppStorage`, ensuring it persists across app launches.
    -   A new `ThemeConfig` enum centralizes constants and logic related to theming (e.g., storage key, toggle icon names).

3.  **Themed UI Components (`AppTheme.swift`)**
    -   A new reusable `ThemedNavigationStack` view has been introduced. This component encapsulates the `NavigationStack` and applies all necessary theme-related modifiers for the background and toolbar, promoting code reuse and consistency.
    -   `ContentView` has been refactored to use `ThemedNavigationStack` for each tab, simplifying the view hierarchy.
    -   The main `TabView` is now styled to respect the selected theme, including the tab bar background and icon/text colors.

4.  **Typography Integration**
    -   The new dynamic text colors (`textPrimary`, `textSecondary`) are designed to work seamlessly with the existing `AppTypography` system, ensuring text remains legible and stylistically consistent in both light and dark modes.

### Impact

-   **UX:** Introduces a highly-requested dark mode feature and improves visual consistency throughout the app.
-   **Architecture:** Establishes a scalable and maintainable design system foundation.
-   **Developer Experience:** Simplifies the application of themes through reusable components like `ThemedNavigationStack`, reducing boilerplate and potential for inconsistencies.