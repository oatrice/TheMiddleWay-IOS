# Changelog

## [0.7.0] - 2026-02-27

### Added
- **User Authentication:** You can now create an account and sign in using your Google account. This lays the foundation for personalized progress tracking.
- **Sign-Out Confirmation:** A confirmation prompt now appears before signing out to prevent accidental logouts.
- **Improved Feedback:** A loading indicator is now shown during the sign-in process, and better error messages are displayed in the Wisdom Garden if data fails to load.
- **Developer Settings:** (Internal) Added a new developer settings screen with an API environment selector for easier testing.

### Changed
- **Backend Connection:** The app is now connected to the live production server, moving away from local test data.

### Fixed
- **Wisdom Garden Data:** Corrected an issue that caused errors when parsing weekly practice data.

### Removed
- **Local Score Tracking:** Removed the temporary, on-device score tracking system to make way for a future server-synchronized version.

## [0.6.0] - 2026-02-12

### Added
- **New User Onboarding:** A brand new, multi-screen onboarding flow has been introduced to welcome users. It guides you through the core concepts of the app: Welcome, Wisdom, Practice, and The Path.
- **Read-Only Interaction Feedback:** When trying to interact with a locked practice in the Wisdom Garden, a helpful toast notification now appears to explain that it's in read-only mode.

### Changed
- **Improved Network Layer:** The underlying networking code has been refactored for better testability and stability, ensuring a more reliable data-fetching experience.

### Removed
- **Legacy Code:** Removed several unused theme, color, and persistence service files to streamline the codebase.

## [0.5.0] - 2026-02-12

### Added
- **Interactive Week Navigation:** You can now tap on the week selector in the Wisdom Garden to easily navigate and view practices from different weeks.
- **Read-Only Practice View:** Past and future weeks' practice checklists are now displayed in a read-only mode, preventing accidental changes while allowing you to review your journey.
- **Scoring & Network Foundation:** Added the underlying data structures for practice scoring and a network repository to prepare for future server-side integration.

### Changed
- **Improved Layout:** The "Enter Practice Room" button in the Wisdom Garden has been moved above the checklist for better visibility and easier access.

## [0.4.0] - 2026-02-12

### Added
- **Wisdom Garden Feature (Codebase):** Implemented the core components for the Wisdom Garden Dashboard.
  - **Models:** defined `PracticeItem`, `PracticeCategory`, and `WeeklyData` structures.
  - **Data:** Created `WisdomGardenData` with 8 weeks of initial mock data.
  - **ViewModel:** Implemented `WisdomGardenViewModel` logic for week selection and practice tracking.
  - **Views:** Built `WisdomGardenView` along with `WeekSelectorView`, `WisdomTreeVisualizationView`, and `PracticeChecklistView`.
  *(Note: Files are created in `Sources/Features/WisdomGarden` but require manual addition to the Xcode project references).*

### Fixed
- **CI/CD Workflow:** Enhanced `auto-tag.yml` to correctly strip double quotes from `MARKETING_VERSION` and strictly validate project file uniqueness.

### Changed
- Internal improvements to the continuous integration (CI) workflow for more reliable automated version tagging.

## [0.3.1] - 2026-02-11

### Changed
- Internal improvements to the continuous integration (CI) workflow for automated version tagging.

## [0.3.0] - 2026-02-11

### Added
- **User Progress Tracking:** The app now automatically saves your progress, allowing you to pick up where you left off in your journey.

### Changed
- Refactored the internal theme management system for improved performance and stability.

### Fixed
- Removed a redundant background from the navigation toolbar for a cleaner user interface.

## [0.2.0] - 2026-02-10

### Added
- **Dark Mode Support:** Introduced "Deep Cosmos" dark theme alongside the existing "Bright Sky" light theme.
- **Theme Persistence:** App remembers the user's theme preference using `@AppStorage`.
- **Theme Toggle:** Sun/Moon icon in the home screen toolbar for easy switching.
- **Dynamic Colors:** Updated `AppColors` to support adaptive colors that change based on the selected theme.

### Changed
- Refactored `AppTheme.swift` to apply navigation bar modifiers correctly to the content view.
- Updated project version to 0.2.0 to sync with Android and Web platforms.
