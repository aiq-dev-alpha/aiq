import SwiftUI

struct EmptyStateScreen: View {
    let title: String?
    let message: String?
    let icon: String?
    let buttonText: String?
    let onAction: (() -> Void)?
    let illustration: AnyView?

    @State private var contentOpacity: Double = 0
    @State private var iconScale: CGFloat = 0.8
    @State private var contentOffset: CGFloat = 30

    init(
        title: String? = nil,
        message: String? = nil,
        icon: String? = nil,
        buttonText: String? = nil,
        onAction: (() -> Void)? = nil,
        illustration: AnyView? = nil
    ) {
        self.title = title
        self.message = message
        self.icon = icon
        self.buttonText = buttonText
        self.onAction = onAction
        self.illustration = illustration
    }

    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: 32) {
                // Illustration or icon
                Group {
                    if let illustration = illustration {
                        illustration
                    } else {
                        ZStack {
                            Circle()
                                .fill(Color(red: 0.42, green: 0.45, blue: 0.50).opacity(0.1))
                                .frame(width: 120, height: 120)

                            Image(systemName: icon ?? "tray")
                                .font(.system(size: 60))
                                .foregroundColor(Color(red: 0.61, green: 0.64, blue: 0.69))
                        }
                    }
                }
                .scaleEffect(iconScale)

                // Content
                VStack(spacing: 12) {
                    Text(title ?? "Nothing here yet")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.22))
                        .multilineTextAlignment(.center)

                    Text(message ?? "It looks like there's no content to show right now. Try refreshing or come back later.")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 0.42, green: 0.45, blue: 0.50))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 32)

                    if let onAction = onAction, let buttonText = buttonText {
                        Button(action: onAction) {
                            Text(buttonText)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(Color(red: 0.39, green: 0.40, blue: 0.95))
                                .cornerRadius(12)
                        }
                        .padding(.horizontal, 32)
                        .padding(.top, 20)
                    }
                }
                .opacity(contentOpacity)
                .offset(y: contentOffset)
            }

            Spacer()
        }
        .background(Color.white)
        .onAppear {
            startAnimations()
        }
    }

    private func startAnimations() {
        // Icon animation
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0).delay(0.2)) {
            iconScale = 1.0
        }

        // Content animation
        withAnimation(.easeOut(duration: 0.6)) {
            contentOpacity = 1
            contentOffset = 0
        }
    }
}

// Specific empty state variations
struct QuizEmptyState: View {
    var body: some View {
        EmptyStateScreen(
            title: "No Quizzes Available",
            message: "Check back later for new AI challenges and tests to expand your knowledge.",
            icon: "questionmark.circle",
            buttonText: "Refresh"
        )
    }
}

struct ResultsEmptyState: View {
    var body: some View {
        EmptyStateScreen(
            title: "No Results Yet",
            message: "Complete your first quiz to see your AIQ score and progress.",
            icon: "chart.bar",
            buttonText: "Take a Quiz"
        )
    }
}

struct LeaderboardEmptyState: View {
    var body: some View {
        EmptyStateScreen(
            title: "Leaderboard Coming Soon",
            message: "The leaderboard will show top performers once more users join.",
            icon: "chart.line.uptrend.xyaxis",
            buttonText: "Invite Friends"
        )
    }
}

struct NotificationsEmptyState: View {
    var body: some View {
        EmptyStateScreen(
            title: "No Notifications",
            message: "You're all caught up! We'll notify you about new quizzes and achievements.",
            icon: "bell.slash"
        )
    }
}

struct SearchEmptyState: View {
    var body: some View {
        EmptyStateScreen(
            title: "No Results Found",
            message: "Try adjusting your search terms or browse our available categories.",
            icon: "magnifyingglass",
            buttonText: "Browse Categories"
        )
    }
}

struct FavoritesEmptyState: View {
    var body: some View {
        EmptyStateScreen(
            title: "No Favorites Yet",
            message: "Start marking quizzes as favorites to see them here for quick access.",
            icon: "heart",
            buttonText: "Explore Quizzes"
        )
    }
}

struct HistoryEmptyState: View {
    var body: some View {
        EmptyStateScreen(
            title: "No History",
            message: "Your completed quizzes and activities will appear here once you start taking tests.",
            icon: "clock.arrow.circlepath",
            buttonText: "Start Testing"
        )
    }
}

// Custom illustration example
struct CustomIllustrationEmptyState: View {
    var body: some View {
        EmptyStateScreen(
            title: "Custom Empty State",
            message: "This is an example of an empty state with a custom illustration.",
            buttonText: "Try Again",
            illustration: AnyView(
                VStack {
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 80))
                        .foregroundColor(Color(red: 0.39, green: 0.40, blue: 0.95))
                        .background(
                            Circle()
                                .fill(Color(red: 0.39, green: 0.40, blue: 0.95).opacity(0.1))
                                .frame(width: 140, height: 140)
                        )
                }
            )
        )
    }
}

#Preview {
    EmptyStateScreen()
}