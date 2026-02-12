
import Foundation

// MARK: - Practice Item
struct PracticeItem: Identifiable, Codable {
    let id: String
    let title: String
    let points: Int
    var isCompleted: Bool
    
    // For i18n support later (simplified for now as per Android/Web implementation)
}

// MARK: - Practice Category (`group` of items)
struct PracticeCategory: Identifiable, Codable {
    let id: String
    let title: String
    var items: [PracticeItem]
}

// MARK: - Weekly Data (`root` object for a week)
struct WeeklyData: Identifiable, Codable {
    var id: Int { weekNumber } // Use weekNumber as ID for Identifiable
    let weekNumber: Int
    var categories: [PracticeCategory]
    
    // Computed max score
    var maxScore: Int {
        categories.flatMap { $0.items }.reduce(0) { $0 + $1.points }
    }
    
    // Computed current score
    var currentScore: Int {
        categories.flatMap { $0.items }.filter { $0.isCompleted }.reduce(0) { $0 + $1.points }
    }
}
