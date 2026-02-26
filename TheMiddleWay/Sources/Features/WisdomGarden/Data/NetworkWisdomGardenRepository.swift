import Foundation
import Combine


class NetworkWisdomGardenRepository: WisdomGardenRepository {
    private var baseURL: String {
        DevSettingsViewModel.shared.getBaseUrl()
    }
    
    private let session: URLSession
    private let authService: AuthService
    
    init(session: URLSession = .shared, authService: AuthService = .shared) {
        self.session = session
        self.authService = authService
    }
    
    private let apiKey = "5cab538c42e5c5f8bafec058b6c51475d99699ec330befe5099c28a2ed50cb65"
    
    func getWeeklyData(week: Int) async throws -> WeeklyData {
        // Determine endpoint based on auth state
        let token = try? await authService.getIDToken()
        let endpoint: String
        if token != nil {
            endpoint = "\(baseURL)/weeks/\(week)"
        } else {
            // Not logged in → use public master endpoint
            endpoint = "\(baseURL)/master/weeks/\(week)"
            print("⚠️ [Net] User not logged in, using master endpoint")
        }
        
        guard let url = URL(string: endpoint) else {
            throw URLError(.badURL)
        }
        
        print("🌐 [Net] Fetching Week: \(week) -> \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "X-API-Key")
        
        // Add Auth Token if available
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                 print("❌ [Net] Fetch Week: Invalid Response")
                 throw URLError(.badServerResponse)
            }
            
            print("✅ [Net] Fetch Week: Status \(httpResponse.statusCode)")
            
            if httpResponse.statusCode != 200 {
                 print("❌ [Net] Fetch Week: Error \(httpResponse.statusCode)")
                 throw URLError(.badServerResponse)
            }
            
            let decoder = JSONDecoder()
            let result = try decoder.decode(WeeklyData.self, from: data)
            print("✅ [Net] Fetch Week: Success (Decoded items: \(result.categories.count) categories)")
            return result
        } catch {
            print("❌ [Net] Fetch Week Failed: \(error).")
            throw error
        }
    }
    
    func togglePractice(id: String, isCompleted: Bool) async throws {
        guard let encodedID = id.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let url = URL(string: "\(baseURL)/practices/\(encodedID)/toggle") else {
            throw URLError(.badURL)
        }
        
        print("🌐 [Net] Toggle Item: \(id) (isCompleted: \(isCompleted)) -> \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "X-API-Key")
        
        // Add Auth Token
        if let token = try? await authService.getIDToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let body: [String: Bool] = ["isCompleted": isCompleted]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
             print("❌ [Net] Toggle: Invalid Response")
             throw URLError(.badServerResponse)
        }
        
        print("✅ [Net] Toggle: Status \(httpResponse.statusCode)")
        
        if httpResponse.statusCode != 200 {
            throw URLError(.badServerResponse)
        }
    }
}
