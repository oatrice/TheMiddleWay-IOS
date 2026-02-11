import SwiftUI

enum ThemeConfig {
    static let storageKey = "isDarkMode"

    static func colorScheme(isDarkMode: Bool) -> ColorScheme {
        isDarkMode ? .dark : .light
    }

    static func toggleIconName(isDarkMode: Bool) -> String {
        isDarkMode ? "sun.max.fill" : "moon.fill"
    }

    static func toggleLabel(isDarkMode: Bool) -> String {
        isDarkMode ? "Switch to Light Mode" : "Switch to Dark Mode"
    }
}
