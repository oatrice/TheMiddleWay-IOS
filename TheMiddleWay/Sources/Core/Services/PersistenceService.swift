import Foundation

protocol PersistenceService {
    func saveProgress(_ progress: UserProgress) -> Bool
    func loadProgress() -> UserProgress?
    func clearProgress() -> Bool
    func updateProgress(_ update: (inout UserProgress) -> Void) -> Bool
}

class PersistenceServiceImpl: PersistenceService {
    
    private let userDefaults: UserDefaults
    private let key = "theMiddleWay.progress"
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func saveProgress(_ progress: UserProgress) -> Bool {
        do {
            let data = try JSONEncoder().encode(progress)
            userDefaults.set(data, forKey: key)
            return true
        } catch {
            print("Error saving progress: \(error)")
            return false
        }
    }
    
    func loadProgress() -> UserProgress? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        
        do {
            let progress = try JSONDecoder().decode(UserProgress.self, from: data)
            return progress
        } catch {
            print("Error loading progress: \(error)")
            return nil
        }
    }
    
    func clearProgress() -> Bool {
        userDefaults.removeObject(forKey: key)
        return true
    }
    
    func updateProgress(_ update: (inout UserProgress) -> Void) -> Bool {
        var current = loadProgress() ?? UserProgress.defaultProgress
        update(&current)
        return saveProgress(current)
    }
}
