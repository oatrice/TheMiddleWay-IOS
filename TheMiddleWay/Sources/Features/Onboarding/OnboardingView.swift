import SwiftUI

struct OnboardingSlide: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
}

struct OnboardingView: View {
    @EnvironmentObject var onboardingService: OnboardingService
    @State private var currentPage = 0
    
    let slides = [
        OnboardingSlide(title: "Welcome to The Middle Way", description: "Find balance and harmony in your daily life.", imageName: "onboarding_welcome"),
        OnboardingSlide(title: "Authentic Wisdom", description: "It's more than just quotes. It's timeless knowledge, verified and applied to modern life.", imageName: "onboarding_wisdom"),
        OnboardingSlide(title: "Discover Your Path", description: "Explore curated insights from philosophy, science, and art to find clarity.", imageName: "onboarding_path"),
         OnboardingSlide(title: "A Daily Practice", description: "Engage with one profound idea each day to build a more meaningful life.", imageName: "onboarding_practice")
    ]
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                if currentPage < slides.count - 1 {
                    Button("Skip") {
                        onboardingService.completeOnboarding()
                    }
                    .foregroundColor(.secondary)
                } else {
                     // Keep layout stable
                     Text("").frame(height: 20)
                }
            }
            .padding()
            
            TabView(selection: $currentPage) {
                ForEach(0..<slides.count, id: \.self) { index in
                    OnboardingPageView(slide: slides[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            
            Button(action: {
                if currentPage < slides.count - 1 {
                    withAnimation {
                        currentPage += 1
                    }
                } else {
                    onboardingService.completeOnboarding()
                }
            }) {
                Text(currentPage == slides.count - 1 ? "Begin Journey" : "Next")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding()
        }
        .background(Color(UIColor.systemBackground))
    }
}

struct OnboardingPageView: View {
    let slide: OnboardingSlide
    
    var body: some View {
        VStack(spacing: 20) {
            Image(slide.imageName)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 300)
                .padding()
                
            Text(slide.title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                
            Text(slide.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
        .padding()
    }
}
