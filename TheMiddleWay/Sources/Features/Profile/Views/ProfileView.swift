
import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var viewModel: MainViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // MARK: - User Status Section
                if let user = authService.currentUser {
                    // Logged In State
                    VStack(spacing: 16) {
                        if let photoURL = user.photoURL {
                            AsyncImage(url: photoURL) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                            }
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.gray)
                        }
                        
                        Text(user.displayName ?? "User")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(user.email ?? "")
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        Button(action: {
                            authService.signOut()
                        }) {
                            Text("Sign Out")
                                .font(.headline)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(AppColors.surface)
                    .cornerRadius(16)
                    
                } else {
                    // Guest State
                    VStack(spacing: 20) {
                        Image(systemName: "person.crop.circle.badge.questionmark")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        
                        Text("Sign In")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Sign in to sync your mindfulness progress across devices.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .font(.body)
                        
                        Button(action: {
                            authService.signInWithGoogle()
                        }) {
                            HStack {
                                Image(systemName: "globe")
                                Text("Sign in with Google")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(AppColors.surface)
                    .cornerRadius(16)
                }
                
                // MARK: - Progress Section (Restored)
                VStack(spacing: 16) {
                    Text("Your Progress")
                        .font(AppTypography.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Completed Lessons: \(viewModel.userProgress.completedLessons.count)")
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                    
                    Button("Complete Demo Lesson") {
                        viewModel.completeLesson("DEMO_IOS_\(Date().timeIntervalSince1970)")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AppColors.primary)
                    .frame(maxWidth: .infinity)
                    
                    Button("Reset Progress", role: .destructive) {
                        viewModel.resetProgress()
                    }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .background(AppColors.surface)
                .cornerRadius(16)
                
                // MARK: - Dev Settings
                NavigationLink(destination: DevSettingsView()) {
                    HStack {
                        Image(systemName: "gearshape.2.fill")
                        Text("Developer Settings")
                    }
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                }
                
                Spacer()
            }
            .padding()
        }
        .background(AppColors.background)
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}
