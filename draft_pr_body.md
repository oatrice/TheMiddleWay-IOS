This PR implements the foundational user authentication system using Firebase and Google Sign-In, addressing the core requirements of the user membership and data synchronization feature. It allows users to sign in to their accounts, paving the way for cloud-based progress tracking and cross-device sync.

Closes [https://github.com/owner/repo/issues/14](https://github.com/owner/repo/issues/14)

---

### 📝 Summary

This PR introduces a complete authentication flow for the iOS application. Users can now sign in using their Google account. A new, dynamic Profile screen has been created to manage user sessions, displaying user information when logged in and providing a clear call-to-action for guests.

The primary goal is to move user progress from being stored solely on the device (`LocalStorage`) to being securely saved in the cloud, associated with a user account. This prevents data loss and is the first step towards future features like premium memberships.

### ✨ What's New?

-   **Firebase & Google Sign-In Integration:**
    -   Integrated the Firebase Authentication and Google Sign-In SDKs.
    -   Created a singleton `AuthService` to manage the entire authentication lifecycle (sign-in, sign-out, state changes, and token management).
    -   Configured the app to initialize Firebase and correctly handle the Google Sign-In URL callback.

-   **👤 Revamped Profile UI:**
    -   A new `ProfileView` has been created, accessible from a new profile icon on the `HomeView` toolbar.
    -   The view intelligently displays different states:
        -   **Guest State:** Prompts the user to sign in to sync their progress.
        -   **Loading State:** Shows an activity indicator during the sign-in process.
        -   **Authenticated State:** Displays the user's profile picture, display name, and email.
    -   Includes a "Sign Out" button with a confirmation alert to prevent accidental logouts.

-   **🔐 Authenticated API Requests:**
    -   The `NetworkWisdomGardenRepository` has been updated to be auth-aware.
    -   For authenticated users, it now automatically attaches the Firebase ID token as a `Bearer` token to the `Authorization` header of API requests, ensuring secure communication with the backend.

-   **🛠️ Developer & Security Enhancements:**
    -   Implemented a secrets management system using a gitignored `Secrets.swift` file to avoid committing sensitive API keys to the repository.
    -   Added a new "Developer Settings" screen to easily switch between API environments (Production, Localhost, Custom), streamlining development and testing.

### 🎥 Screenshots

| Guest View                                                              | Authenticated View                                                      | Sign Out Confirmation                                     |
| ----------------------------------------------------------------------- | ----------------------------------------------------------------------- | --------------------------------------------------------- |
| <img src="https://i.imgur.com/your-guest-view-image.png" width="250">    | <img src="https://i.imgur.com/your-auth-view-image.png" width="250">      | <img src="https://i.imgur.com/your-alert-image.png" width="250"> |

*(Please replace with actual screenshots)*

### ✅ Task Checklist

-   [x] Support Social Login with **Google**.
-   [ ] Support Social Login with **Apple ID** *(To be addressed in a future PR)*.
-   [ ] Support **Magic Link** login *(To be addressed in a future PR)*.
-   [x] Create a Login/Sign-up UI (`ProfileView` for guest users).
-   [x] Create a Profile page with user info and a Log out button.
-   [ ] Create data migration logic from `LocalStorage` to the database *(This PR sets the client-side foundation; the sync logic will be a follow-up task)*.
-   [x] Secure API endpoints with authentication tokens.