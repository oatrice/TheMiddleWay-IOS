
import SwiftUI

struct WeekSelectorView: View {
    @Binding var selectedWeek: Int
    
    // NFR-1 design palette from Android/Web
    // Week Button Colors based on mockups
    private let activeColor = Color.orange // "Saffron Orange" equivalent
    private let inactiveColor = Color.gray.opacity(0.2)
    private let activeTextColor = Color.white
    private let inactiveTextColor = Color.primary
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(1...8, id: \.self) { week in
                    Button(action: {
                        withAnimation {
                            selectedWeek = week
                        }
                    }) {
                        Text("Week \(week)")
                            .font(.system(size: 14, weight: .semibold))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(selectedWeek == week ? activeColor : inactiveColor)
                            .foregroundColor(selectedWeek == week ? activeTextColor : inactiveTextColor)
                            .cornerRadius(20) // "Pill" shape
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    WeekSelectorView(selectedWeek: .constant(1))
}
