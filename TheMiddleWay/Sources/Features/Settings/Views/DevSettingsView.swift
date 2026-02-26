import SwiftUI

struct DevSettingsView: View {
    @StateObject private var viewModel = DevSettingsViewModel.shared
    
    var body: some View {
        Form {
            Section(header: Text("Network Environment")) {
                Picker("Environment", selection: $viewModel.apiEnvironment) {
                    Text("Render (PROD)").tag(ApiEnvironment.render)
                    Text("Localhost (DEV)").tag(ApiEnvironment.local)
                    Text("Custom URL").tag(ApiEnvironment.custom)
                }
                .pickerStyle(.inline)
                
                if viewModel.apiEnvironment == .custom {
                    TextField("https://...", text: $viewModel.customApiUrl)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .keyboardType(.URL)
                }
                
                Text("Current Base URL:\n\(viewModel.getBaseUrl())")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Section(header: Text("Debug Info")) {
                Text("Version: 1.0.0 (Dev)")
            }
        }
        .navigationTitle("Developer Settings")
    }
}
