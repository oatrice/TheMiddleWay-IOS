# Luma Code Review Report

**Date:** 2026-02-27 17:09:09
**Files Reviewed:** ['TheMiddleWay/Sources/Features/WisdomGarden/Data/WisdomGardenRepositoryProtocol.swift', 'TheMiddleWay/Info.plist', 'TheMiddleWay.xcodeproj/xcshareddata/xcschemes/TheMiddleWay.xcscheme', 'TheMiddleWay/Sources/Features/WisdomGarden/Data/NetworkWisdomGardenRepository.swift', 'TheMiddleWay/Sources/Features/WisdomGarden/ViewModels/WisdomGardenViewModel.swift', 'TheMiddleWay/Sources/Features/WisdomGarden/Models/WisdomGardenModels.swift', 'TheMiddleWay/Sources/Config/.swift', 'TheMiddleWay/Sources/Features/Settings/Views/DevSettingsView.swift', 'TheMiddleWay/GoogleService-Info.plist', 'TheMiddleWay/Sources/Features/Home/HomeView.swift', 'TheMiddleWay/Sources/App/ContentView.swift', 'TheMiddleWay/Sources/Features/Profile/Views/ProfileView.swift', 'code_review.md', 'TheMiddleWay/Sources/App/TheMiddleWayApp.swift', 'TheMiddleWay.xcodeproj/project.pbxproj', '.gitignore', 'TheMiddleWay/Sources/Features/WisdomGarden/Data/WisdomGardenData.swift', 'TheMiddleWay/Sources/Features/Settings/DevSettingsViewModel.swift', 'TheMiddleWay/Sources/Core/Auth/AuthService.swift']

## 📝 Reviewer Feedback

There are several issues in the provided code, ranging from a critical security risk to poor error handling that will negatively impact the user experience.

### 1. Critical Security Risk: Hardcoded Secrets in Version Control

**Files:**
- `TheMiddleWay/GoogleService-Info.plist`
- `TheMiddleWay/Info.plist`

**Problem:**
These files contain sensitive information, such as the Firebase `API_KEY` and Google `CLIENT_ID`. Committing these secrets directly into a version control system (like Git) is a major security risk. If the repository is ever made public or compromised, these keys can be abused. The provided `code_review.md` file indicates this was an issue in a previous review and it has not been addressed.

**Fix:**
Secrets should be removed from version control. The standard practice is to use Xcode Configuration files (`.xcconfig`) to manage them.

1.  Create `.xcconfig` files for your environments (e.g., `Debug.xcconfig`, `Release.xcconfig`).
2.  Store the secret keys in these files (e.g., `GOOGLE_API_KEY = "AIzaSy..."`).
3.  Add the `.xcconfig` files to your `.gitignore` file. The project's `.gitignore` is already configured to ignore `Secrets.xcconfig`, which is a good start.
4.  Create a template file (e.g., `Config.template.xcconfig`) in the repository with placeholder values so other developers know which keys are needed.
5.  Access these values from your `Info.plist` using variable substitution (e.g., `$(GOOGLE_API_KEY)`).
6.  For the `GoogleService-Info.plist` file, you can either use a script to generate it at build time from the xcconfig values or have multiple versions of the file (e.g., `GoogleService-Info-Debug.plist`) and use a build script to copy the correct one. The file itself should be added to `.gitignore`.

---

### 2. Major Error Handling Flaw: Swallowing Errors in ViewModel

**File:** `TheMiddleWay/Sources/Features/WisdomGarden/ViewModels/WisdomGardenViewModel.swift`

**Problem:**
In the `loadWeeklyData` function, network errors from the repository are caught, printed to the console, and then discarded. This prevents the UI from ever knowing that a network request failed. The user will be left with a stale, empty, or incomplete view with no feedback on what went wrong or how to fix it.

```swift
// Problematic code in loadWeeklyData()
do {
    let data = try await repository.getWeeklyData(week: week)
    weeklyDataMap[week] = data
} catch {
    // Error is printed but the UI is not notified.
    print("❌ [VM] Error fetching data for week \(week): \(error)")
}
```

**Fix:**
The ViewModel should expose the error state to the View. Add a `@Published` property to hold the error information. The View can then observe this property and display an appropriate error message or a retry button.

```swift
// In WisdomGardenViewModel.swift

class WisdomGardenViewModel: ObservableObject {
    // ...
    @Published var weeklyDataMap: [Int: WeeklyData] = [:]
    @Published var errorMessage: String? // Add a property for error state
    
    // ...
    
    @MainActor
    func loadWeeklyData(for week: Int, forceRefresh: Bool = false) async {
        if !forceRefresh && weeklyDataMap[week] != nil {
            return
        }
        
        errorMessage = nil // Clear previous error on new load attempt

        do {
            let data = try await repository.getWeeklyData(week: week)
            weeklyDataMap[week] = data
        } catch {
            print("❌ [VM] Error fetching data for week \(week): \(error)")
            errorMessage = "Failed to load practices. Please check your connection and try again." // Set the error message
        }
    }
    // ...
}
```
The corresponding SwiftUI view should then be updated to display the `errorMessage` when it is not `nil`.

---

### 3. Minor Issue: Unconventional File Naming

**File:** `TheMiddleWay/Sources/Config/.swift`

**Problem:**
A file is named `.swift`, which is highly unconventional. This is likely intended to be a template for the `Secrets.swift` file (which is correctly gitignored), but the name is confusing and could be overlooked or mishandled by development tools.

**Fix:**
Rename the file to be more descriptive of its purpose, such as `Secrets.swift.template`.

## 🧪 Test Suggestions

*   **Test `getWeeklyData` with a non-existent week number:** Verify that calling `getWeeklyData(week: 0)`, `getWeeklyData(week: -1)`, or a very large number that has no data (e.g., `getWeeklyData(week: 999)`) throws a specific "not found" error or returns an empty state, ensuring the app doesn't crash and handles empty/error states gracefully.
*   **Test `togglePractice` with an invalid or non-existent ID:** Attempt to call `togglePractice` with a UUID or string that does not correspond to any existing practice item. The function should throw an appropriate error (e.g., `itemNotFound`), and the application's state should not change.
*   **Test `togglePractice` failure due to network error:** Simulate a network failure when calling `togglePractice`. The test should verify that the function throws a network-related error and that any optimistic UI update (e.g., a checked box) is reverted to its original state, preventing a mismatch between the UI and the backend.

