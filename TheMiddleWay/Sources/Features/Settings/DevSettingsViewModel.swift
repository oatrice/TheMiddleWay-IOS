import Foundation
import SwiftUI
import Combine

class DevSettingsViewModel: ObservableObject {
    @AppStorage("useApiMode") var useApiMode: Bool = true
    
    // Singleton for easy access in other VMs
    static let shared = DevSettingsViewModel()
}
