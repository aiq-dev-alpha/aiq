import SwiftUI
import Combine

struct ResetPasswordScreen: View {
    let token: String?
    @StateObject private var viewModel = ResetPasswordViewModel()
    @State private var showingAlert = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    Spacer()
                        .frame(height: 40)

                    // Icon
                    Image(systemName: "lock.rotation")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)

                    if viewModel.passwordReset {
                        successView
                    } else {
                        resetFormView
                    }

                    Spacer()
                        .frame(height: 40)
                }
                .padding(.horizontal, 24)
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            viewModel.validateToken(token)
        }
        .alert("Invalid Token", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("The reset link is invalid or has expired. Please request a new one.")
        }
    }

    private var resetFormView: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Create New Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Enter a new password for your account.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            if let error = viewModel.error {
                ErrorView(message: error)
            }

            VStack(spacing: 16) {
                // New password field
                VStack(alignment: .leading, spacing: 8) {
                    SecureField("New Password", text: $viewModel.password)
                        .textFieldStyle(CustomTextFieldStyle(icon: "lock"))
                        .textContentType(.newPassword)

                    Text("At least 8 characters with uppercase, lowercase, number, and special character")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    if let error = viewModel.passwordError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    } else if !viewModel.password.isEmpty {
                        PasswordStrengthView(password: viewModel.password)
                    }
                }

                // Confirm password field
                VStack(alignment: .leading, spacing: 8) {
                    SecureField("Confirm New Password", text: $viewModel.confirmPassword)
                        .textFieldStyle(CustomTextFieldStyle(icon: "lock"))
                        .textContentType(.newPassword)

                    if let error = viewModel.confirmPasswordError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }

            // Password requirements
            PasswordRequirementsView(password: viewModel.password)

            // Reset button
            Button(action: viewModel.resetPassword) {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Reset Password")
                }
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(viewModel.isLoading || !viewModel.isFormValid)

            // Back button
            Button("Back to Sign In") {
                // Navigate to login
            }
            .foregroundColor(.blue)
        }
    }

    private var successView: some View {
        VStack(spacing: 32) {
            // Success icon
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.1))
                    .frame(width: 120, height: 120)

                Image(systemName: "checkmark.circle")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
            }

            VStack(spacing: 16) {
                Text("Password Reset Successfully!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text("Your password has been reset successfully. You can now sign in with your new password.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            Button("Continue to Sign In") {
                // Navigate to login
            }
            .buttonStyle(PrimaryButtonStyle())
        }
    }
}

class ResetPasswordViewModel: ObservableObject {
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isLoading = false
    @Published var passwordReset = false
    @Published var error: String?

    // Validation errors
    @Published var passwordError: String?
    @Published var confirmPasswordError: String?

    private var cancellables = Set<AnyCancellable>()
    private var validToken = false

    var isFormValid: Bool {
        return isValidPassword(password) && password == confirmPassword && validToken
    }

    init() {
        setupValidation()
    }

    private func setupValidation() {
        $password
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] value in
                if !value.isEmpty && !self?.isValidPassword(value) ?? true {
                    self?.passwordError = "Password must meet all requirements"
                } else {
                    self?.passwordError = nil
                }
            }
            .store(in: &cancellables)

        $confirmPassword
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] value in
                if !value.isEmpty && value != self?.password {
                    self?.confirmPasswordError = "Passwords do not match"
                } else {
                    self?.confirmPasswordError = nil
                }
            }
            .store(in: &cancellables)
    }

    private func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8 &&
               password.range(of: "[A-Z]", options: .regularExpression) != nil &&
               password.range(of: "[a-z]", options: .regularExpression) != nil &&
               password.range(of: "[0-9]", options: .regularExpression) != nil &&
               password.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil
    }

    func validateToken(_ token: String?) {
        guard let token = token, !token.isEmpty else {
            error = "Invalid or expired reset link"
            validToken = false
            return
        }

        validToken = true
    }

    func resetPassword() {
        guard isFormValid else { return }

        isLoading = true
        error = nil

        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
            self.passwordReset = true
        }
    }
}

struct PasswordRequirementsView: View {
    let password: String

    private var requirements: [RequirementItem] {
        [
            RequirementItem(
                text: "At least 8 characters long",
                isMet: password.count >= 8
            ),
            RequirementItem(
                text: "Contains uppercase and lowercase letters",
                isMet: password.range(of: "[A-Z]", options: .regularExpression) != nil &&
                       password.range(of: "[a-z]", options: .regularExpression) != nil
            ),
            RequirementItem(
                text: "Contains at least one number",
                isMet: password.range(of: "[0-9]", options: .regularExpression) != nil
            ),
            RequirementItem(
                text: "Contains at least one special character",
                isMet: password.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil
            )
        ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "shield.checkerboard")
                    .foregroundColor(.blue)

                Text("Password Requirements:")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)

                Spacer()
            }

            VStack(alignment: .leading, spacing: 8) {
                ForEach(requirements, id: \.text) { requirement in
                    HStack(spacing: 8) {
                        Image(systemName: requirement.isMet ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(requirement.isMet ? .green : .secondary)
                            .font(.caption)

                        Text(requirement.text)
                            .font(.caption)
                            .foregroundColor(requirement.isMet ? .green : .secondary)

                        Spacer()
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.blue.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
        )
    }
}

struct RequirementItem {
    let text: String
    let isMet: Bool
}

#Preview {
    ResetPasswordScreen(token: "sample-token")
}