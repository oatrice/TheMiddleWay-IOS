
import SwiftUI

struct WisdomGardenView: View {
    @StateObject private var viewModel = WisdomGardenViewModel()
    
    @State private var showReadOnlyToast = false
    
    var body: some View {
        NavigationStack {
            ZStack {
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
                                .padding(.bottom, 8)

                            // Navigation to Practice Room (Moved up to match Android/Web)
                            NavigationLink(destination: WeeklyPracticesView(viewModel: viewModel)) {
                                HStack {
                                    Text("Go to Practice Room")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    Image(systemName: "arrow.right")
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppColors.primary)
                                .cornerRadius(12)
                                .shadow(radius: 2)
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 16)
                            
                            // FR-3: Checklist (Read-Only Dashboard)
                            PracticeChecklistView(
                                categories: data.categories,
                                onCheckItem: { _ in }, // No-op in read-only
                                readOnly: true,
                                onWarnReadOnly: {
                                    withAnimation {
                                        showReadOnlyToast = true
                                    }
                                    // Auto-hide after 2 seconds
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        withAnimation {
                                            showReadOnlyToast = false
                                        }
                                    }
                                }
                            )
                            .opacity(0.8) // Visual cue
                        } else if let errorMessage = viewModel.errorMessage {
                            VStack(spacing: 12) {
                                Image(systemName: "exclamationmark.triangle")
                                    .font(.system(size: 40))
                                    .foregroundColor(.red)
                                Text(errorMessage)
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                        } else {
                            // Fallback/Loading state
                            ProgressView("Loading Garden...")
                                .padding()
                        }
                        
                        Spacer(minLength: 40)
                    }
                }
                
                // Toast Overlay
                if showReadOnlyToast {
                    VStack {
                        Spacer()
                        Text("Please go to Practice Room to check-in")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.8))
                            .cornerRadius(8)
                            .padding(.bottom, 50)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    .zIndex(1) // Ensure it's on top
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


