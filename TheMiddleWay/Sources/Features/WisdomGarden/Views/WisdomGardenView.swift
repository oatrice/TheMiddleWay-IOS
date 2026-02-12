
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
                            // Trigger data reload when week changes
                            Task {
                                await viewModel.loadWeeklyData(for: newWeek)
                            }
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
                        
                        // FR-3: Checklist (Read-Only Dashboard)
                        PracticeChecklistView(
                            categories: data.categories,
                            onCheckItem: { _ in }, // No-op in read-only
                            readOnly: true,
                            onWarnReadOnly: {
                                // Simple tactile feedback or toast could go here
                                // For MVP, the button below is the clear CTA
                            }
                        )
                        .opacity(0.8) // Visual cue
                        
                        // Navigation to Practice Room
                        NavigationLink(destination: WeeklyPracticesView(viewModel: viewModel)) {
                            Text("Go to Practice Room")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppColors.primary)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 24)
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
            .background(AppColors.background) // Use custom theme background
        }
    }
}

#Preview {
    WisdomGardenView()
}


