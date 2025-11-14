import SwiftUI
import LocalAuthentication

struct BiometricAuthScreen: View {
    let isSetup: Bool
    @StateObject private var viewModel = BiometricAuthViewModel()

    init(isSetup: Bool = false) {
        self.isSetup = isSetup
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                Spacer()

                // Animated biometric icon
                BiometricIconView(
                    biometricType: viewModel.biometricType,
                    isAnimating: viewModel.isAnimating
                )

                if viewModel.setupComplete {
                    setupCompleteView
                } else if !viewModel.isAvailable {
                    unavailableView
                } else {
                    authenticationView
                }

                Spacer()
            }
            .padding(.horizontal, 24)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if isSetup {
                    ToolbarItem(placement: .principal) {
                        Text("Setup Biometric Auth")
                            .font(.headline)
                    }
                }
            }
        }
        .onAppear {
            viewModel.checkBiometricAvailability()
            viewModel.isSetup = isSetup
        }
    }

    private var authenticationView: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text(isSetup ? "Setup \(viewModel.biometricType.displayName)" : "Biometric Authentication")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text(isSetup
                     ? "Enable \(viewModel.biometricType.displayName.lowercased()) authentication for quick and secure access to your account."
                     : viewModel.biometricType.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Available biometric types (if multiple)
            if viewModel.availableBiometrics.count > 1 {
                BiometricSelectionView(
                    availableBiometrics: viewModel.availableBiometrics,
                    selectedBiometric: $viewModel.selectedBiometric
                )
            }

            if let error = viewModel.error {
                ErrorView(message: error)
            }

            // Security info
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "shield.checkered")
                    .foregroundColor(.blue)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Your biometric data is stored securely on your device and is never shared.")
                        .font(.caption)
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.leading)
                }

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
            )

            // Authenticate button
            Button(action: viewModel.authenticateWithBiometric) {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text(isSetup ? "Enable \(viewModel.biometricType.displayName)" : "Authenticate")
                }
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(viewModel.isLoading)

            // Alternative actions
            if isSetup {
                Button("Skip for Now") {
                    // Navigate to home
                }
                .foregroundColor(.blue)
            } else {
                Button("Use Password Instead") {
                    // Navigate to login
                }
                .buttonStyle(SecondaryButtonStyle())
            }
        }
    }

    private var unavailableView: some View {
        VStack(spacing: 24) {
            // Error icon
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 80))
                .foregroundColor(.orange)

            // Header
            VStack(spacing: 8) {
                Text("Biometric Authentication Unavailable")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text(viewModel.error ?? "Biometric authentication is not available on this device or no biometrics are enrolled.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Instructions
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundColor(.orange)

                    Text("To use biometric authentication:")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)

                    Spacer()
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("• Enable Face ID or Touch ID in device settings")
                    Text("• Make sure at least one biometric is enrolled")
                    Text("• Restart the app after enabling biometrics")
                }
                .font(.caption)
                .foregroundColor(.orange)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.orange.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.orange.opacity(0.3), lineWidth: 1)
            )

            // Actions
            VStack(spacing: 12) {
                Button("Check Again") {
                    viewModel.checkBiometricAvailability()
                }
                .buttonStyle(PrimaryButtonStyle())

                Button(isSetup ? "Skip Setup" : "Use Password Instead") {
                    if isSetup {
                        // Navigate to home
                    } else {
                        // Navigate to login
                    }
                }
                .buttonStyle(SecondaryButtonStyle())
            }
        }
    }

    private var setupCompleteView: some View {
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
                Text("Biometric Authentication Enabled!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text("You can now use \(viewModel.biometricType.displayName.lowercased()) to quickly and securely access your account.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Features info
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.green)

                    Text("Biometric Authentication Features:")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)

                    Spacer()
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("• Quick and secure login")
                    Text("• No need to remember passwords")
                    Text("• Your biometric data stays on your device")
                    Text("• Can be disabled anytime in settings")
                }
                .font(.caption)
                .foregroundColor(.green)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.green.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.green.opacity(0.3), lineWidth: 1)
            )

            // Actions
            VStack(spacing: 12) {
                Button("Continue to App") {
                    // Navigate to home
                }
                .buttonStyle(PrimaryButtonStyle())

                Button("Test Biometric Login") {
                    viewModel.authenticateWithBiometric()
                }
                .buttonStyle(SecondaryButtonStyle())
            }
        }
    }
}

