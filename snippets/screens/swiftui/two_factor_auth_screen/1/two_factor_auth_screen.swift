import SwiftUI
import Combine

enum TwoFactorMode {
    case setup
    case verify
}

struct TwoFactorAuthScreen: View {
    let mode: TwoFactorMode
    let qrCodeURL: String?
    let secret: String?

    @StateObject private var viewModel = TwoFactorAuthViewModel()
    @Environment(\.presentationMode) var presentationMode

    init(mode: TwoFactorMode = .setup, qrCodeURL: String? = nil, secret: String? = nil) {
        self.mode = mode
        self.qrCodeURL = qrCodeURL
        self.secret = secret
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    Spacer()
                        .frame(height: 20)

                    // Icon
                    Image(systemName: "shield.checkered")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)

                    if mode == .setup {
                        if viewModel.setupComplete {
                            backupCodesView
                        } else {
                            setupView
                        }
                    } else {
                        verifyView
                    }

                    Spacer()
                        .frame(height: 20)
                }
                .padding(.horizontal, 24)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if mode == .verify {
                        Button("Back") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }

                ToolbarItem(placement: .principal) {
                    Text(mode == .setup ? "Setup 2FA" : "Two-Factor Authentication")
                        .font(.headline)
                }
            }
        }
        .onAppear {
            if mode == .setup {
                viewModel.generateBackupCodes()
            }
        }
    }

    private var setupView: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Setup Two-Factor Authentication")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text("Secure your account with an additional layer of protection.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Step 1: Install app
            SetupStepView(
                stepNumber: 1,
                title: "Install an Authenticator App",
                content: AnyView(authenticatorAppsView)
            )

            // Step 2: Scan QR code
            SetupStepView(
                stepNumber: 2,
                title: "Scan QR Code or Enter Secret",
                content: AnyView(qrCodeView)
            )

            // Step 3: Enter verification code
            SetupStepView(
                stepNumber: 3,
                title: "Enter Verification Code",
                content: AnyView(verificationCodeView)
            )

            // Enable button
            Button(action: viewModel.enableTwoFactor) {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Verify & Enable 2FA")
                }
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(viewModel.verificationCode.count != 6 || viewModel.isLoading)
        }
    }

    private var verifyView: some View {
        VStack(spacing: 32) {
            // Header
            VStack(spacing: 8) {
                Text("Two-Factor Authentication")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Enter the 6-digit code from your authenticator app.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Verification code input
            OTPInputView(otp: $viewModel.verificationCode, isEnabled: !viewModel.isLoading)
                .onChange(of: viewModel.verificationCode) { newValue in
                    if newValue.count == 6 {
                        viewModel.verifyTwoFactor()
                    }
                }

            if let error = viewModel.error {
                ErrorView(message: error)
            }

            // Verify button
            Button(action: viewModel.verifyTwoFactor) {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Verify")
                }
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(viewModel.verificationCode.count != 6 || viewModel.isLoading)

            // Backup code button
            Button("Use Backup Code Instead") {
                viewModel.showingBackupCodeEntry = true
            }
            .foregroundColor(.blue)
        }
        .sheet(isPresented: $viewModel.showingBackupCodeEntry) {
            BackupCodeEntryView()
        }
    }

    private var backupCodesView: some View {
        VStack(spacing: 24) {
            // Success icon
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.1))
                    .frame(width: 120, height: 120)

                Image(systemName: "checkmark.circle")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
            }

            // Header
            VStack(spacing: 8) {
                Text("2FA Setup Complete!")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Save these backup codes in a safe place. You can use them to access your account if you lose your authenticator app.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Warning
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "exclamationmark.triangle")
                    .foregroundColor(.orange)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Important: Save Your Backup Codes")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)

                    Text("These codes can only be used once. Store them securely offline.")
                        .font(.caption)
                        .foregroundColor(.orange)
                }

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.orange.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.orange.opacity(0.3), lineWidth: 1)
            )

            // Backup codes grid
            BackupCodesGridView(codes: viewModel.backupCodes)

            // Continue button
            Button("Continue") {
                // Navigate to home
            }
            .buttonStyle(PrimaryButtonStyle())

            // Copy all codes button
            Button("Copy All Codes") {
                let allCodes = "Your backup codes:\n\n" + viewModel.backupCodes.joined(separator: "\n")
                UIPasteboard.general.string = allCodes
            }
            .buttonStyle(SecondaryButtonStyle())
        }
    }

    private var authenticatorAppsView: some View {
        HStack(spacing: 24) {
            AuthenticatorAppView(name: "Google\nAuthenticator", icon: "shield.checkered")
            AuthenticatorAppView(name: "Microsoft\nAuthenticator", icon: "shield.lefthalf.filled")
            AuthenticatorAppView(name: "Authy", icon: "checkmark.shield")
        }
    }

    private var qrCodeView: some View {
        VStack(spacing: 16) {
            // QR Code placeholder
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
                .frame(width: 200, height: 200)
                .overlay(
                    VStack {
                        Image(systemName: "qrcode")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        Text("QR Code")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                )

            Text("Can't scan? Enter this code manually:")
                .font(.caption)
                .foregroundColor(.secondary)

            HStack {
                Text(secret ?? "JBSWY3DPEHPK3PXP")
                    .font(.system(.body, design: .monospaced))
                    .fontWeight(.semibold)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                Button(action: {
                    UIPasteboard.general.string = secret ?? "JBSWY3DPEHPK3PXP"
                }) {
                    Image(systemName: "doc.on.doc")
                }
                .foregroundColor(.blue)
            }
        }
    }

    private var verificationCodeView: some View {
        VStack(spacing: 12) {
            Text("Enter the 6-digit code from your authenticator app:")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            OTPInputView(otp: $viewModel.verificationCode, isEnabled: !viewModel.isLoading)

            if let error = viewModel.error {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}

class TwoFactorAuthViewModel: ObservableObject {
    @Published var verificationCode = ""
    @Published var isLoading = false
    @Published var setupComplete = false
    @Published var error: String?
    @Published var backupCodes: [String] = []
    @Published var showingBackupCodeEntry = false

    func generateBackupCodes() {
        // Generate 8 backup codes
        backupCodes = (0..<8).map { _ in
            let part1 = String(format: "%04X", Int.random(in: 0...0xFFFF))
            let part2 = String(format: "%04X", Int.random(in: 0...0xFFFF))
            return "\(part1)-\(part2)"
        }
    }

    func enableTwoFactor() {
        guard verificationCode.count == 6 else { return }

        isLoading = true
        error = nil

        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
            self.setupComplete = true
        }
    }

    func verifyTwoFactor() {
        guard verificationCode.count == 6 else { return }

        isLoading = true
        error = nil

        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
            // Handle success/failure
        }
    }
}

struct SetupStepView<Content: View>: View {
    let stepNumber: Int
    let title: String
    let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                ZStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 24, height: 24)

                    Text("\(stepNumber)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }

                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Spacer()
            }

            content
        }
        .padding(.all, 16)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}

