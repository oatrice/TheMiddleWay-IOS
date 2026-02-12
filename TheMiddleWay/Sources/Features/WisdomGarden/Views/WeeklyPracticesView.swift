
import SwiftUI

struct WeeklyPracticesView: View {
    @ObservedObject var viewModel: WisdomGardenViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header/Title context
                // Week Selector & Score
                VStack(spacing: 16) {
                    WeekSelectorView(selectedWeek: $viewModel.selectedWeek)
                        .onChange(of: viewModel.selectedWeek) { newWeek in
                            Task {
                                await viewModel.loadWeeklyData(for: newWeek)
                            }
                        }
                    
                    if let data = viewModel.currentWeekData {
                         Text("\(data.currentScore) / \(data.maxScore) Points")
                             .font(.title2)
                             .bold()
                             .foregroundColor(AppColors.primary)
                    }
                }
                
                Divider()
                    .padding(.horizontal)
                
                if let data = viewModel.currentWeekData {
                    PracticeChecklistView(
                        categories: data.categories,
                        onCheckItem: { id in
                            viewModel.toggleItem(itemId: id)
                        },
                        readOnly: false // Interactive!
                    )
                } else {
                    ProgressView()
                }
                
                Spacer(minLength: 40)
            }
        }
        .navigationTitle("Practice Room")
        .navigationBarTitleDisplayMode(.inline)
        .background(AppColors.background)
    }
}

#Preview {
    WeeklyPracticesView(viewModel: WisdomGardenViewModel()) // Mock VM
}
