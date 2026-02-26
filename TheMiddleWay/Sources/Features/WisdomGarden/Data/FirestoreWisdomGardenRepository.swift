import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

class FirestoreWisdomGardenRepository: WisdomGardenRepository {
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    
    // Schema Constants
    private let usersCollection = "users"
    private let weeklyPracticesCollection = "weekly_practices"
    private let masterWeeksCollection = "master_weeks"
    
    // MARK: - Get Weekly Data
    func getWeeklyData(week: Int) async throws -> WeeklyData {
        guard let user = auth.currentUser else {
            throw URLError(.userAuthenticationRequired)
        }
        
        // 1. Try to fetch from User's Private Collection
        // Path: users/{uid}/weekly_practices/week-{week}
        let userDocRef = db.collection(usersCollection)
            .document(user.uid)
            .collection(weeklyPracticesCollection)
            .document("\(week)")
            
        do {
            let document = try await userDocRef.getDocument()
            if document.exists {
                // Found user data
                let data = try document.data(as: WeeklyData.self)
                print("🔥 [Firestore] Found User Data for Week \(week)")
                return data
            } else {
                // Not found -> Fetch Master Data & Create User Copy
                print("🔥 [Firestore] User Data missing for Week \(week). Fetching Master...")
                return try await fetchMasterAndCreateUserData(week: week, userId: user.uid)
            }
        } catch {
            print("❌ [Firestore] Error fetching week \(week): \(error)")
            throw error
        }
    }
    
    // MARK: - Fetch Master & Create User Data (Lazy Copy)
    private func fetchMasterAndCreateUserData(week: Int, userId: String) async throws -> WeeklyData {
        // Path: master_weeks/week-{week}
        let masterDocRef = db.collection(masterWeeksCollection).document("week-\(week)")
        
        let document = try await masterDocRef.getDocument()
        guard document.exists, var masterData = try? document.data(as: WeeklyData.self) else {
            throw URLError(.resourceUnavailable) // Master data missing
        }
        
        // Transform Master Data -> User Data
        // 1. Update IDs to be unique for user (Optional, but good for local swift usage)
        // 2. Add userID
        // 3. Reset completion
        
        let userWeekID = "u-\(userId)-w-\(week)"
        // WeeklyData has no stored ID or UserID, just weekNumber.
        
        var newCategories: [PracticeCategory] = []
        for var cat in masterData.categories {
            cat.id = "u-\(userId)-w-\(week)-\(cat.id)" // unique cat id
            
            var newItems: [PracticeItem] = []
            for var item in cat.items {
                item.id = "u-\(userId)-w-\(week)-\(item.id)" // unique item id
                item.isCompleted = false
                newItems.append(item)
            }
            cat.items = newItems
            newCategories.append(cat)
        }
        masterData.categories = newCategories
        
        // Write to User Collection
        let userDocRef = db.collection(usersCollection)
            .document(userId)
            .collection(weeklyPracticesCollection)
            .document("\(week)")
            
        try userDocRef.setData(from: masterData)
        print("🔥 [Firestore] Created User Data for Week \(week)")
        
        return masterData
    }
    
    // MARK: - Toggle Practice
    func togglePractice(id: String, isCompleted: Bool) async throws {
        guard let user = auth.currentUser else {
            throw URLError(.userAuthenticationRequired)
        }
        
        // Query to find the item in the current week (we need to know which week it belongs to?)
        // The Protocol only passes ID. This is tricky in Firestore NoSQL if we don't know the parent doc.
        // However, our ID format "u-{uid}-w-{week}-..." contains the week info!
        // or we can search.
        // Given existing Architecture, let's assume we know the current week from ViewModel or check ID parsing.
        
        // Parse Week from ID? "u-uid-w-1-..."
        guard let weekNumber = extractWeekFromID(id) else {
            throw URLError(.badURL)
        }
        
        let userDocPath = db.collection(usersCollection)
            .document(user.uid)
            .collection(weeklyPracticesCollection)
            .document("\(weekNumber)")
            
        // We need to update a nested object in the array.
        // Firestore doesn't support updating an array element by ID easily without reading the whole doc or using elaborate paths if stored as map.
        // Our structure: WeeklyData -> [Categories] -> [Items].
        // Simplest way: Transaction (Read -> Modify -> Write).
        
        let _ = try await db.runTransaction({ (transaction, errorPointer) -> Any? in
            let document: DocumentSnapshot
            do {
                document = try transaction.getDocument(userDocPath)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard var weeklyData = try? document.data(as: WeeklyData.self) else {
                let error = NSError(domain: "App", code: 404, userInfo: [NSLocalizedDescriptionKey: "Week not found"])
                errorPointer?.pointee = error
                return nil
            }
            
            // Find and Update Item
            var found = false
            for (cIndex, category) in weeklyData.categories.enumerated() {
                if let iIndex = category.items.firstIndex(where: { $0.id == id }) {
                    weeklyData.categories[cIndex].items[iIndex].isCompleted = isCompleted
                    // Update Score (Optional if computed locally, but good to store)
                    // ...
                    found = true
                    break
                }
            }
            
            if !found {
                 let error = NSError(domain: "App", code: 404, userInfo: [NSLocalizedDescriptionKey: "Item not found in week \(weekNumber)"])
                 errorPointer?.pointee = error
                 return nil
            }
            
            // Write back
            do {
                try transaction.setData(from: weeklyData, forDocument: userDocPath)
            } catch let writeError as NSError {
                 errorPointer?.pointee = writeError
                 return nil
            }
            
            return nil
        })
        
        print("🔥 [Firestore] Toggled item \(id) to \(isCompleted)")
    }
    
    private func extractWeekFromID(_ id: String) -> Int? {
        // ID Format: u-{uid}-w{week}-{...} or similar.
        // Our updated format: "u-{uid}-w-{week}-{masterID}"
        // e.g., "u-xyz-w-1-m1"
        // Let's regex or split.
        let components = id.components(separatedBy: "-")
        // Look for "w" followed by number
        for (index, comp) in components.enumerated() {
            if comp == "w" && index + 1 < components.count {
                return Int(components[index + 1])
            }
            // Handling "w1" format if legacy:
            if comp.hasPrefix("w") && comp.count > 1, let val = Int(comp.dropFirst()) {
                 return val
            }
        }
        
        // Fallback: If we can't parse, maybe we query locally?
        // For now, assume ID contains valid week info as generated.
        return nil
    }
}
