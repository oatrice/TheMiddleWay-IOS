import Foundation

protocol WisdomGardenRepository {
    func getWeeklyData(week: Int) async throws -> WeeklyData
    func togglePractice(id: String, isCompleted: Bool) async throws
}
