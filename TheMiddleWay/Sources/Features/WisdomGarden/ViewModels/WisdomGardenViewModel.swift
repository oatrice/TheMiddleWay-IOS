import Foundation
import SwiftUI
import Combine

class WisdomGardenViewModel: ObservableObject {
    // MARK: - Published State
    @Published var selectedWeek: Int = 1
    @Published var weeklyDataMap: [Int: WeeklyData] = [:] // Map for easy access/updates
    
    // MARK: - Computed Properties
    var currentWeekData: WeeklyData? {
        weeklyDataMap[selectedWeek]
    }
    
    var currentScore: Int {
        currentWeekData?.currentScore ?? 0
    }
    
    var maxScore: Int {
        currentWeekData?.maxScore ?? 1
    }
    
    private var repository: WisdomGardenRepository
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init() {
        // Default to current setting
        let useApi = DevSettingsViewModel.shared.useApiMode
        self.repository = useApi ? NetworkWisdomGardenRepository() : FirestoreWisdomGardenRepository()
        
        // Subscribe to setting changes
        DevSettingsViewModel.shared.objectWillChange
            .sink { [weak self] _ in
                // Delay slightly to let AppStorage update? Or just read it?
                // Better to just assume if Settings changed, we refresh.
                // But AppStorage update might happen after objectWillChange.
                DispatchQueue.main.async {
                    self?.updateRepository()
                }
            }
            .store(in: &cancellables)
            
        // Load initial data
        Task {
            await loadWeeklyData(for: selectedWeek)
        }
    }
    
    private func updateRepository() {
        let useApi = DevSettingsViewModel.shared.useApiMode
        print("🔄 [VM] Switching Repository. API Mode: \(useApi)")
        self.repository = useApi ? NetworkWisdomGardenRepository() : FirestoreWisdomGardenRepository()
        Task {
            await loadWeeklyData(for: selectedWeek, forceRefresh: true)
        }
    }
    
    @MainActor
    func loadWeeklyData(for week: Int, forceRefresh: Bool = false) async {
        // Return if data for the selected week is already cached and we're not forcing a refresh.
        if !forceRefresh && weeklyDataMap[week] != nil {
            return
        }

        do {
            let data = try await repository.getWeeklyData(week: week)
            weeklyDataMap[week] = data
        } catch {
            print("❌ [VM] Error fetching data for week \(week): \(error)")
        }
    }
    
    // MARK: - User Actions
    
    func selectWeek(_ week: Int) {
        guard week >= 1 && week <= 8 else { return }
        selectedWeek = week
        
        Task {
            await loadWeeklyData(for: week)
        }
    }
    
    func toggleItem(itemId: String) {
        guard var currentData = weeklyDataMap[selectedWeek] else { return }
        
        // Optimistic Update
        for (catIndex, category) in currentData.categories.enumerated() {
            if let itemIndex = category.items.firstIndex(where: { $0.id == itemId }) {
                // Toggle completion
                var item = currentData.categories[catIndex].items[itemIndex]
                item.isCompleted.toggle()
                currentData.categories[catIndex].items[itemIndex] = item
                
                // Recalculate score locally for UI (handled by computed property in Model)
                // let newScore = currentData.categories.flatMap { $0.items }.filter { $0.isCompleted }.reduce(0) { $0 + $1.points }
                // currentData.currentScore = newScore
                
                // Update the source of truth locally
                weeklyDataMap[selectedWeek] = currentData
                
                // Network Call
                Task {
                    do {
                        try await repository.togglePractice(id: itemId, isCompleted: item.isCompleted)
                        // Success: Keep optimistic state
                    } catch {
                        print("Error toggling item: \(error)")
                        // Revert on failure (reload data)
                        await loadWeeklyData(for: selectedWeek, forceRefresh: true)
                    }
                }
                return 
            }
        }
    }
}
