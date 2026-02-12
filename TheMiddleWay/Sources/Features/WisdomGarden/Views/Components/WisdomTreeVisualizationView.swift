
import SwiftUI

struct WisdomTreeVisualizationView: View {
    let currentScore: Int
    let maxScore: Int
    
    // NFR-2: Dynamic visualization logic
    private var progress: Double {
        guard maxScore > 0 else { return 0 }
        return Double(currentScore) / Double(maxScore)
    }
    
    private var treeIconName: String {
        switch progress {
        case 0..<0.2: return "leaf" // Seedling
        case 0.2..<0.4: return "leaf.arrow.circlepath" // Sprouting
        case 0.4..<0.6: return "tree" // Growing
        case 0.6..<0.8: return "tree.fill" // Full Tree
        default: return "laurel.leading" // Flourishing
        }
    }
    
    private var treeColor: Color {
        // Match Android behavior: Always use Primary color (Blue/Amber) for the tree progress visualization
        return AppColors.primary
    }
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.1), lineWidth: 20)
                    .frame(width: 200, height: 200)
                
                Circle()
                    .trim(from: 0, to: CGFloat(progress))
                    .stroke(
                        AppColors.primary,
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(), value: progress)
                
                Image(systemName: treeIconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(treeColor)
                    // Simple scale animation on change
                    .scaleEffect(progress > 0 ? 1.0 : 0.8)
                    .animation(.bouncy, value: treeIconName)
            }
            .padding()
            
            Text("\(currentScore) / \(maxScore)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(AppColors.textPrimary)
                .contentTransition(.numericText()) // iOS 17 numeric transition
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(AppColors.surface) // Adapts to Light/Dark (Sky Surface / Slate Dark)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    WisdomTreeVisualizationView(currentScore: 25, maxScore: 40)
}
