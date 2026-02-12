
import Foundation
import SwiftUI

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
    
    // MARK: - Initialization
    init() {
        loadInitialData()
    }
    
    private func loadInitialData() {
        // Load mock data into the map
        for data in WisdomGardenData.weeklyData {
            weeklyDataMap[data.weekNumber] = data
        }
    }
    
    // MARK: - User Actions
    
    func selectWeek(_ week: Int) {
        guard week >= 1 && week <= 8 else { return }
        selectedWeek = week
    }
    
    func toggleItem(itemId: String) {
        guard var currentData = weeklyDataMap[selectedWeek] else { return }
        
        // Find and toggle the item
        // Note: Using nested loops for simplicity in MVP, could be optimized with flat map or ID lookup
        for (catIndex, category) in currentData.categories.enumerated() {
            if let itemIndex = category.items.firstIndex(where: { $0.id == itemId }) {
                // Toggle completion
                currentData.categories[catIndex].items[itemIndex].isCompleted.toggle()
                
                // Update the source of truth
                weeklyDataMap[selectedWeek] = currentData
                return // Found and updated
            }
        }
    }
}
