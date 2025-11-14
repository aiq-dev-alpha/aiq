import SwiftUI

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0
    @State private var textOpacity: Double = 0
    @State private var showProgressIndicator = false

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.39, green: 0.40, blue: 0.95), // #6366F1
                    Color(red: 0.39, green: 0.40, blue: 0.95).opacity(0.8)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                // Logo
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white)
                        .frame(width: 120, height: 120)
                        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)

                    Image(systemName: "rocket.fill")
                        .font(.system(size: 60))
                        .foregroundColor(Color(red: 0.39, green: 0.40, blue: 0.95))
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)

                // Title
                VStack(spacing: 16) {
                    Text("AIQ")
                        .font(.system(size: 32, weight: .bold, design: .default))
                        .foregroundColor(.white)
                        .tracking(2)

                    Text("Artificial Intelligence Quotient")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                        .tracking(0.5)
                }
                .opacity(textOpacity)

                // Progress indicator
                if showProgressIndicator {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white.opacity(0.7)))
                        .scaleEffect(1.2)
                        .transition(.opacity)
                }
            }
        }
        .onAppear {
            startAnimations()
        }
        .preferredColorScheme(.dark)
    }

    private func startAnimations() {
        // Logo animation
        withAnimation(.easeIn(duration: 0.5)) {
            logoOpacity = 1
        }

        withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0)) {
            logoScale = 1.0
        }

        // Text animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeIn(duration: 0.6)) {
                textOpacity = 1
            }
        }

        // Progress indicator
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.easeIn(duration: 0.4)) {
                showProgressIndicator = true
            }
        }

        // Navigate to next screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            // Navigate to onboarding
            // NavigationManager.shared.navigate(to: .onboarding)
        }
    }
}

#Preview {
    SplashScreen()
}