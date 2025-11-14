import SwiftUI
import Combine

struct SignupScreen: View {
    @StateObject private var viewModel = SignupViewModel()
    @State private var acceptTerms = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Spacer()
                        .frame(height: 40)

                    // Header
                    VStack(spacing: 8) {
                        Text("Create Account")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("Sign up to get started")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 40)

                    // Form
                    VStack(spacing: 16) {
                        // Name fields
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 8) {
                                TextField("First Name", text: $viewModel.firstName)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .textContentType(.givenName)
                                    .autocorrectionDisabled()

                                if let error = viewModel.firstNameError {
                                    Text(error)
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                TextField("Last Name", text: $viewModel.lastName)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .textContentType(.familyName)
                                    .autocorrectionDisabled()

                                if let error = viewModel.lastNameError {
                                    Text(error)
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                            }
                        }

                        // Email field
                        VStack(alignment: .leading, spacing: 8) {
                            TextField("Email", text: $viewModel.email)
                                .textFieldStyle(CustomTextFieldStyle(icon: "envelope"))
                                .keyboardType(.emailAddress)
                                .textContentType(.emailAddress)
                                .autocorrectionDisabled()
                                .autocapitalization(.none)

                            if let error = viewModel.emailError {
                                Text(error)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }

                        // Password field
                        VStack(alignment: .leading, spacing: 8) {
                            SecureField("Password", text: $viewModel.password)
                                .textFieldStyle(CustomTextFieldStyle(icon: "lock"))
                                .textContentType(.newPassword)

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
                            SecureField("Confirm Password", text: $viewModel.confirmPassword)
                                .textFieldStyle(CustomTextFieldStyle(icon: "lock"))
                                .textContentType(.newPassword)

                            if let error = viewModel.confirmPasswordError {
                                Text(error)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                    }

                    // Terms and conditions
                    VStack(spacing: 16) {
                        HStack(alignment: .top, spacing: 12) {
                            Button(action: {
                                acceptTerms.toggle()
                            }) {
                                Image(systemName: acceptTerms ? "checkmark.square.fill" : "square")
                                    .foregroundColor(acceptTerms ? .blue : .secondary)
                            }

                            Text("I accept the **Terms and Conditions** and **Privacy Policy**")
                                .font(.caption)
                                .multilineTextAlignment(.leading)
                        }

                        if let error = viewModel.error {
                            ErrorView(message: error)
                        }
                    }

                    // Sign up button
                    Button(action: {
                        if acceptTerms {
                            viewModel.signUp()
                        } else {
                            viewModel.error = "Please accept the terms and conditions"
                        }
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Sign Up")
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(viewModel.isLoading || !viewModel.isFormValid || !acceptTerms)

                    // Sign in link
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(.secondary)

                        Button("Sign In") {
                            // Navigate to login
                        }
                    }
                    .padding(.top, 24)

                    Spacer()
                        .frame(height: 40)
                }
                .padding(.horizontal, 24)
            }
        }
        .navigationBarHidden(true)
    }
}

class SignupViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isLoading = false
    @Published var error: String?

    // Validation errors
    @Published var firstNameError: String?
    @Published var lastNameError: String?
    @Published var emailError: String?
    @Published var passwordError: String?
    @Published var confirmPasswordError: String?

    private var cancellables = Set<AnyCancellable>()

    var isFormValid: Bool {
        return !firstName.isEmpty &&
               !lastName.isEmpty &&
               isValidEmail(email) &&
               isValidPassword(password) &&
               password == confirmPassword
    }

    init() {
        setupValidation()
    }

    private func setupValidation() {
        // Real-time validation
        $firstName
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] value in
                self?.firstNameError = value.isEmpty ? "First name is required" : nil
            }
            .store(in: &cancellables)

        $lastName
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] value in
                self?.lastNameError = value.isEmpty ? "Last name is required" : nil
            }
            .store(in: &cancellables)

        $email
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] value in
                if !value.isEmpty && !self?.isValidEmail(value) ?? true {
                    self?.emailError = "Enter a valid email"
                } else {
                    self?.emailError = nil
                }
            }
            .store(in: &cancellables)

        $password
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] value in
                if !value.isEmpty && !self?.isValidPassword(value) ?? true {
                    self?.passwordError = "Password must be at least 8 characters with uppercase, lowercase, and number"
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

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    private func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8 &&
               password.range(of: "[A-Z]", options: .regularExpression) != nil &&
               password.range(of: "[a-z]", options: .regularExpression) != nil &&
               password.range(of: "[0-9]", options: .regularExpression) != nil
    }

    func signUp() {
        guard isFormValid else { return }

        isLoading = true
        error = nil

        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
            // Handle success/failure
            // Navigate to home or show error
        }
    }
}

struct PasswordStrengthView: View {
    let password: String

    private var strength: PasswordStrength {
        var score = 0

        if password.count >= 8 { score += 1 }
        if password.range(of: "[A-Z]", options: .regularExpression) != nil { score += 1 }
        if password.range(of: "[a-z]", options: .regularExpression) != nil { score += 1 }
        if password.range(of: "[0-9]", options: .regularExpression) != nil { score += 1 }
        if password.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil { score += 1 }

        switch score {
        case 0...1: return .weak
        case 2...3: return .medium
        default: return .strong
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ProgressView(value: Double(strength.rawValue), total: 3.0)
                .progressViewStyle(LinearProgressViewStyle(tint: strength.color))
                .frame(height: 4)

            Text("Password strength: \(strength.text)")
                .font(.caption)
                .foregroundColor(strength.color)
        }
    }
}

enum PasswordStrength: Int {
    case weak = 1
    case medium = 2
    case strong = 3

    var text: String {
        switch self {
        case .weak: return "Weak"
        case .medium: return "Medium"
        case .strong: return "Strong"
        }
    }

    var color: Color {
        switch self {
        case .weak: return .red
        case .medium: return .orange
        case .strong: return .green
        }
    }
}

// Custom styles
struct CustomTextFieldStyle: TextFieldStyle {
    let icon: String?

    init(icon: String? = nil) {
        self.icon = icon
    }

    func _body(configuration: TextField<_Label>) -> some View {
        HStack {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(.secondary)
                    .frame(width: 20)
            }

            configuration
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(configuration.isPressed ? Color.blue.opacity(0.8) : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct ErrorView: View {
    let message: String

    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.circle")
                .foregroundColor(.red)

            Text(message)
                .font(.caption)
                .foregroundColor(.red)
                .multilineTextAlignment(.leading)

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.red.opacity(0.1))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.red.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    SignupScreen()
}