class BiometricAuthViewModel: ObservableObject {
    @Published var isAvailable = false
    @Published var biometricType: BiometricType = .none
    @Published var availableBiometrics: [BiometricType] = []
    @Published var selectedBiometric: BiometricType = .none
    @Published var isLoading = false
    @Published var setupComplete = false
    @Published var error: String?
    @Published var isAnimating = false

    var isSetup = false

    private let context = LAContext()

    func checkBiometricAvailability() {
        var error: NSError?

        if context.canEvaluatePolicy(.biometryAny, error: &error) {
            isAvailable = true

            switch context.biometryType {
            case .faceID:
                biometricType = .faceID
                availableBiometrics = [.faceID]
                selectedBiometric = .faceID
            case .touchID:
                biometricType = .touchID
                availableBiometrics = [.touchID]
                selectedBiometric = .touchID
            case .opticID:
                biometricType = .opticID
                availableBiometrics = [.opticID]
                selectedBiometric = .opticID
            default:
                biometricType = .none
                isAvailable = false
            }

            startAnimation()
        } else {
            isAvailable = false
            handleBiometricError(error)
        }
    }

    func authenticateWithBiometric() {
        guard isAvailable else { return }

        isLoading = true
        error = nil

        let reason = isSetup ? "Enable biometric authentication for your account" : "Authenticate to continue"

        context.evaluatePolicy(.biometryAny, localizedReason: reason) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isLoading = false

                if success {
                    if self?.isSetup == true {
                        self?.setupComplete = true
                    } else {
                        // Navigate to home
                    }
                } else if let error = error as? LAError {
                    self?.handleLAError(error)
                }
            }
        }
    }

    private func handleBiometricError(_ error: NSError?) {
        guard let error = error as? LAError else {
            self.error = "Biometric authentication is not available"
            return
        }

        handleLAError(error)
    }

    private func handleLAError(_ error: LAError) {
        switch error.code {
        case .biometryNotAvailable:
            self.error = "Biometric authentication is not available"
        case .biometryNotEnrolled:
            self.error = "No biometrics enrolled on this device"
        case .biometryLockout:
            self.error = "Too many failed attempts. Try again later"
        case .userCancel:
            self.error = "Authentication was cancelled"
        case .userFallback:
            self.error = "User selected fallback authentication"
        case .systemCancel:
            self.error = "System cancelled authentication"
        default:
            self.error = "Authentication failed. Please try again"
        }
    }

    private func startAnimation() {
        isAnimating = true

        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { [weak self] _ in
            self?.isAnimating.toggle()
        }
    }
}

enum BiometricType {
    case faceID
    case touchID
    case opticID
    case none

    var displayName: String {
        switch self {
        case .faceID:
            return "Face ID"
        case .touchID:
            return "Touch ID"
        case .opticID:
            return "Optic ID"
        case .none:
            return "Biometric"
        }
    }

    var icon: String {
        switch self {
        case .faceID:
            return "faceid"
        case .touchID:
            return "touchid"
        case .opticID:
            return "opticid"
        case .none:
            return "person.crop.circle.fill"
        }
    }

    var description: String {
        switch self {
        case .faceID:
            return "Use your face to authenticate"
        case .touchID:
            return "Use your fingerprint to authenticate"
        case .opticID:
            return "Use your eyes to authenticate"
        case .none:
            return "Use biometric authentication"
        }
    }
}

struct BiometricIconView: View {
    let biometricType: BiometricType
    let isAnimating: Bool

    var body: some View {
        Image(systemName: biometricType.icon)
            .font(.system(size: 120))
            .foregroundColor(.blue)
            .scaleEffect(isAnimating ? 1.1 : 1.0)
            .opacity(isAnimating ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
    }
}

struct BiometricSelectionView: View {
    let availableBiometrics: [BiometricType]
    @Binding var selectedBiometric: BiometricType

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Available Authentication Methods:")
                .font(.subheadline)
                .fontWeight(.semibold)

            VStack(spacing: 8) {
                ForEach(availableBiometrics, id: \.displayName) { biometric in
                    HStack {
                        Button(action: {
                            selectedBiometric = biometric
                        }) {
                            HStack {
                                Image(systemName: selectedBiometric.displayName == biometric.displayName ? "largecircle.fill.circle" : "circle")
                                    .foregroundColor(.blue)

                                Image(systemName: biometric.icon)
                                    .foregroundColor(.primary)

                                Text(biometric.displayName)
                                    .foregroundColor(.primary)

                                Spacer()
                            }
                        }
                    }
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

#Preview {
    BiometricAuthScreen(isSetup: true)
}