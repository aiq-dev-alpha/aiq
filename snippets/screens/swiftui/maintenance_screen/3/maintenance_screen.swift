import SwiftUI

struct MaintenanceScreen: View {
    let title: String?
    let message: String?
    let estimatedEnd: Date?
    let onRefresh: (() -> Void)?
    let supportEmail: String?

    @State private var contentOpacity: Double = 0
    @State private var contentOffset: CGFloat = 50
    @State private var toolsRotation: Double = 0
    @State private var toolsOffset: CGFloat = 0

    init(
        title: String? = nil,
        message: String? = nil,
        estimatedEnd: Date? = nil,
        onRefresh: (() -> Void)? = nil,
        supportEmail: String? = nil
    ) {
        self.title = title
        self.message = message
        self.estimatedEnd = estimatedEnd
        self.onRefresh = onRefresh
        self.supportEmail = supportEmail
    }

    var body: some View {
        VStack {
            VStack(spacing: 40) {
                // Maintenance illustration
                MaintenanceIllustrationView(
                    toolsRotation: toolsRotation,
                    toolsOffset: toolsOffset
                )

                // Content
                VStack(spacing: 16) {
                    Text(title ?? "Under Maintenance")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.22))
                        .multilineTextAlignment(.center)

                    Text(message ?? "We're currently performing scheduled maintenance to improve your AIQ experience. Thank you for your patience!")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 0.42, green: 0.45, blue: 0.50))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 24)

                    // Estimated time
                    if let estimatedEnd = estimatedEnd {
                        HStack(spacing: 12) {
                            Image(systemName: "clock")
                                .font(.system(size: 16))
                                .foregroundColor(Color(red: 0.96, green: 0.62, blue: 0.04))

                            Text(formatEstimatedTime(estimatedEnd))
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(red: 0.57, green: 0.25, blue: 0.05))
                        }
                        .padding()
                        .background(Color(red: 0.96, green: 0.62, blue: 0.04).opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 0.96, green: 0.62, blue: 0.04).opacity(0.3), lineWidth: 1)
                        )
                        .cornerRadius(12)
                    }
                }

                Spacer()

                // Status updates section
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "info.circle")
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 0.39, green: 0.40, blue: 0.95))

                        Text("What we're working on:")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(red: 0.22, green: 0.25, blue: 0.31))
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        StatusUpdateItem(text: "Improving quiz loading performance")
                        StatusUpdateItem(text: "Adding new AI challenges")
                        StatusUpdateItem(text: "Enhancing user experience")
                        StatusUpdateItem(text: "Server optimization")
                    }
                }
                .padding(20)
                .background(Color(red: 0.98, green: 0.98, blue: 0.98))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(red: 0.90, green: 0.91, blue: 0.92), lineWidth: 1)
                )
                .cornerRadius(16)

                Spacer()
            }
            .opacity(contentOpacity)
            .offset(y: contentOffset)
            .padding(.top, 60)

            // Action buttons
            VStack(spacing: 12) {
                // Check status button
                Button(action: handleRefresh) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 14, weight: .semibold))

                        Text("Check Status")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color(red: 0.39, green: 0.40, blue: 0.95))
                    .cornerRadius(12)
                }

                // Contact support button
                if let supportEmail = supportEmail {
                    Button(action: { copyToClipboard(supportEmail) }) {
                        HStack {
                            Image(systemName: "envelope")
                                .font(.system(size: 14, weight: .medium))

                            Text("Contact Support")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(Color(red: 0.42, green: 0.45, blue: 0.50))
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 0.90, green: 0.91, blue: 0.92), lineWidth: 1)
                        )
                    }
                }

                // Footer text
                Text("Follow us on social media for live updates")
                    .font(.system(size: 12))
                    .foregroundColor(Color(red: 0.61, green: 0.64, blue: 0.69))
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
        withAnimation(.easeOut(duration: 1.0)) {
            contentOpacity = 1
            contentOffset = 0
        }

        // Tools animation
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            toolsRotation = 15
            toolsOffset = 10
        }
    }

    private func formatEstimatedTime(_ date: Date) -> String {
        let now = Date()
        let difference = date.timeIntervalSince(now)

        if difference <= 0 {
            return "Expected to be resolved soon"
        }

        let hours = Int(difference) / 3600
        let minutes = (Int(difference) % 3600) / 60

        if hours > 0 {
            return "Expected back in \(hours)h \(minutes)m"
        } else {
            return "Expected back in \(minutes)m"
        }
    }

    private func handleRefresh() {
        if let onRefresh = onRefresh {
            onRefresh()
        } else {
            // Default refresh behavior - show a message
            // You could implement a toast or alert here
        }
    }

    private func copyToClipboard(_ text: String) {
        UIPasteboard.general.string = text
        // Show feedback that email was copied
        // You could implement a toast notification here
    }
}

struct MaintenanceIllustrationView: View {
    let toolsRotation: Double
    let toolsOffset: CGFloat

    var body: some View {
        ZStack {
            // Main container
            Circle()
                .fill(Color(red: 0.96, green: 0.62, blue: 0.04).opacity(0.1))
                .frame(width: 160, height: 160)

            // Main wrench icon
            Image(systemName: "wrench.and.screwdriver.fill")
                .font(.system(size: 60))
                .foregroundColor(Color(red: 0.96, green: 0.62, blue: 0.04))

            // Animated tools around
            Group {
                Image(systemName: "gearshape")
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 0.96, green: 0.62, blue: 0.04).opacity(0.6))
                    .rotationEffect(.degrees(toolsRotation))
                    .offset(x: 60, y: -40 + toolsOffset)

                Image(systemName: "hammer")
                    .font(.system(size: 18))
                    .foregroundColor(Color(red: 0.96, green: 0.62, blue: 0.04).opacity(0.5))
                    .rotationEffect(.degrees(-toolsRotation * 0.6))
                    .offset(x: -50, y: 50 + toolsOffset * 0.8)

                Image(systemName: "wrench")
                    .font(.system(size: 16))
                    .foregroundColor(Color(red: 0.96, green: 0.62, blue: 0.04).opacity(0.4))
                    .rotationEffect(.degrees(toolsRotation * 0.3))
                    .offset(x: 70, y: 30 + toolsOffset * 0.6)
            }
        }
        .frame(width: 160, height: 160)
    }
}

struct StatusUpdateItem: View {
    let text: String

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color(red: 0.39, green: 0.40, blue: 0.95))
                .frame(width: 4, height: 4)

            Text(text)
                .font(.system(size: 14))
                .foregroundColor(Color(red: 0.42, green: 0.45, blue: 0.50))

            Spacer()
        }
    }
}

// Specific maintenance screen variations
struct ScheduledMaintenanceScreen: View {
    var body: some View {
        MaintenanceScreen(
            title: "Scheduled Maintenance",
            message: "We're performing routine maintenance to keep AIQ running smoothly. Service will be restored shortly.",
            estimatedEnd: Date().addingTimeInterval(3600), // 1 hour from now
            supportEmail: "support@aiq.com"
        )
    }
}

struct EmergencyMaintenanceScreen: View {
    var body: some View {
        MaintenanceScreen(
            title: "Emergency Maintenance",
            message: "We're working urgently to resolve a critical issue. Thank you for your patience as we get things back online.",
            supportEmail: "support@aiq.com"
        )
    }
}

#Preview {
    MaintenanceScreen()
}