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
│   │   │   └── AppTypography.swift
│   │   └── Navigation/
│   └── Features/               # Feature modules
│       └── Home/
│           └── HomeView.swift
└── Resources/
    └── Assets.xcassets/
```

## Design System

**Warm Modern Sanctuary** palette (matching Web & Android):

| Token | Color | Usage |
|-------|-------|-------|
| Ivory | `#FCF9F6` | Background |
| Sage | `#8B9D83` | Primary Accent |
| Slate | `#2D3748` | Text |
| Sand | `#F3F0ED` | Surface/Cards |

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
