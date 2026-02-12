import SwiftUI

@main
struct TheMiddleWayApp: App {
    @StateObject private var viewModel = MainViewModel()
    @StateObject private var onboardingService = OnboardingService()

    var body: some Scene {
        WindowGroup {
            if onboardingService.isOnboardingCompleted {
                ContentView()
                    .environmentObject(viewModel)
            } else {
                OnboardingView()
                    .environmentObject(onboardingService)
            }
        }
    }
}
