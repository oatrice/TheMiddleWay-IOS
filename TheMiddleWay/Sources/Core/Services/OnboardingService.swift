import SwiftUI
import Combine

class OnboardingService: ObservableObject {
    @AppStorage("onboarding_completed") var isOnboardingCompleted: Bool = false
    
    func completeOnboarding() {
        withAnimation {
            isOnboardingCompleted = true
        }
    }
    
    func resetOnboarding() {
         withAnimation {
            isOnboardingCompleted = false
        }
    }
}
