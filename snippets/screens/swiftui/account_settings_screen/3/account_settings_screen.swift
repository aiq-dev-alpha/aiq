import SwiftUI

struct AccountSettingsScreen: View {
    @State private var twoFactorEnabled = false
    @State private var loginNotifications = true
    @State private var showingChangeEmail = false
    @State private var showingChangePassword = false
    @State private var showingDeleteAccount = false

    var body: some View {
        List {
            // Account Information
            Section("Account Information") {
                AccountInfoRow(
                    icon: "envelope",
                    title: "Email Address",
                    value: "john.doe@example.com",
                    action: { showingChangeEmail = true }
                )

                AccountInfoRow(
                    icon: "phone",
                    title: "Phone Number",
                    value: "+1 (555) 123-4567",
                    action: { /* Change phone */ }
                )

                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.secondary)
                        .frame(width: 20)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Member Since")
                            .font(.body)
                        Text("January 15, 2023")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()
                }
                .padding(.vertical, 4)
            }

            // Security
            Section("Security") {
                Button(action: { showingChangePassword = true }) {
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.secondary)
                            .frame(width: 20)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Change Password")
                                .font(.body)
                                .foregroundColor(.primary)
                            Text("Update your account password")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                    .padding(.vertical, 4)
                }

                Toggle(isOn: $twoFactorEnabled) {
                    HStack {
                        Image(systemName: "shield.checkered")
                            .foregroundColor(.secondary)
                            .frame(width: 20)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Two-Factor Authentication")
                                .font(.body)
                            Text("Add an extra layer of security")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                Button(action: showManageDevices) {
                    HStack {
                        Image(systemName: "desktopcomputer")
                            .foregroundColor(.secondary)
                            .frame(width: 20)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Manage Devices")
                                .font(.body)
                                .foregroundColor(.primary)
                            Text("View and manage logged in devices")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                    .padding(.vertical, 4)
                }

                Button(action: showLoginActivity) {
                    HStack {
                        Image(systemName: "clock.arrow.circlepath")
                            .foregroundColor(.secondary)
                            .frame(width: 20)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Login Activity")
                                .font(.body)
                                .foregroundColor(.primary)
                            Text("View recent login attempts")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                    .padding(.vertical, 4)
                }
            }

            // Security Notifications
            Section("Security Notifications") {
                Toggle(isOn: $loginNotifications) {
                    HStack {
                        Image(systemName: "bell")
                            .foregroundColor(.secondary)
                            .frame(width: 20)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Login Notifications")
                                .font(.body)
                            Text("Get notified of new logins")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                Toggle(isOn: .constant(true)) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.secondary)
                            .frame(width: 20)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Security Alerts")
                                .font(.body)
                            Text("Alerts for suspicious activity")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }

            // Data Management
            Section("Data Management") {
                Button(action: requestDataDownload) {
                    HStack {
                        Image(systemName: "square.and.arrow.down")
                            .foregroundColor(.secondary)
                            .frame(width: 20)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Download Data")
                                .font(.body)
                                .foregroundColor(.primary)
                            Text("Download a copy of your data")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                    .padding(.vertical, 4)
                }

                Button(action: { showingDeleteAccount = true }) {
                    HStack {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                            .frame(width: 20)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Delete Account")
                                .font(.body)
                                .foregroundColor(.red)
                            Text("Permanently delete your account")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Account Settings")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingChangeEmail) {
            ChangeEmailSheet()
        }
        .sheet(isPresented: $showingChangePassword) {
            ChangePasswordSheet()
        }
        .alert("Delete Account", isPresented: $showingDeleteAccount) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                // Handle account deletion
            }
        } message: {
            Text("This action cannot be undone. All your data will be permanently deleted.")
        }
    }

    private func showManageDevices() {
        // Show manage devices screen
    }

    private func showLoginActivity() {
        // Show login activity screen
    }

    private func requestDataDownload() {
        // Request data download
    }
}

struct AccountInfoRow: View {
    let icon: String
    let title: String
    let value: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.secondary)
                    .frame(width: 20)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .foregroundColor(.primary)
                    Text(value)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "pencil")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            .padding(.vertical, 4)
        }
    }
}

struct ChangeEmailSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var newEmail = ""
    @State private var password = ""

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("New Email Address", text: $newEmail)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)

                    SecureField("Current Password", text: $password)
                }

                Section {
                    Button("Update Email") {
                        // Handle email update
                        dismiss()
                    }
                    .disabled(newEmail.isEmpty || password.isEmpty)
                }
            }
            .navigationTitle("Change Email")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ChangePasswordSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""

    var body: some View {
        NavigationView {
            Form {
                Section {
                    SecureField("Current Password", text: $currentPassword)
                    SecureField("New Password", text: $newPassword)
                    SecureField("Confirm New Password", text: $confirmPassword)
                }

                Section {
                    Button("Change Password") {
                        // Handle password change
                        dismiss()
                    }
                    .disabled(currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty)
                }
            }
            .navigationTitle("Change Password")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        AccountSettingsScreen()
    }
}