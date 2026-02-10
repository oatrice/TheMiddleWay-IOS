# The Middle Way - iOS

iOS platform for The Middle Way application, built with SwiftUI.

## Requirements

- iOS 17.0+
- Xcode 16.0+
- Swift 5.9+

## Project Structure

```
TheMiddleWay/
├── Sources/
│   ├── App/                    # App entry point
│   │   ├── TheMiddleWayApp.swift
│   │   └── ContentView.swift
│   ├── Core/                   # Shared utilities
│   │   ├── Theme/
│   │   │   ├── AppColors.swift
│   │   │   ├── AppTheme.swift
│   │   │   ├── AppTypography.swift
│   │   │   └── ThemeConfig.swift
│   │   └── Navigation/
│   └── Features/               # Feature modules
│       └── Home/
│           └── HomeView.swift
└── Resources/
    └── Assets.xcassets/
```

## Design System

**Bright Sky blue** palette:

The UI is built around a custom `AppTheme` supporting a "Bright Sky blue" light mode and a persistent dark mode.

**Typography:**
- Headings: System Serif (like Playfair Display)
- Body: System Sans (like Inter)

## Getting Started

1. Open `TheMiddleWay.xcodeproj` in Xcode
2. Select a simulator or device
3. Press `Cmd + R` to build and run

## Architecture

- **MVVM** pattern with SwiftUI
- **NavigationStack** for navigation
- **TabView** for main navigation

## Documentation

Project-wide documentation lives in the [metadata repository](https://github.com/oatrice/TheMiddleWay-Metadata).