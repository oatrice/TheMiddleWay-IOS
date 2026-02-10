import SwiftUI
import UIKit

/// The Middle Way - Adaptive Color Palette
/// Light: Bright Sky (ฟ้าสดใส)
/// Dark: Deep Cosmos (matching Web/Android design system)
enum AppColors {
    // MARK: - Light Palette — Bright Sky
    
    enum Light {
        static let background = Color(hex: "#EFF6FF")   // Sky White
        static let primary = Color(hex: "#2563EB")       // Bright Blue
        static let surface = Color(hex: "#DBEAFE")       // Sky Surface
        static let textPrimary = Color(hex: "#1E3A5F")   // Deep Blue
        static let textSecondary = Color(hex: "#64748B")  // Blue Gray
        static let border = Color(hex: "#BFDBFE")         // Sky Border
        static let success = Color(hex: "#10B981")
        static let warning = Color(hex: "#F59E0B")
        static let error = Color(hex: "#EF4444")
    }
    
    // MARK: - Dark Palette
    
    enum Dark {
        static let background = Color(hex: "#0A192F") // Navy
        static let primary = Color(hex: "#F59E0B") // Amber
        static let surface = Color(hex: "#1E293B") // Slate Dark
        static let textPrimary = Color(hex: "#F8FAFC") // Ivory
        static let textSecondary = Color(hex: "#94A3B8") // Slate Light
        static let border = Color(hex: "#334155")
        static let success = Color(hex: "#10B981")
        static let warning = Color(hex: "#F59E0B")
        static let error = Color(hex: "#EF4444")
    }
    
    // MARK: - Dynamic Tokens
    
    static let background = Color.dynamic(light: Light.background, dark: Dark.background)
    static let primary = Color.dynamic(light: Light.primary, dark: Dark.primary)
    static let surface = Color.dynamic(light: Light.surface, dark: Dark.surface)
    static let textPrimary = Color.dynamic(light: Light.textPrimary, dark: Dark.textPrimary)
    static let textSecondary = Color.dynamic(light: Light.textSecondary, dark: Dark.textSecondary)
    static let border = Color.dynamic(light: Light.border, dark: Dark.border)
    static let success = Color.dynamic(light: Light.success, dark: Dark.success)
    static let warning = Color.dynamic(light: Light.warning, dark: Dark.warning)
    static let error = Color.dynamic(light: Light.error, dark: Dark.error)
}

// MARK: - Color Extensions

extension Color {
    static func dynamic(light: Color, dark: Color) -> Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }
    
    init(hex: String) {
        self.init(UIColor(hex: hex))
    }
}

extension UIColor {
    convenience init(hex: String) {
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
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
}