struct AuthenticatorAppView: View {
    let name: String
    let icon: String

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .frame(width: 60, height: 60)
                    .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 1)

                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.blue)
            }

            Text(name)
                .font(.caption)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct BackupCodesGridView: View {
    let codes: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Backup Codes")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Spacer()

                Button(action: {
                    UIPasteboard.general.string = codes.joined(separator: "\n")
                }) {
                    Image(systemName: "doc.on.doc")
                        .foregroundColor(.blue)
                }
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                ForEach(codes, id: \.self) { code in
                    Text(code)
                        .font(.system(.caption, design: .monospaced))
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(Color.white)
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                }
            }
        }
        .padding(.all, 16)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}

struct BackupCodeEntryView: View {
    @State private var backupCode = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Enter Backup Code")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Enter one of your backup codes to sign in:")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)

                TextField("XXXX-XXXX", text: $backupCode)
                    .textFieldStyle(CustomTextFieldStyle())
                    .textCase(.uppercase)
                    .autocorrectionDisabled()

                HStack {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .buttonStyle(SecondaryButtonStyle())

                    Button("Verify") {
                        // Verify backup code
                        presentationMode.wrappedValue.dismiss()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }

                Spacer()
            }
            .padding(.horizontal, 24)
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    TwoFactorAuthScreen(mode: .setup)
}