
import SwiftUI

struct PracticeChecklistView: View {
    let categories: [PracticeCategory]
    let onCheckItem: (String) -> Void
    
    // NFR-3: User Experience - Smooth, interactive checklist
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(categories) { category in
                VStack(alignment: .leading, spacing: 8) {
                    Text(category.title)
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 8)
                    
                    ForEach(category.items) { item in
                        Button(action: {
                            // Haptic Feedback for good UX
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                            
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                onCheckItem(item.id)
                            }
                        }) {
                            HStack(alignment: .top, spacing: 12) {
                                // Custom Checkbox using SF Symbols
                                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(item.isCompleted ? .green : .gray)
                                    .scaleEffect(item.isCompleted ? 1.1 : 1.0)
                                    .animation(.bouncy, value: item.isCompleted)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.title)
                                        .font(.body)
                                        .foregroundColor(item.isCompleted ? .secondary : .primary)
                                        .strikethrough(item.isCompleted) // Visual feedback for completion
                                        .multilineTextAlignment(.leading)
                                    
                                    Text("+ \(item.points) pts")
                                        .font(.caption)
                                        .foregroundColor(item.isCompleted ? .green : .gray)
                                }
                                
                                Spacer()
                            }
                            .padding()
                            .background(Color(.systemGray6)) // Subtle background for card
                            .cornerRadius(12)
                        }
                        .buttonStyle(PlainButtonStyle()) // Remove default button highlighting for cleaner look
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    PracticeChecklistView(
        categories: [
            PracticeCategory(id: "c1", title: "General", items: [
                PracticeItem(id: "i1", title: "Meditate for 10 mins", points: 10, isCompleted: true),
                PracticeItem(id: "i2", title: "Read a chapter", points: 10, isCompleted: false)
            ])
        ],
        onCheckItem: { _ in }
    )
}
