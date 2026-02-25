
import Foundation
import Combine



class NetworkWisdomGardenRepository: WisdomGardenRepository {
    // For Simulator, localhost works. For device, need IP.
    // Ensure "App Transport Security Settings" allows Arbitrary Loads or configure localhost.
    private let baseURL = "http://localhost:8080/api/v1/wisdom-garden"
    private let session: URLSession
    private let authService: AuthService
    
    init(session: URLSession = .shared, authService: AuthService = .shared) {
        self.session = session
        self.authService = authService
    }
    
    func getWeeklyData(week: Int) async throws -> WeeklyData {
        guard let url = URL(string: "\(baseURL)/weeks/\(week)") else {
            throw URLError(.badURL)
        }
        
        print("🌐 [Net] Fetching Week: \(week) -> \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Add Auth Token
        if let token = try? await authService.getIDToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
             print("⚠️ [Net] Warning: No Auth Token available for request")
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
            // decoder.keyDecodingStrategy = .convertFromSnakeCase // Backend uses camelCase for most, except created_at
            
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
