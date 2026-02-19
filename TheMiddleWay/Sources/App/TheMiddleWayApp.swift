import SwiftUI

import FirebaseCore
import GoogleSignIn

@main
struct TheMiddleWayApp: App {
    @StateObject private var viewModel = MainViewModel()
    @StateObject private var onboardingService = OnboardingService()
    @StateObject private var authService = AuthService.shared
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                if onboardingService.isOnboardingCompleted {
                    ContentView()
                        .environmentObject(viewModel)
                        .environmentObject(authService)
                } else {
                    OnboardingView()
                        .environmentObject(onboardingService)
                        .environmentObject(authService)
                }
            }
            .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
}
