import SwiftUI

struct LoadingScreen: View {
    let title: String?
    let message: String?
    let showProgress: Bool
    let progress: Double?
    let primaryColor: Color?

    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var contentOpacity: Double = 0
    @State private var currentMessageIndex: Int = 0

    private let loadingMessages = [
        "Preparing your experience...",
        "Loading AI challenges...",
        "Setting up your profile...",
        "Almost ready..."
    ]

    init(
        title: String? = nil,
        message: String? = nil,
        showProgress: Bool = false,
        progress: Double? = nil,
        primaryColor: Color? = nil
    ) {
        self.title = title
        self.message = message
        self.showProgress = showProgress
        self.progress = progress
        self.primaryColor = primaryColor
    }

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    primaryColor ?? Color(red: 0.39, green: 0.40, blue: 0.95),
                    (primaryColor ?? Color(red: 0.39, green: 0.40, blue: 0.95)).opacity(0.8)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 40) {
                // Animated loading indicator
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 80, height: 80)
                        .scaleEffect(pulseScale)

                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                        .frame(width: 64, height: 64)
                        .rotationEffect(.degrees(rotationAngle))

                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 48, height: 48)

                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 24))
                            .foregroundColor(primaryColor ?? Color(red: 0.39, green: 0.40, blue: 0.95))
                    }
                }

                // Content
                VStack(spacing: 16) {
                    Text(title ?? "Loading")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)

                    // Animated message
                    Text(message ?? loadingMessages[currentMessageIndex])
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)
                        .transition(.opacity.combined(with: .slide))
                        .id("message-\(currentMessageIndex)")
                }

                // Progress indicator
                if showProgress {
                    VStack(spacing: 8) {
                        if let progress = progress {
                            HStack {
                                Spacer()
                                Text("\(Int(progress * 100))%")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white.opacity(0.7))
                            }

                            ProgressView(value: progress, total: 1.0)
                                .progressViewStyle(LinearProgressViewStyle(tint: .white))
                                .background(Color.white.opacity(0.3))
                                .cornerRadius(2)
                                .frame(height: 4)
                        } else {
                            ProgressView()
                                .progressViewStyle(LinearProgressViewStyle(tint: .white))
                                .background(Color.white.opacity(0.3))
                                .cornerRadius(2)
                                .frame(height: 4)
                        }
                    }
                    .padding(.horizontal, 32)
                } else {
                    // Dots loading indicator
                    HStack(spacing: 8) {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(Color.white)
                                .frame(width: 8, height: 8)
                                .opacity(getDotOpacity(for: index))
                                .animation(
                                    .easeInOut(duration: 0.6)
                                    .repeatForever()
                                    .delay(Double(index) * 0.2),
                                    value: rotationAngle
                                )
                        }
                    }
                }
            }
            .opacity(contentOpacity)
            .padding(.horizontal, 32)
        }
        .preferredColorScheme(.dark)
        .onAppear {
            startAnimations()
        }
    }

    private func startAnimations() {
        // Content fade in
        withAnimation(.easeIn(duration: 0.8)) {
            contentOpacity = 1
        }

        // Rotation animation
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }

        // Pulse animation
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.2
        }

        // Message cycling (only if no custom message)
        if message == nil {
            startMessageCycle()
        }
    }

    private func startMessageCycle() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                currentMessageIndex = (currentMessageIndex + 1) % loadingMessages.count
            }
        }
    }

    private func getDotOpacity(for index: Int) -> Double {
        let normalizedTime = (rotationAngle / 360.0).truncatingRemainder(dividingBy: 1.0)
        let phase = (normalizedTime + Double(index) * 0.33).truncatingRemainder(dividingBy: 1.0)
        return 0.4 + 0.6 * sin(phase * 2 * .pi)
    }
}

// Specific loading screen variations
struct QuizLoadingScreen: View {
    var body: some View {
        LoadingScreen(
            title: "Preparing Quiz",
            message: "Loading questions and setting up your challenge...",
            showProgress: true,
            progress: 0.65
        )
    }
}

struct ProfileLoadingScreen: View {
    var body: some View {
        LoadingScreen(
            title: "Setting up Profile",
            message: "Creating your personalized AIQ experience..."
        )
    }
}

struct ResultsLoadingScreen: View {
    var body: some View {
        LoadingScreen(
            title: "Calculating Score",
            message: "Analyzing your responses and computing your AIQ...",
            showProgress: true,
            progress: 0.85,
            primaryColor: Color(red: 0.06, green: 0.73, blue: 0.51)
        )
    }
}

struct DataSyncLoadingScreen: View {
    var body: some View {
        LoadingScreen(
            title: "Syncing Data",
            message: "Updating your progress and syncing with the cloud...",
            showProgress: false,
            primaryColor: Color(red: 0.02, green: 0.71, blue: 0.83)
        )
    }
}

struct UploadLoadingScreen: View {
    @State private var uploadProgress: Double = 0.0

    var body: some View {
        LoadingScreen(
            title: "Uploading",
            message: "Saving your results to the cloud...",
            showProgress: true,
            progress: uploadProgress,
            primaryColor: Color(red: 0.55, green: 0.36, blue: 0.96)
        )
        .onAppear {
            // Simulate upload progress
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                uploadProgress += 0.02
                if uploadProgress >= 1.0 {
                    timer.invalidate()
                }
            }
        }
    }
}

#Preview {
    LoadingScreen()
}