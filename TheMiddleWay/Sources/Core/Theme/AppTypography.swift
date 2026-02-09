import SwiftUI

/// The Middle Way - Typography System
/// Matching the Web design system with Playfair Display (headings) and Inter (body)
enum AppTypography {
    // MARK: - Headings (Serif style - like Playfair Display)
    
    /// Large title - 34pt Bold Serif
    static let largeTitle = Font.system(size: 34, weight: .bold, design: .serif)
    
    /// Title 1 - 28pt Bold Serif
    static let title1 = Font.system(size: 28, weight: .bold, design: .serif)
    
    /// Title 2 - 22pt Semibold Serif
    static let title2 = Font.system(size: 22, weight: .semibold, design: .serif)
    
    /// Title 3 - 20pt Semibold Serif
    static let title3 = Font.system(size: 20, weight: .semibold, design: .serif)
    
    /// Heading - Default heading style
    static let heading = Font.system(size: 24, weight: .bold, design: .serif)
    
    // MARK: - Body Text (Sans-serif style - like Inter)
    
    /// Body Large - 17pt Regular
    static let bodyLarge = Font.system(size: 17, weight: .regular, design: .default)
    
    /// Body - Standard body text - 15pt Regular
    static let body = Font.system(size: 15, weight: .regular, design: .default)
    
    /// Body Small - 13pt Regular
    static let bodySmall = Font.system(size: 13, weight: .regular, design: .default)
    
    // MARK: - UI Elements
    
    /// Button text - 16pt Semibold
    static let button = Font.system(size: 16, weight: .semibold, design: .default)
    
    /// Caption - 12pt Regular
    static let caption = Font.system(size: 12, weight: .regular, design: .default)
    
    /// Label - 14pt Medium
    static let label = Font.system(size: 14, weight: .medium, design: .default)
}

// MARK: - View Extension for Typography

extension View {
    func headingStyle() -> some View {
        self
            .font(AppTypography.heading)
            .foregroundStyle(AppColors.textPrimary)
    }
    
    func bodyStyle() -> some View {
        self
            .font(AppTypography.body)
            .foregroundStyle(AppColors.textPrimary)
    }
    
    func captionStyle() -> some View {
        self
            .font(AppTypography.caption)
            .foregroundStyle(AppColors.textSecondary)
    }
}
