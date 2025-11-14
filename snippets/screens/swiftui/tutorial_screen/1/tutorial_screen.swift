import SwiftUI

struct TutorialScreen: View {
    @State private var currentStep = 0
    @State private var showOverlay = true
    @State private var pulseScale: CGFloat = 1.0

    private let tutorialSteps: [TutorialStep] = [
        TutorialStep(
            title: "Navigation Menu",
            description: "Tap the menu icon to access different sections of the app.",
            position: .topLeft,
            targetFrame: CGRect(x: 16, y: 60, width: 28, height: 28)
        ),
        TutorialStep(
            title: "Start a Quiz",
            description: "Tap here to begin your AI intelligence assessment.",
            position: .center,
            targetFrame: CGRect(x: 150, y: 350, width: 120, height: 120)
        ),
        TutorialStep(
            title: "View Your Progress",
            description: "Check your scores and track improvement over time.",
            position: .bottomRight,
            targetFrame: CGRect(x: 24, y: 550, width: 200, height: 60)
        ),
        TutorialStep(
            title: "Settings & Profile",
            description: "Customize your experience and manage your profile.",
            position: .topRight,
            targetFrame: CGRect(x: 350, y: 60, width: 28, height: 28)
        )
    ]

    var body: some View {
        ZStack {
            // Mock app interface
            mockAppInterface

            // Tutorial overlay
            if showOverlay {
                tutorialOverlay
            }
        }
        .onAppear {
            startPulseAnimation()
        }
    }

    private var mockAppInterface: some View {
        VStack {
            // App bar
            HStack {
                Image(systemName: "line.horizontal.3")
                    .font(.system(size: 28))
                    .foregroundColor(.white)

                Spacer()

                Text("AIQ")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)

                Spacer()

                Image(systemName: "person.circle")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)

            // Main content
            VStack {
                Spacer()

                VStack(spacing: 24) {
                    // Play button
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.39, green: 0.40, blue: 0.95))
                            .frame(width: 120, height: 120)

                        Image(systemName: "play.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                    }

                    Text("Start Your AIQ Test")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.22))

                    // Progress card
                    HStack {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .foregroundColor(Color(red: 0.39, green: 0.40, blue: 0.95))

                        Text("View Progress")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.95, green: 0.96, blue: 0.97))
                    .cornerRadius(16)
                    .padding(.horizontal, 24)
                }

                Spacer()
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.39, green: 0.40, blue: 0.95),
                    Color(red: 0.55, green: 0.36, blue: 0.96)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

    private var tutorialOverlay: some View {
        ZStack {
            // Dark overlay
            Color.black.opacity(0.8)
                .ignoresSafeArea()

            // Spotlight effect
            SpotlightView(
                targetFrame: tutorialSteps[currentStep].targetFrame,
                pulseScale: pulseScale
            )

            // Tutorial content
            VStack {
                Spacer()

                TutorialContentCard(
                    step: tutorialSteps[currentStep],
                    currentStep: currentStep,
                    totalSteps: tutorialSteps.count,
                    onPrevious: previousStep,
                    onNext: nextStep,
                    onSkip: skipTutorial
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 100)
            }
        }
    }

    private func startPulseAnimation() {
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.2
        }
    }

    private func nextStep() {
        if currentStep < tutorialSteps.count - 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentStep += 1
            }
        } else {
            completeTutorial()
        }
    }

    private func previousStep() {
        if currentStep > 0 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentStep -= 1
            }
        }
    }

    private func skipTutorial() {
        completeTutorial()
    }

    private func completeTutorial() {
        withAnimation(.easeOut(duration: 0.3)) {
            showOverlay = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // Navigate to permissions
            // NavigationManager.shared.navigate(to: .permissions)
        }
    }
}

struct TutorialContentCard: View {
    let step: TutorialStep
    let currentStep: Int
    let totalSteps: Int
    let onPrevious: () -> Void
    let onNext: () -> Void
    let onSkip: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Header
            HStack {
                Text("\(currentStep + 1)/\(totalSteps)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(red: 0.39, green: 0.40, blue: 0.95))
                    .cornerRadius(12)

                Spacer()

                Button("Skip", action: onSkip)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(red: 0.42, green: 0.45, blue: 0.50))
            }

            // Content
            VStack(alignment: .leading, spacing: 8) {
                Text(step.title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.22))

                Text(step.description)
                    .font(.system(size: 16))
                    .foregroundColor(Color(red: 0.42, green: 0.45, blue: 0.50))
                    .lineSpacing(2)
            }

            // Buttons
            HStack(spacing: 12) {
                if currentStep > 0 {
                    Button(action: onPrevious) {
                        Text("Previous")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(red: 0.42, green: 0.45, blue: 0.50))
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.90, green: 0.91, blue: 0.92), lineWidth: 1)
                            )
                    }
                }

                Button(action: onNext) {
                    Text(currentStep == totalSteps - 1 ? "Finish" : "Next")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color(red: 0.39, green: 0.40, blue: 0.95))
                        .cornerRadius(12)
                }
            }
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(16)
    }
}

struct SpotlightView: View {
    let targetFrame: CGRect
    let pulseScale: CGFloat

    var body: some View {
        // Simplified spotlight effect
        Circle()
            .fill(Color.white.opacity(0.2))
            .frame(width: 80 * pulseScale, height: 80 * pulseScale)
            .position(x: targetFrame.midX, y: targetFrame.midY)
    }
}

struct TutorialStep {
    let title: String
    let description: String
    let position: TutorialPosition
    let targetFrame: CGRect
}

enum TutorialPosition {
    case topLeft, topRight, bottomLeft, bottomRight, center
}

#Preview {
    TutorialScreen()
}