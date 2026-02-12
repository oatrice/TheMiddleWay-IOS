# Luma Code Review Report

**Date:** 2026-02-12 16:21:48
**Files Reviewed:** ['TheMiddleWay.xcodeproj/project.pbxproj', 'TheMiddleWay/Sources/Features/WisdomGarden/Views/Components/PracticeChecklistView.swift', 'TheMiddleWay/Sources/Features/WisdomGarden/Views/WisdomGardenView.swift', 'TheMiddleWay/Sources/Features/WisdomGarden/Views/WeeklyPracticesView.swift', 'TheMiddleWay/Sources/Features/WisdomGarden/Data/NetworkWisdomGardenRepository.swift', 'TheMiddleWay/Sources/Features/WisdomGarden/Models/WisdomGardenModels.swift', 'TheMiddleWay/Sources/Features/WisdomGarden/Data/WisdomGardenData.swift', 'TheMiddleWay/Sources/Features/WisdomGarden/ViewModels/WisdomGardenViewModel.swift']

## 📝 Reviewer Feedback

In `WisdomGardenViewModel.swift`, the `loadWeeklyData` function fetches data from the network every time the selected week changes, even if that week's data has already been fetched and stored in the `weeklyDataMap`. This results in unnecessary network requests and a slower user experience when switching back to a previously viewed week.

**The Fix:**

Modify the `loadWeeklyData` function to check if the data for the requested week already exists in the `weeklyDataMap` before making a network call.

**File:** `TheMiddleWay/Sources/Features/WisdomGarden/ViewModels/WisdomGardenViewModel.swift`

**Problematic Code:**
```swift
@MainActor
func loadWeeklyData(for week: Int) async {
    do {
        let data = try await repository.getWeeklyData(week: week)
        weeklyDataMap[week] = data
    } catch {
        print("\u{274c} [VM] Error fetching data for week \(week): \(error)")
    }
}
```

**Suggested Code:**
```swift
@MainActor
func loadWeeklyData(for week: Int) async {
    // Return if data for the selected week is already cached.
    if weeklyDataMap[week] != nil {
        return
    }

    do {
        let data = try await repository.getWeeklyData(week: week)
        weeklyDataMap[week] = data
    } catch {
        print("\u{274c} [VM] Error fetching data for week \(week): \(error)")
    }
}
```
This change ensures that data for each week is fetched only once per session, making the `weeklyDataMap` an effective cache.

## 🧪 Test Suggestions

Based on the file names, a new "Wisdom Garden" feature is being added, which involves tracking weekly user progress, visualizing it as a tree, and syncing data with a network while also persisting it locally.

Here are 3 critical, edge-case test cases to add/verify:

*   **First launch with network failure:** Simulate a user opening the app for the very first time (no cached or persisted data exists) but the initial network request to fetch the "Wisdom Garden" data fails. The application should handle this gracefully by displaying a user-friendly error message and a retry option, rather than crashing or showing a blank, unresponsive screen.

*   **Offline progress and data synchronization:** Test the scenario where a user is offline, completes several practices for the week (which should be saved locally by `PersistenceService`), and then closes the app. When the user re-opens the app with a stable internet connection, verify that their offline progress is successfully synced and not overwritten by the fresh data fetched from the network.

*   **Data boundaries for the tree visualization:** Verify the state of the `WisdomTreeVisualizationView` at its boundaries. This includes testing a brand new user with zero completed practices (the tree should be in its initial state, e.g., a seed or tiny sprout) and a user who has completed 100% of the practices for a given week (the tree should be in its fully grown state for that period). This ensures the visualization correctly reflects the user's progress at the minimum and maximum extremes.

