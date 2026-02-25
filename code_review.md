# Luma Code Review Report

**Date:** 2026-02-19 16:43:44
**Files Reviewed:** ['TheMiddleWay/Sources/App/TheMiddleWayApp.swift', 'TheMiddleWay/Sources/Features/Profile/Views/ProfileView.swift', 'TheMiddleWay/Sources/Core/Auth/AuthService.swift', 'TheMiddleWay/Sources/Features/WisdomGarden/Data/WisdomGardenRepositoryProtocol.swift', 'TheMiddleWay/Sources/Features/Settings/Views/DevSettingsView.swift', 'TheMiddleWay/Sources/Features/WisdomGarden/Models/WisdomGardenModels.swift', 'TheMiddleWay.xcodeproj/project.pbxproj', 'TheMiddleWay.xcodeproj/xcshareddata/xcschemes/TheMiddleWay.xcscheme', 'TheMiddleWay/Sources/Features/WisdomGarden/ViewModels/WisdomGardenViewModel.swift', 'TheMiddleWay/Sources/Features/Home/HomeView.swift', 'TheMiddleWay/Sources/App/ContentView.swift', 'TheMiddleWay/Sources/Features/WisdomGarden/Data/FirestoreWisdomGardenRepository.swift', 'TheMiddleWay/Sources/Features/WisdomGarden/Data/WisdomGardenData.swift', 'TheMiddleWay/Sources/Features/Settings/DevSettingsViewModel.swift', 'TheMiddleWay/Info.plist', 'TheMiddleWay/GoogleService-Info.plist', 'TheMiddleWay/Sources/Features/WisdomGarden/Data/NetworkWisdomGardenRepository.swift']

## 📝 Reviewer Feedback

There are several issues in the provided code, ranging from critical logic bugs to security best practices.

### 1. Critical Logic Bug: Incorrect Item ID Parsing in Firestore Repository

**File:** `TheMiddleWay/Sources/Features/WisdomGarden/Data/FirestoreWisdomGardenRepository.swift`

**Problem:**
The `togglePractice` function relies on `extractWeekFromID` to parse the week number from a practice item's ID. However, the ID generation logic in `fetchMasterAndCreateUserData` creates IDs that the parsing function cannot handle.

- **ID Generation:** An ID is created like `"u-\(userId)-\(item.id)"`, resulting in a string such as `"u-some-uid-w1_i1"`.
- **ID Parsing:** The `extractWeekFromID` function splits the ID by `-` and looks for a component that is exactly `"w"`, or tries to parse a component like `"w1"` into an integer. Neither of these conditions will match `"w1_i1"`, causing `Int("1_i1")` to fail and the function to return `nil`.

This bug breaks the "toggle practice" functionality when using Firestore, as it will be unable to locate the correct weekly document to update.

**Fix:**
Align the ID generation with the parser's expectation. The parser is designed to find a `w` component followed by the week number. Modify the ID generation in `fetchMasterAndCreateUserData` to create this structure.

```swift
// In TheMiddleWay/Sources/Features/WisdomGarden/Data/FirestoreWisdomGardenRepository.swift
// Inside the fetchMasterAndCreateUserData function:

// ...
var newCategories: [PracticeCategory] = []
for var cat in masterData.categories {
    // Add the week to the ID to make it parsable
    cat.id = "u-\(userId)-w-\(week)-\(cat.id)" 

    var newItems: [PracticeItem] = []
    for var item in cat.items {
        // Add the week to the ID to make it parsable
        item.id = "u-\(userId)-w-\(week)-\(item.id)" 
        item.isCompleted = false
        newItems.append(item)
    }
    cat.items = newItems
    newCategories.append(cat)
}
masterData.categories = newCategories
// ...
```
This will generate IDs like `u-some-uid-w-1-w1_i1`, which the existing `extractWeekFromID` function can correctly parse to find the week number `1`.

---

### 2. Major Error Handling Flaw: Swallowing Network Errors

**File:** `TheMiddleWay/Sources/Features/WisdomGarden/Data/NetworkWisdomGardenRepository.swift`

**Problem:**
In the `getWeeklyData` function, the `catch` block for the network request does not propagate the error. Instead, it catches the error, prints a message, and returns static fallback data. This is a poor practice because:
- It hides network or server failures from the rest of the app.
- The user is shown incorrect, mock data without any indication that something went wrong.
- The ViewModel cannot implement proper error handling (like showing an alert or a retry button) because it never receives an error.

**Fix:**
The function is declared as `throws`, so it should throw the error instead of returning fallback data. Let the caller (the ViewModel) decide how to handle the failure.

```swift
// In TheMiddleWay/Sources/Features/WisdomGarden/Data/NetworkWisdomGardenRepository.swift
// Inside the getWeeklyData function:

// ...
} catch {
    print("❌ [Net] Fetch Week Failed: \(error).")
    // Do not return fallback data. Let the error propagate to the caller.
    throw error
}
// ...
```

---

### 3. Security Risk: Hardcoded Secrets in Version Control

**Files:**
- `TheMiddleWay/GoogleService-Info.plist`
- `TheMiddleWay/Info.plist`

**Problem:**
These files contain sensitive information, such as the Firebase `API_KEY` and Google `CLIENT_ID`. Committing these secrets directly into a version control system (like Git) is a major security risk. If the repository is ever made public or compromised, these keys can be abused.

**Fix:**
The standard practice is to use Xcode Configuration files (`.xcconfig`) to manage secrets.
1.  Create `.xcconfig` files for different environments (e.g., `Debug.xcconfig`, `Release.xcconfig`).
2.  Store the secret keys in these files (e.g., `GOOGLE_API_KEY = "AIzaSy..."`).
3.  Add the `.xcconfig` files to your `.gitignore` file to prevent them from being committed.
4.  Provide a template file (e.g., `Config.template.xcconfig`) in the repository with placeholder values so other developers know what keys are needed.
5.  Access these values from your `Info.plist` using variable substitution (e.g., `$(GOOGLE_API_KEY)`).

## 🧪 Test Suggestions

*   **Authenticated user with missing profile data:** Verify the UI's appearance when a user is successfully authenticated (`authService.currentUser` is not nil), but their `displayName`, `email`, and `photoURL` are all `nil`. The view should gracefully fall back to displaying the "person.circle.fill" placeholder image, the default name "User", and an empty string for the email without any layout issues.
*   **Invalid or broken user photo URL:** Test the scenario where the `user.photoURL` exists and is a validly formatted URL, but it points to an image that fails to load (e.g., a 404 error or a corrupted file). The `AsyncImage`'s placeholder (the "person.circle.fill" icon) should be displayed instead of an empty space or a broken image icon.
*   **State transition on sign-out:** While the `ProfileView` is on screen, trigger the `authService.signOut()` function. The view must react immediately by removing the user's information (name, email, photo) and correctly displaying the logged-out state (e.g., a sign-in prompt, which is implied by the `if let user` block).

