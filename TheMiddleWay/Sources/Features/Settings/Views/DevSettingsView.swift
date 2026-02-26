import SwiftUI

struct DevSettingsView: View {
    @StateObject private var viewModel = DevSettingsViewModel.shared
    
    var body: some View {
        Form {
            Section(header: Text("Data Source")) {
                Toggle("Use API Mode (Go Backend)", isOn: $viewModel.useApiMode)
                
                if viewModel.useApiMode {
                    Text("Using REST API: https://themiddleway-backend-djw7.onrender.com")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    Text("Using Firestore Direct Mode")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Section(header: Text("Debug Info")) {
                Text("Version: 1.0.0 (Dev)")
            }
        }
        .navigationTitle("Developer Settings")
    }
}
