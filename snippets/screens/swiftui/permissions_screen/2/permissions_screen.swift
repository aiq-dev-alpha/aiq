import SwiftUI

struct PermissionsScreen: View {
    @State private var permissions: [PermissionItem] = [
        PermissionItem(
            icon: "bell.fill",
            title: "Notifications",
            description: "Get notified about new challenges and your progress",
            isRequired: false,
            isGranted: false
        ),
        PermissionItem(
            icon: "camera.fill",
            title: "Camera",
            description: "Take photos for your profile and share achievements",
            isRequired: false,
            isGranted: false
        ),
        PermissionItem(
            icon: "mic.fill",
            title: "Microphone",
            description: "Use voice commands for hands-free navigation",
            isRequired: false,
            isGranted: false
        ),
        PermissionItem(
            icon: "location.fill",
            title: "Location",
            description: "Find nearby users and location-based challenges",
            isRequired: false,
            isGranted: false
        )
    ]

    @State private var contentOpacity: Double = 0
    @State private var contentOffset: CGFloat = 50

    var body: some View {
        VStack {
            // Header
            VStack(alignment: .leading, spacing: 24) {
                HStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(red: 0.39, green: 0.40, blue: 0.95).opacity(0.1))
                            .frame(width: 48, height: 48)

                        Image(systemName: "shield.checkered")
                            .font(.system(size: 24))
                            .foregroundColor(Color(red: 0.39, green: 0.40, blue: 0.95))
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Permissions")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.22))

                        Text("Help us personalize your experience")
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 0.42, green: 0.45, blue: 0.50))
                    }

                    Spacer()
                }

                Text("We'd like your permission to access the following features to enhance your AIQ experience:")
                    .font(.system(size: 16))
                    .foregroundColor(Color(red: 0.42, green: 0.45, blue: 0.50))
                    .lineSpacing(4)
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)

            // Permissions list
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(Array(permissions.enumerated()), id: \.offset) { index, permission in
                        PermissionCard(
                            permission: permission,
                            onToggle: { togglePermission(at: index) }
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 32)
            }

            Spacer()

            // Action buttons
            VStack(spacing: 12) {
                Button(action: continueToApp) {
                    Text("Continue")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color(red: 0.39, green: 0.40, blue: 0.95))
                        .cornerRadius(16)
                }

                Button(action: skipPermissions) {
                    Text("Skip for now")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(red: 0.42, green: 0.45, blue: 0.50))
                        .frame(height: 44)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .opacity(contentOpacity)
        .offset(y: contentOffset)
        .background(Color.white)
        .onAppear {
            startAnimations()
        }
    }

    private func startAnimations() {
        withAnimation(.easeOut(duration: 0.8)) {
            contentOpacity = 1
            contentOffset = 0
        }
    }

    private func togglePermission(at index: Int) {
        withAnimation(.easeInOut(duration: 0.2)) {
            permissions[index].isGranted.toggle()
        }

        // Simulate permission request delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Show feedback if needed
        }
    }

    private func continueToApp() {
        // Navigate to interests screen
        // NavigationManager.shared.navigate(to: .interests)
    }

    private func skipPermissions() {
        // Navigate to interests screen
        // NavigationManager.shared.navigate(to: .interests)
    }
}

struct PermissionCard: View {
    let permission: PermissionItem
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(permission.isGranted ?
                          Color(red: 0.06, green: 0.73, blue: 0.51).opacity(0.1) :
                          Color(red: 0.42, green: 0.45, blue: 0.50).opacity(0.1)
                    )
                    .frame(width: 48, height: 48)

                Image(systemName: permission.icon)
                    .font(.system(size: 20))
                    .foregroundColor(permission.isGranted ?
                                   Color(red: 0.06, green: 0.73, blue: 0.51) :
                                   Color(red: 0.42, green: 0.45, blue: 0.50)
                    )
            }

            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(permission.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.22))

                    if permission.isRequired {
                        Text("Required")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color(red: 0.94, green: 0.27, blue: 0.27))
                            .cornerRadius(8)
                    }

                    Spacer()
                }

                Text(permission.description)
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0.42, green: 0.45, blue: 0.50))
                    .lineSpacing(2)
            }

            // Toggle button
            Button(action: onToggle) {
                Text(permission.isGranted ? "Granted" : "Allow")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(permission.isGranted ?
                              Color(red: 0.06, green: 0.73, blue: 0.51) :
                              Color(red: 0.39, green: 0.40, blue: 0.95)
                    )
                    .cornerRadius(8)
            }
        }
        .padding(16)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(red: 0.90, green: 0.91, blue: 0.92), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 2)
    }
}

struct PermissionItem {
    let icon: String
    let title: String
    let description: String
    let isRequired: Bool
    var isGranted: Bool
}

#Preview {
    PermissionsScreen()
}