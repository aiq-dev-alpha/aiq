import SwiftUI
import Combine

struct ForgotPasswordScreen: View {
    @StateObject private var viewModel = ForgotPasswordViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                Spacer()

                // Icon
                Image(systemName: "lock.rotation")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)

                // Header
                VStack(spacing: 8) {
                    Text("Forgot Password?")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Enter your email address and we'll send you a link to reset your password.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }

                if viewModel.emailSent {
                    successView
                } else {
                    emailInputView
                }

                Spacer()
            }
            .padding(.horizontal, 24)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }

    private var emailInputView: some View {
        VStack(spacing: 24) {
            // Email input
            VStack(alignment: .leading, spacing: 8) {
                TextField("Email Address", text: $viewModel.email)
                    .textFieldStyle(CustomTextFieldStyle(icon: "envelope"))
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)

                Text("We'll send a reset link to this email")
                    .font(.caption)
                    .foregroundColor(.secondary)

                if let error = viewModel.emailError {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }

            if let error = viewModel.error {
                ErrorView(message: error)
            }

            // Send button
            Button(action: viewModel.sendResetLink) {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Send Reset Link")
                }
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(viewModel.isLoading || !viewModel.isValidEmail)

            // Back button
            Button("Back to Sign In") {
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(.blue)
        }
    }

    private var successView: some View {
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

            VStack(spacing: 16) {
                Text("Check Your Email")
                    .font(.title2)
                    .fontWeight(.bold)

                VStack(spacing: 8) {
                    Text("We've sent a password reset link to:")
                        .font(.body)
                        .foregroundColor(.secondary)

                    Text(viewModel.email)
                        .font(.body)
                        .fontWeight(.semibold)
                }

                // Info box
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "info.circle")
                        .foregroundColor(.blue)

                    Text("Didn't receive the email? Check your spam folder or try again.")
                        .font(.caption)
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                )
            }

            VStack(spacing: 12) {
                Button(action: viewModel.resendEmail) {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Resend Email")
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(viewModel.isLoading)

                Button("Back to Sign In") {
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(SecondaryButtonStyle())

                Button("Use Different Email") {
                    viewModel.emailSent = false
                    viewModel.email = ""
                }
                .foregroundColor(.blue)
                .padding(.top, 16)
            }
        }
    }
}

class ForgotPasswordViewModel: ObservableObject {
    @Published var email = ""
    @Published var isLoading = false
    @Published var emailSent = false
    @Published var error: String?
    @Published var emailError: String?

    private var cancellables = Set<AnyCancellable>()

    var isValidEmail: Bool {
        let emailRegex = #"^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    init() {
        setupValidation()
    }

    private func setupValidation() {
        $email
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] value in
                if !value.isEmpty && !self?.isValidEmail ?? true {
                    self?.emailError = "Enter a valid email"
                } else {
                    self?.emailError = nil
                }
            }
            .store(in: &cancellables)
    }

    func sendResetLink() {
        guard isValidEmail else { return }

        isLoading = true
        error = nil

        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
            self.emailSent = true
        }
    }

    func resendEmail() {
        isLoading = true
        error = nil

        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
            // Show success message
        }
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Color.clear)
            .foregroundColor(.blue)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue, lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    ForgotPasswordScreen()
}