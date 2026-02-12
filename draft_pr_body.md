Closes https://github.com/owner/repo/issues/1

### Summary

This pull request introduces the **"Wisdom Garden"** feature, a new core dashboard for the application. It replaces the previous `HomeView` and serves as the primary landing screen for users, accessible via the main "Garden" tab.

The Wisdom Garden is designed to provide a serene and motivating space for users to track their progress in Dhamma practice. It visualizes their efforts as a growing "Wisdom Tree" and provides a clear, interactive checklist of practices for each week. This implementation is built using SwiftUI and follows the MVVM pattern for a clean and scalable architecture.

### What's Changed?

-   **🌿 New Feature: Wisdom Garden Dashboard (`WisdomGardenView`)**
    -   A new, self-contained feature module has been created under `Features/WisdomGarden`.
    -   This view assembles all the new components into a cohesive dashboard experience.

-   **🌳 Wisdom Tree Visualization (`WisdomTreeVisualizationView`)**
    -   A central component that displays the user's progress for the selected week.
    -   Features a circular progress bar that fills as tasks are completed.
    -   An SF Symbol in the center dynamically changes from a seed (`leaf`) to a full tree (`tree.fill`) based on the completion percentage, providing a tangible sense of growth.

-   **✅ Interactive Practice Checklist (`PracticeChecklistView`)**
    -   Displays a list of practice items grouped by category (e.g., Giving, Morality).
    -   Users can tap items to mark them as complete. This action triggers:
        -   A satisfying haptic feedback (`UIImpactFeedbackGenerator`).
        -   A smooth animation on the checkbox.
        -   An immediate update to the score and the Wisdom Tree visualization.

-   **📅 Week Selector (`WeekSelectorView`)**
    -   A horizontal, scrollable selector that allows users to navigate between the 8 weeks of the program.
    -   The selected week's data is dynamically loaded into the dashboard.

-   **🧠 State Management & Data (`WisdomGardenViewModel`, `WisdomGardenData`)**
    -   A new `WisdomGardenViewModel` manages the state, including the currently selected week and the completion status of all practice items.
    -   The entire feature is powered by mock data defined in `WisdomGardenData.swift`, fulfilling the initial requirement to build the UI without a live backend.

-   **🏠 App Integration (`ContentView`)**
    -   The main `TabView` has been updated to replace the old `HomeView` with the new `WisdomGardenView`.
    -   The tab bar item has been updated to a `leaf.fill` icon and a "Garden" label, reflecting the new feature.

### How to Test

1.  Launch the app.
2.  Confirm that the new "Garden" screen is the default view.
3.  Use the **Week Selector** at the top to switch between Week 1 through 8. Verify that the checklist content updates accordingly.
4.  Tap on any checklist item.
5.  **Verify the following:**
    -   The item is checked and struck through.
    -   The score (`X / Y`) and the circular progress bar update instantly.
    -   The icon in the center of the progress circle changes as you complete more items.
    -   You feel a haptic "tap" on interaction.
6.  Un-check an item and confirm the score and progress bar revert correctly.

### Screenshot

*(A screen recording demonstrating the interactive checklist and the growing tree visualization would be ideal here.)*

| Before | After |
| :--- | :--- |
|  ![Old Home Screen](https://via.placeholder.com/300x650/f0f0f0/000000?text=Old+HomeView)  |  ![New Wisdom Garden](https://via.placeholder.com/300x650/e0f0ff/000000?text=New+Wisdom+Garden)  |