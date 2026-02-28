
import Foundation
import FirebaseAuth
import GoogleSignIn
import Combine

class AuthService: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    static let shared = AuthService()
    
    init() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUser = user
                self?.isAuthenticated = user != nil
            }
        }
    }
    
    @MainActor
    func signInWithGoogle() {
        self.isLoading = true
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            print("❌ No root view controller found")
            self.isLoading = false
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
            if let error = error {
                print("❌ Google Sign-In Error: \(error.localizedDescription)")
                DispatchQueue.main.async { self?.isLoading = false }
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                DispatchQueue.main.async { self?.isLoading = false }
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    if let error = error {
                        print("❌ Firebase Sign-In Error: \(error.localizedDescription)")
                        return
                    }
                    print("✅ User signed in: \(result?.user.email ?? "No Email")")
                }
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("❌ Error signing out: \(error.localizedDescription)")
        }
    }
    
    func getIDToken() async throws -> String {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "AuthService", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])
        }
        return try await user.getIDToken()
    }
}
