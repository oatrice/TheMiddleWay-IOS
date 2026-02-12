
import SwiftUI

struct WisdomGardenView: View {
    @StateObject private var viewModel = WisdomGardenViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView { // Main scrollable area
                VStack(spacing: 24) {
                    
                    // FR-1: App Header & Week Selector
                    // Header handled by NavigationTitle + Toolbar Item (Theme/Lang)
                    
                    WeekSelectorView(selectedWeek: $viewModel.selectedWeek)
                        .padding(.top, 8)
                        .onChange(of: viewModel.selectedWeek) { newWeek in
                            // Logic handles reactive update via currentWeekData
                            print("Week switched to: \(newWeek)")
                        }
                    
                    if let data = viewModel.currentWeekData {
                        // FR-2: Visualization
                        WisdomTreeVisualizationView(
                            currentScore: viewModel.currentScore,
                            maxScore: viewModel.maxScore
                        )
                        .padding(.horizontal)
                        
                        // Divider for visual separation
                        Divider()
                            .padding(.horizontal)
                        
                        // FR-3: Checklist
                        PracticeChecklistView(
                            categories: data.categories,
                            onCheckItem: { id in
                                viewModel.toggleItem(itemId: id)
                            }
                        )
                    } else {
                        // Fallback/Loading state
                        ProgressView("Loading Garden...")
                            .padding()
                    }
                    
                    Spacer(minLength: 40)
                }
            }
            .navigationTitle("Wisdom Garden")
            .navigationBarTitleDisplayMode(.large)
            // .toolbar { ... Language Toggle, Settings, etc ... }
            .background(Color(.systemGroupedBackground)) // Subtle gray background for "App" feel
            .overlay(alignment: .bottom) {
                // Floating Action Button or subtle gradient could go here
                // For now, keep clean.
            }
        }
    }
}

#Preview {
    WisdomGardenView()
}
