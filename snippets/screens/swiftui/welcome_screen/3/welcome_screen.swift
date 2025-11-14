import SwiftUI

struct WelcomeScreen: View {
    @State private var titleOpacity: Double = 0
    @State private var contentOffset: CGFloat = 30
    @State private var illustrationScale: CGFloat = 0.8
    @State private var buttonsOpacity: Double = 0

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 24) {
                // Welcome badge
                HStack {
                    HStack {
                        Text("Welcome!")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(red: 0.39, green: 0.40, blue: 0.95))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(red: 0.39, green: 0.40, blue: 0.95).opacity(0.1))
                    .cornerRadius(20)

                    Spacer()
                }

                // Main title
                VStack(alignment: .leading, spacing: 16) {
                    Text("Ready to test your\nAI intelligence?")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.22))
                        .lineSpacing(4)

                    Text("Join thousands of users discovering their AI potential. Let's get you started on your journey to understanding artificial intelligence.")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 0.42, green: 0.45, blue: 0.50))
                        .lineSpacing(4)
                }
            }
            .opacity(titleOpacity)
            .offset(y: contentOffset)
            .padding(.horizontal, 24)
            .padding(.top, 40)

            Spacer()

            // Illustration
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.39, green: 0.40, blue: 0.95),
                                Color(red: 0.55, green: 0.36, blue: 0.96)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 200, height: 200)
                    .shadow(color: Color(red: 0.39, green: 0.40, blue: 0.95).opacity(0.3), radius: 40, x: 0, y: 20)

                Image(systemName: "brain.head.profile")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
            }
            .scaleEffect(illustrationScale)

            Spacer()

            // Action buttons
            VStack(spacing: 16) {
                Button(action: startTutorial) {
                    HStack {
                        Text("Start Tutorial")
                            .font(.system(size: 16, weight: .semibold))

                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color(red: 0.39, green: 0.40, blue: 0.95))
                    .cornerRadius(16)
                }

                Button(action: skipTutorial) {
                    Text("Skip Tutorial")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(red: 0.42, green: 0.45, blue: 0.50))
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(red: 0.90, green: 0.91, blue: 0.92), lineWidth: 1)
                        )
                }
            }
            .opacity(buttonsOpacity)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .background(Color.white)
        .onAppear {
            startAnimations()
        }
    }

    private func startAnimations() {
        // Title animation
        withAnimation(.easeOut(duration: 0.6)) {
            titleOpacity = 1
            contentOffset = 0
        }

        // Illustration animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0)) {
                illustrationScale = 1.0
            }
        }

        // Buttons animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.easeOut(duration: 0.6)) {
                buttonsOpacity = 1
            }
        }
    }

    private func startTutorial() {
        // Navigate to tutorial
        // NavigationManager.shared.navigate(to: .tutorial)
    }

    private func skipTutorial() {
        // Navigate to main app
        // NavigationManager.shared.navigate(to: .main)
    }
}

#Preview {
    WelcomeScreen()
}