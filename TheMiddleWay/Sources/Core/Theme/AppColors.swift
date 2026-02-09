import SwiftUI

/// The Middle Way - Warm Modern Sanctuary Color Palette
/// Matching the Web and Android design system
enum AppColors {
    // MARK: - Primary Palette
    
    /// Ivory - Background color
    /// Hex: #FCF9F6
    static let background = Color(red: 252/255, green: 249/255, blue: 246/255)
    
    /// Sage Green - Primary accent color
    /// Hex: #8B9D83
    static let primary = Color(red: 139/255, green: 157/255, blue: 131/255)
    
    /// Soft Sand - Surface/Cards color
    /// Hex: #F3F0ED
    static let surface = Color(red: 243/255, green: 240/255, blue: 237/255)
    
    /// Deep Slate - Primary text color
    /// Hex: #2D3748
    static let textPrimary = Color(red: 45/255, green: 55/255, blue: 72/255)
    
    // MARK: - Extended Palette
    
    /// Secondary text color (lighter)
    static let textSecondary = Color(red: 113/255, green: 128/255, blue: 150/255)
    
    /// Border/Divider color
    static let border = Color(red: 226/255, green: 232/255, blue: 240/255)
    
    /// Success color
    static let success = Color(red: 72/255, green: 187/255, blue: 120/255)
    
    /// Warning color
    static let warning = Color(red: 237/255, green: 137/255, blue: 54/255)
    
    /// Error color
    static let error = Color(red: 245/255, green: 101/255, blue: 101/255)
}

// MARK: - Color Extension for Hex Support

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
