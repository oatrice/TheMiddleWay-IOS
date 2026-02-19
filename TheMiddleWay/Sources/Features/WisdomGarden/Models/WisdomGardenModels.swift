
import Foundation

// MARK: - Practice Item
struct PracticeItem: Identifiable, Codable {
    var id: String
    var title: String
    var points: Int
    var isCompleted: Bool
    
    // For i18n support later (simplified for now as per Android/Web implementation)
}

// MARK: - Practice Category (`group` of items)
struct PracticeCategory: Identifiable, Codable {
    var id: String
    var title: String
    var items: [PracticeItem]
}

// MARK: - Weekly Data (`root` object for a week)
struct WeeklyData: Identifiable, Codable {
    var id: Int { weekNumber } // Use weekNumber as ID for Identifiable
    var weekNumber: Int
    var categories: [PracticeCategory]
    
    // Computed max score (can be updated from server or computed locally)
    var maxScore: Int
    
    // Computed current score
    var currentScore: Int
    
    // CodingKeys if needed, but names match JSON
}
