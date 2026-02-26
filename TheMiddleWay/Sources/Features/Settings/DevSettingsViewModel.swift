import Foundation
import SwiftUI
import Combine

enum ApiEnvironment: String, CaseIterable, Identifiable {
    case render = "render"
    case local = "local"
    case custom = "custom"
    
    var id: String { self.rawValue }
}

class DevSettingsViewModel: ObservableObject {
    @AppStorage("apiEnvironment") var apiEnvironment: ApiEnvironment = .render
    @AppStorage("customApiUrl") var customApiUrl: String = "http://localhost:8080/api/v1/wisdom-garden"
    
    // Singleton for easy access in other VMs
    static let shared = DevSettingsViewModel()
    
    func getBaseUrl() -> String {
        switch apiEnvironment {
        case .render:
            return "https://themiddleway-backend-djw7.onrender.com/api/v1/wisdom-garden"
        case .local:
            return "http://localhost:8080/api/v1/wisdom-garden"
        case .custom:
            return customApiUrl
        }
    }
}
