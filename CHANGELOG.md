# Changelog

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
