import SwiftUI

struct OnboardingCarouselScreen: View {
    @State private var currentIndex = 0
    @State private var dragOffset: CGSize = .zero

    private let onboardingPages: [OnboardingPage] = [
        OnboardingPage(
            icon: "brain.head.profile",
            title: "Discover Your AI Potential",
            description: "Explore the fascinating world of artificial intelligence and discover how smart you really are.",
            color: Color(red: 0.39, green: 0.40, blue: 0.95)
        ),
        OnboardingPage(
            icon: "questionmark.circle.fill",
            title: "Take Smart Challenges",
            description: "Engage with carefully crafted questions designed to test your AI knowledge and reasoning skills.",
            color: Color(red: 0.55, green: 0.36, blue: 0.96)
        ),
        OnboardingPage(
            icon: "chart.line.uptrend.xyaxis",
            title: "Track Your Progress",
            description: "Monitor your improvement over time and compete with friends to see who has the highest AIQ score.",
            color: Color(red: 0.02, green: 0.71, blue: 0.83)
        )
    ]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        onboardingPages[currentIndex].color,
                        onboardingPages[currentIndex].color.opacity(0.8)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.5), value: currentIndex)

                VStack {
                    // Skip button
                    HStack {
                        Spacer()
                        Button("Skip") {
                            navigateToWelcome()
                        }
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                        .padding()
                    }

                    Spacer()

                    // Page content
                    TabView(selection: $currentIndex) {
                        ForEach(Array(onboardingPages.enumerated()), id: \.offset) { index, page in
                            OnboardingPageView(page: page)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .frame(height: geometry.size.height * 0.6)

                    Spacer()

                    // Page indicators and navigation
                    VStack(spacing: 32) {
                        // Page indicators
                        HStack(spacing: 8) {
                            ForEach(0..<onboardingPages.count, id: \.self) { index in
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(currentIndex == index ? Color.white : Color.white.opacity(0.4))
                                    .frame(width: currentIndex == index ? 24 : 8, height: 8)
                                    .animation(.easeInOut(duration: 0.3), value: currentIndex)
                            }
                        }

                        // Next button
                        Button(action: nextPage) {
                            HStack {
                                Text(currentIndex == onboardingPages.count - 1 ? "Get Started" : "Next")
                                    .font(.system(size: 16, weight: .semibold))
                                if currentIndex < onboardingPages.count - 1 {
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                            }
                            .foregroundColor(onboardingPages[currentIndex].color)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.white)
                            .cornerRadius(16)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private func nextPage() {
        if currentIndex < onboardingPages.count - 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentIndex += 1
            }
        } else {
            navigateToWelcome()
        }
    }

    private func navigateToWelcome() {
        // Navigate to welcome screen
        // NavigationManager.shared.navigate(to: .welcome)
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 48) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 120, height: 120)

                Image(systemName: page.icon)
                    .font(.system(size: 60))
                    .foregroundColor(.white)
            }

            // Content
            VStack(spacing: 24) {
                Text(page.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)

                Text(page.description)
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 24)
        }
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
    let color: Color
}

#Preview {
    OnboardingCarouselScreen()
}