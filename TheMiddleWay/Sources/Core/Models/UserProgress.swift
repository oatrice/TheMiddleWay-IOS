import Foundation

struct UserProgress: Codable, Equatable {
    var version: Int = 1
    var themeMode: ThemeMode = .light
    var language: Language = .thai
    var completedLessons: [String] = []
    var bookmarks: [String] = []
    var lastVisited: Date?
    
    // Default values
    static let defaultProgress = UserProgress()
}

enum ThemeMode: String, Codable {
    case light
    case dark
}

enum Language: String, Codable {
    case thai = "th"
    case english = "en"
}
