import SwiftUI

struct SuccessScreen: View {
    let title: String?
    let message: String?
    let buttonText: String?
    let onContinue: (() -> Void)?

    @State private var iconScale: CGFloat = 0.0
    @State private var contentOpacity: Double = 0
    @State private var contentOffset: CGFloat = 30
    @State private var showParticles: Bool = false

    init(
        title: String? = nil,
        message: String? = nil,
        buttonText: String? = nil,
        onContinue: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.buttonText = buttonText
        self.onContinue = onContinue
    }

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.06, green: 0.73, blue: 0.51), // #10B981
                    Color(red: 0.02, green: 0.56, blue: 0.41)  // #059669
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Floating particles
            if showParticles {
                ParticlesView()
            }

            VStack {
                Spacer()

                VStack(spacing: 40) {
                    // Success icon
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 120, height: 120)
                            .shadow(color: .black.opacity(0.2), radius: 30, x: 0, y: 15)

                        Image(systemName: "checkmark")
                            .font(.system(size: 60, weight: .bold))
                            .foregroundColor(Color(red: 0.06, green: 0.73, blue: 0.51))
                    }
                    .scaleEffect(iconScale)

                    // Content
                    VStack(spacing: 16) {
                        Text(title ?? "Success!")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)

                        Text(message ?? "Your profile has been created successfully. You're ready to start your AIQ journey!")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .padding(.horizontal, 24)
                    }
                    .opacity(contentOpacity)
                    .offset(y: contentOffset)
                }

                Spacer()

                // Continue button
                Button(action: handleContinue) {
                    HStack {
                        Text(buttonText ?? "Get Started")
                            .font(.system(size: 16, weight: .semibold))

                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(Color(red: 0.06, green: 0.73, blue: 0.51))
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.white)
                    .cornerRadius(16)
                }
                .opacity(contentOpacity)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            startAnimations()
        }
    }

    private func startAnimations() {
        // Icon animation
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0)) {
            iconScale = 1.0
        }

        // Content animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeOut(duration: 0.6)) {
                contentOpacity = 1
                contentOffset = 0
            }
        }

        // Particles animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.easeIn(duration: 0.4)) {
                showParticles = true
            }
        }
    }

    private func handleContinue() {
        if let onContinue = onContinue {
            onContinue()
        } else {
            // Navigate to main app
            // NavigationManager.shared.navigate(to: .main)
        }
    }
}

struct ParticlesView: View {
    @State private var particles: [Particle] = []

    var body: some View {
        ZStack {
            ForEach(particles, id: \.id) { particle in
                Text(particle.emoji)
                    .font(.system(size: 20))
                    .position(particle.position)
                    .opacity(particle.opacity)
                    .scaleEffect(particle.scale)
            }
        }
        .onAppear {
            createParticles()
        }
    }

    private func createParticles() {
        let emojis = ["✨", "🎉", "⭐", "🚀"]
        let positions = [
            CGPoint(x: 80, y: 150),
            CGPoint(x: 320, y: 120),
            CGPoint(x: 120, y: 300),
            CGPoint(x: 280, y: 320)
        ]

        for i in 0..<4 {
            let particle = Particle(
                id: i,
                emoji: emojis[i],
                position: positions[i],
                opacity: 0,
                scale: 0.5
            )
            particles.append(particle)

            // Animate each particle
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.2) {
                withAnimation(.easeInOut(duration: 2.0)) {
                    if let index = particles.firstIndex(where: { $0.id == i }) {
                        particles[index].position.y -= 40
                        particles[index].opacity = 1.0
                        particles[index].scale = 1.0
                    }
                }

                // Fade out
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        if let index = particles.firstIndex(where: { $0.id == i }) {
                            particles[index].opacity = 0
                        }
                    }
                }
            }
        }
    }
}

struct Particle: Identifiable {
    let id: Int
    let emoji: String
    var position: CGPoint
    var opacity: Double
    var scale: CGFloat
}

// Specific success screen variations
struct ProfileSuccessScreen: View {
    var body: some View {
        SuccessScreen(
            title: "Profile Created!",
            message: "Your profile has been created successfully. You're ready to start your AIQ journey!",
            buttonText: "Start Testing"
        )
    }
}

struct QuizCompletedScreen: View {
    var body: some View {
        SuccessScreen(
            title: "Quiz Completed!",
            message: "Great job! Your AIQ score has been calculated and saved to your profile.",
            buttonText: "View Results"
        )
    }
}

#Preview {
    SuccessScreen()
}