import SwiftUI
import Combine

class MainViewModel: ObservableObject {
    @Published var userProgress: UserProgress
    private let persistenceService: PersistenceService
    
    init(service: PersistenceService = PersistenceServiceImpl()) {
        self.persistenceService = service
        // Load existing progress or default
        self.userProgress = service.loadProgress() ?? UserProgress.defaultProgress
    }
    
    func completeLesson(_ lessonId: String) {
        var current = userProgress
        if !current.completedLessons.contains(lessonId) {
            current.completedLessons.append(lessonId)
            current.lastVisited = Date()
            
            if persistenceService.saveProgress(current) {
                userProgress = current
            }
        }
    }
    
    func toggleTheme(isDark: Bool) {
        var current = userProgress
        // Assuming userProgress has themeMode property
        current.themeMode = isDark ? .dark : .light
        if persistenceService.saveProgress(current) {
            userProgress = current
        }
    }
    
    func resetProgress() {
        if persistenceService.clearProgress() {
            userProgress = UserProgress.defaultProgress
        }
    }
}
