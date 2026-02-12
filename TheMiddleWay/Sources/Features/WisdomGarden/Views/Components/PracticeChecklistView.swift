
import SwiftUI

struct PracticeChecklistView: View {
    let categories: [PracticeCategory]
    let onCheckItem: (String) -> Void
    var readOnly: Bool = false
    var onWarnReadOnly: () -> Void = {}
    
    // NFR-3: User Experience - Smooth, interactive checklist
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(categories) { category in
                VStack(alignment: .leading, spacing: 8) {
                    Text(category.title)
                        .font(.headline)
                        .foregroundColor(AppColors.textSecondary)
                        .padding(.vertical, 8)
                    
                    ForEach(category.items) { item in
                        Button(action: {
                            if readOnly {
                                onWarnReadOnly()
                            } else {
                                // Haptic Feedback for good UX
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.impactOccurred()
                                
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    onCheckItem(item.id)
                                }
                            }
                        }) {
                            HStack(alignment: .top, spacing: 12) {
                                // Custom Checkbox using SF Symbols
                                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(item.isCompleted ? (readOnly ? AppColors.primary.opacity(0.6) : AppColors.primary) : AppColors.textSecondary)
                                    .scaleEffect(item.isCompleted ? 1.1 : 1.0)
                                    .animation(.bouncy, value: item.isCompleted)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.title)
                                        .font(.body)
                                        .foregroundColor(item.isCompleted ? AppColors.textSecondary : AppColors.textPrimary)
                                        .strikethrough(item.isCompleted) // Visual feedback for completion
                                        .multilineTextAlignment(.leading)
                                        .opacity(readOnly ? 0.8 : 1.0)
                                    
                                    Text("+ \(item.points) pts")
                                        .font(.caption)
                                        .foregroundColor(item.isCompleted ? (readOnly ? AppColors.primary.opacity(0.6) : AppColors.primary) : AppColors.textSecondary)
                                }
                                
                                Spacer()
                                
                                if item.isCompleted {
                                    // Optional checkmark indicator on the right for extra clarity
                                }
                            }
                            .padding()
                            .background(AppColors.surface.opacity(readOnly ? 0.6 : 1.0)) // Slightly dimmed if read-only
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(AppColors.textSecondary.opacity(0.1), lineWidth: 1)
                            )
                        }
                        .buttonStyle(PlainButtonStyle()) // Remove default button highlighting for cleaner look
                        .disabled(false) // Always enabled to capture tap for warning
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
