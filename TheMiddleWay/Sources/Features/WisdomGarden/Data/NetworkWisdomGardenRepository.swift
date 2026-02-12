
import Foundation
import Combine

protocol WisdomGardenRepository {
    func getWeeklyData(week: Int) async throws -> WeeklyData
    func togglePractice(id: String, isCompleted: Bool) async throws
}

class NetworkWisdomGardenRepository: WisdomGardenRepository {
    // For Simulator, localhost works. For device, need IP.
    // Ensure "App Transport Security Settings" allows Arbitrary Loads or configure localhost.
    private let baseURL = "http://localhost:8080/api/v1/wisdom-garden"
    
    func getWeeklyData(week: Int) async throws -> WeeklyData {
        guard let url = URL(string: "\(baseURL)/weeks/\(week)") else {
            throw URLError(.badURL)
        }
        
        print("🌐 [Net] Fetching Week: \(week) -> \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
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
    }
    
    func togglePractice(id: String, isCompleted: Bool) async throws {
        guard let url = URL(string: "\(baseURL)/practices/\(id)/toggle") else {
            throw URLError(.badURL)
        }
        
        print("🌐 [Net] Toggle Item: \(id) (isCompleted: \(isCompleted)) -> \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Bool] = ["isCompleted": isCompleted]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
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
