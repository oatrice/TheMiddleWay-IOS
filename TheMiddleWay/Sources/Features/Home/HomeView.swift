import SwiftUI

struct HomeView: View {
    @AppStorage(ThemeConfig.storageKey) private var isDarkMode = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Welcome Card
                WelcomeCard()
                
                // Quick Actions
                QuickActionsSection()
                
                // Recent Activity
                RecentActivitySection()
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
        .background(AppColors.background)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isDarkMode.toggle()
                } label: {
                    Image(systemName: ThemeConfig.toggleIconName(isDarkMode: isDarkMode))
                }
                .accessibilityLabel(ThemeConfig.toggleLabel(isDarkMode: isDarkMode))
            }
        }
    }
}

// MARK: - Welcome Card

struct WelcomeCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Welcome Back")
                .font(AppTypography.title2)
                .foregroundStyle(AppColors.textPrimary)
            
            Text("Continue your journey towards mindfulness and balance.")
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Quick Actions

struct QuickActionsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(AppTypography.title3)
                .foregroundStyle(AppColors.textPrimary)
            
            HStack(spacing: 12) {
                QuickActionButton(
                    icon: "book.fill",
                    title: "Continue",
                    color: AppColors.primary
                )
                
                QuickActionButton(
                    icon: "plus.circle.fill",
                    title: "New",
                    color: AppColors.primary
                )
                
                QuickActionButton(
                    icon: "bookmark.fill",
                    title: "Saved",
                    color: AppColors.primary
                )
            }
        }
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(color)
            
            Text(title)
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Recent Activity

struct RecentActivitySection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(AppTypography.title3)
                .foregroundStyle(AppColors.textPrimary)
            
            VStack(spacing: 12) {
                ActivityRow(
                    icon: "book.closed.fill",
                    title: "Introduction to Mindfulness",
                    subtitle: "Chapter 3 completed",
                    time: "Today"
                )
                
                ActivityRow(
                    icon: "headphones",
                    title: "Meditation Session",
                    subtitle: "15 minutes",
                    time: "Yesterday"
                )
                
                ActivityRow(
                    icon: "note.text",
                    title: "Daily Reflection",
                    subtitle: "Gratitude journal entry",
                    time: "2 days ago"
                )
            }
        }
    }
}

struct ActivityRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let time: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(AppColors.primary)
                .frame(width: 40, height: 40)
                .background(AppColors.surface)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AppTypography.label)
                    .foregroundStyle(AppColors.textPrimary)
                
                Text(subtitle)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
            
            Spacer()
            
            Text(time)
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)
        }
        .padding(12)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .navigationTitle("The Middle Way")
            .navigationBarTitleDisplayMode(.large)
    }
}
