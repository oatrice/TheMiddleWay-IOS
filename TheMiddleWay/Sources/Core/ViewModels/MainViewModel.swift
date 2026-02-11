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
    
    private func reloadProgress() {
        if let progress = persistenceService.loadProgress() {
            // Ensure UI updates happen on the main thread
            DispatchQueue.main.async {
                self.userProgress = progress
            }
        }
    }
    
    func completeLesson(_ lessonId: String) {
        let updated = persistenceService.updateProgress { progress in
            if !progress.completedLessons.contains(lessonId) {
                progress.completedLessons.append(lessonId)
                progress.lastVisited = Date()
            }
        }
        if updated {
            reloadProgress()
        }
    }
    
    func toggleTheme(isDark: Bool) {
        let updated = persistenceService.updateProgress { progress in
            progress.themeMode = isDark ? .dark : .light
        }
        if updated {
            reloadProgress()
        }
    }
    
    func resetProgress() {
        if persistenceService.clearProgress() {
            // After clearing, the new default state needs to be set
            DispatchQueue.main.async {
                self.userProgress = UserProgress.defaultProgress
            }
        }
    }
}
