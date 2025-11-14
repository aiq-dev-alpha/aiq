import SwiftUI

struct ErrorScreen: View {
    let title: String?
    let message: String?
    let buttonText: String?
    let onRetry: (() -> Void)?
    let onGoBack: (() -> Void)?

    @State private var contentOpacity: Double = 0
    @State private var contentOffset: CGFloat = 50
    @State private var iconScale: CGFloat = 0.8
    @State private var illustrationOffset: CGFloat = 0

    init(
        title: String? = nil,
        message: String? = nil,
        buttonText: String? = nil,
        onRetry: (() -> Void)? = nil,
        onGoBack: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.buttonText = buttonText
        self.onRetry = onRetry
        self.onGoBack = onGoBack
    }

    var body: some View {
        VStack {
            VStack(spacing: 40) {
                // Error icon
                ZStack {
                    Circle()
                        .fill(Color(red: 0.94, green: 0.27, blue: 0.27).opacity(0.1))
                        .frame(width: 120, height: 120)
                        .overlay(
                            Circle()
                                .stroke(Color(red: 0.94, green: 0.27, blue: 0.27).opacity(0.2), lineWidth: 2)
                        )

                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 60))
                        .foregroundColor(Color(red: 0.94, green: 0.27, blue: 0.27))
                }
                .scaleEffect(iconScale)

                // Content
                VStack(spacing: 16) {
                    Text(title ?? "Oops! Something went wrong")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.22))
                        .multilineTextAlignment(.center)

                    Text(message ?? "We encountered an unexpected error. Don't worry, it happens to the best of us! Please try again.")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 0.42, green: 0.45, blue: 0.50))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 24)
                }

                Spacer()

                // Error illustration
                ErrorIllustrationView()
                    .offset(y: illustrationOffset)

                Spacer()
            }
            .opacity(contentOpacity)
            .offset(y: contentOffset)
            .padding(.top, 60)

            // Action buttons
            VStack(spacing: 12) {
                // Retry button
                Button(action: handleRetry) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 16, weight: .semibold))

                        Text(buttonText ?? "Try Again")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color(red: 0.39, green: 0.40, blue: 0.95))
                    .cornerRadius(16)
                }

                // Go back button
                Button(action: handleGoBack) {
                    HStack {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 16, weight: .medium))

                        Text("Go Back")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(Color(red: 0.42, green: 0.45, blue: 0.50))
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(red: 0.90, green: 0.91, blue: 0.92), lineWidth: 1)
                    )
                }

                // Help text
                Text("If the problem persists, please contact our support team")
                    .font(.system(size: 12))
                    .foregroundColor(Color(red: 0.42, green: 0.45, blue: 0.50).opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
            }
            .opacity(contentOpacity)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .background(Color.white)
        .onAppear {
            startAnimations()
        }
    }

    private func startAnimations() {
        // Content animation
        withAnimation(.easeOut(duration: 0.8)) {
            contentOpacity = 1
            contentOffset = 0
        }

        // Icon animation
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0)) {
            iconScale = 1.0
        }

        // Illustration floating animation
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            illustrationOffset = -10
        }
    }

    private func handleRetry() {
        if let onRetry = onRetry {
            onRetry()
        }
    }

    private func handleGoBack() {
        if let onGoBack = onGoBack {
            onGoBack()
        } else {
            // Default back navigation
            // NavigationManager.shared.goBack()
        }
    }
}

struct ErrorIllustrationView: View {
    var body: some View {
        ZStack {
            // Robot body
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(red: 0.95, green: 0.96, blue: 0.97))
                .frame(width: 80, height: 60)

            // Robot head
            Circle()
                .fill(Color(red: 0.95, green: 0.96, blue: 0.97))
                .frame(width: 50, height: 50)
                .offset(y: -30)

            // Broken parts (X mark on face)
            ZStack {
                Path { path in
                    path.move(to: CGPoint(x: -10, y: -35))
                    path.addLine(to: CGPoint(x: 10, y: -25))
                }
                .stroke(Color(red: 0.94, green: 0.27, blue: 0.27), lineWidth: 2)

                Path { path in
                    path.move(to: CGPoint(x: 10, y: -35))
                    path.addLine(to: CGPoint(x: -10, y: -25))
                }
                .stroke(Color(red: 0.94, green: 0.27, blue: 0.27), lineWidth: 2)
            }
        }
        .frame(width: 200, height: 150)
    }
}

// Specific error screen variations
struct NetworkErrorScreen: View {
    var body: some View {
        ErrorScreen(
            title: "Connection Problem",
            message: "We're having trouble connecting to our servers. Please check your internet connection and try again.",
            buttonText: "Retry Connection"
        )
    }
}

struct ServerErrorScreen: View {
    var body: some View {
        ErrorScreen(
            title: "Server Error",
            message: "Our servers are experiencing some issues. Our team has been notified and is working on a fix.",
            buttonText: "Try Again"
        )
    }
}

struct NotFoundErrorScreen: View {
    var body: some View {
        ErrorScreen(
            title: "Page Not Found",
            message: "The page you're looking for doesn't exist or has been moved to a different location.",
            buttonText: "Go Home"
        )
    }
}

#Preview {
    ErrorScreen()
}