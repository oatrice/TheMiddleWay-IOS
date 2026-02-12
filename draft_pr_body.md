Closes: https://github.com/owner/repo/issues/2

### 📝 Summary

This pull request introduces the new **"ห้องปฏิบัติธรรม" (Practice Room)** screen, a dedicated space for users to actively engage with their weekly spiritual practices. As outlined in the issue, this feature separates the interactive checklist functionality from the main "สวนแห่งปัญญา" (Wisdom Garden/Dashboard), creating a more focused and user-friendly experience for "doing the work."

The new screen allows users to select a week, view the corresponding practices, and check them off as they are completed. Progress is persisted through a new network layer, ensuring data is saved even when the app is closed.

### ✨ Key Changes

1.  **New `WeeklyPracticesView.swift` Screen:**
    *   Creates the "Practice Room" UI, which serves as the primary interaction point for the weekly checklists.
    *   Includes a `WeekSelectorView` to navigate between Weeks 1-8.
    *   Displays the user's current score for the selected week.

2.  **Network Layer (`NetworkWisdomGardenRepository`):**
    *   Instead of using LocalStorage, a robust network repository has been implemented to fetch weekly data and save progress to a backend server (currently pointed at `localhost`).
    *   This provides a more scalable and persistent data storage solution.
    *   The `togglePractice` function sends updates to the server when a user checks or unchecks an item.

3.  **ViewModel with Optimistic Updates (`WisdomGardenViewModel`):**
    *   The view model now communicates with the `WisdomGardenRepository` to load and update data asynchronously.
    *   The `toggleItem` function uses an **optimistic update** strategy: the UI responds instantly to user taps, and a network request is sent in the background. If the request fails, the UI state is reverted, providing a snappy and responsive user experience.

4.  **Enhanced & Reusable `PracticeChecklistView`:**
    *   A `readOnly` mode has been added to the checklist component.
    *   The new "Practice Room" uses this component in its interactive mode (`readOnly: false`).
    *   The main "Wisdom Garden" (Dashboard) can now use the same component in `readOnly: true` mode to display progress without allowing interaction, ensuring UI consistency.

### 🎥 How to Test

1.  Launch the app and navigate to the new "Practice Room" screen.
2.  Use the week selector at the top to switch between weeks (e.g., Week 1, Week 2).
3.  **Observe:** The checklist items and the score should update to reflect the content for the selected week.
4.  Tap on any practice item in the list.
5.  **Verify:**
    *   The item is marked as complete (checkmark appears, text has a strikethrough).
    *   You feel a haptic feedback on tap.
    *   The score at the top increases accordingly.
6.  Tap the same item again to uncheck it and verify the state reverts.
7.  Navigate away from the screen and then return. The checked items should remain checked, demonstrating persistence.

### 🖼️ Screenshots

_Screencast of the new Practice Room screen in action, showing week selection and checklist interaction._

<details>
<summary>Reference Screenshot from Issue</summary> ![Reference Design](https://user-images.githubusercontent.com/path/to/image.png) 
</details>