import SwiftUI
import AuthenticationServices

enum SocialProvider: CaseIterable {
    case google
    case apple
    case facebook
    case microsoft
    case twitter
    case github

    var displayName: String {
        switch self {
        case .google: return "Google"
        case .apple: return "Apple"
        case .facebook: return "Facebook"
        case .microsoft: return "Microsoft"
        case .twitter: return "Twitter"
        case .github: return "GitHub"
        }
    }

    var icon: String {
        switch self {
        case .google: return "globe"
        case .apple: return "apple.logo"
        case .facebook: return "f.circle"
        case .microsoft: return "window.ceiling.closed"
        case .twitter: return "at.circle"
        case .github: return "terminal"
        }
    }

    var color: Color {
        switch self {
        case .google: return Color(red: 0.859, green: 0.267, blue: 0.216)
        case .apple: return .black
        case .facebook: return Color(red: 0.259, green: 0.404, blue: 0.698)
        case .microsoft: return Color(red: 0.0, green: 0.471, blue: 0.831)
        case .twitter: return Color(red: 0.114, green: 0.631, blue: 0.949)
        case .github: return .black
        }
    }
}

struct SocialLoginScreen: View {
    @StateObject private var viewModel = SocialLoginViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    Spacer()
                        .frame(height: 60)

                    // App logo
                    AppLogoView()

                    // Header
                    VStack(spacing: 8) {
                        Text("Welcome Back")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("Choose your preferred sign-in method")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    if let error = viewModel.error {
                        ErrorView(message: error)
                    }

                    // Social login buttons
                    VStack(spacing: 12) {
                        ForEach(SocialProvider.allCases, id: \.displayName) { provider in
                            SocialLoginButton(
                                provider: provider,
                                isLoading: viewModel.isLoading && viewModel.loadingProvider == provider
                            ) {
                                viewModel.signIn(with: provider)
                            }
                        }
                    }

                    // Divider
                    HStack {
                        Rectangle()
                            .fill(Color(.systemGray4))
                            .frame(height: 1)

                        Text("OR")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 16)

                        Rectangle()
                            .fill(Color(.systemGray4))
                            .frame(height: 1)
                    }

                    // Email login button
                    Button(action: {
                        // Navigate to email login
                    }) {
                        Text("Sign in with Email")
                            .fontWeight(.semibold)
                    }
                    .buttonStyle(PrimaryButtonStyle())

                    // Privacy notice
                    PrivacyNoticeView()

                    // Sign up link
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(.secondary)

                        Button("Sign Up") {
                            // Navigate to signup
                        }
                        .foregroundColor(.blue)
                    }

                    // Terms and privacy
                    TermsAndPrivacyView()

                    Spacer()
                        .frame(height: 40)
                }
                .padding(.horizontal, 24)
            }
        }
        .navigationBarHidden(true)
    }
}

class SocialLoginViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var loadingProvider: SocialProvider?
    @Published var error: String?

    func signIn(with provider: SocialProvider) {
        isLoading = true
        loadingProvider = provider
        error = nil

        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
            self.loadingProvider = nil

            // Handle success/error
            // Navigate to home on success
        }
    }
}

struct SocialLoginButton: View {
    let provider: SocialProvider
    let isLoading: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: provider.color))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: provider.icon)
                        .foregroundColor(provider.color)
                        .frame(width: 20, height: 20)
                }

                Text("Continue with \(provider.displayName)")
                    .fontWeight(.medium)
                    .foregroundColor(.primary)

                Spacer()
            }
            .frame(height: 56)
            .padding(.horizontal, 16)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
            .cornerRadius(12)
        }
        .disabled(isLoading)
    }
}

struct AppleSignInButton: View {
    let isLoading: Bool
    let action: () -> Void

    var body: some View {
        SignInWithAppleButton(.signIn) { request in
            request.requestedScopes = [.fullName, .email]
        } onCompletion: { result in
            switch result {
            case .success(let authorization):
                // Handle successful authorization
                action()
            case .failure(let error):
                // Handle error
                print("Apple Sign In failed: \(error)")
            }
        }
        .signInWithAppleButtonStyle(.black)
        .frame(height: 56)
        .cornerRadius(12)
        .disabled(isLoading)
    }
}

struct AppLogoView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [.blue, .purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: 80, height: 80)

            Image(systemName: "person.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(.white)
        }
        .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

struct PrivacyNoticeView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "shield.checkered")
                .foregroundColor(.blue)
                .font(.title2)

            VStack(alignment: .leading, spacing: 4) {
                Text("Your Privacy Matters")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)

                Text("We use secure authentication and never store your social media passwords.")
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
    }
}

struct TermsAndPrivacyView: View {
    var body: some View {
        Text("By continuing, you agree to our **Terms of Service** and **Privacy Policy**")
            .font(.caption)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 16)
    }
}

// Compact social login component for use in other screens
struct CompactSocialLogin: View {
    let onProviderSelected: (SocialProvider) -> Void
    let isLoading: Bool

    private let mainProviders: [SocialProvider] = [.google, .apple, .facebook]

    var body: some View {
        VStack(spacing: 24) {
            // Divider
            HStack {
                Rectangle()
                    .fill(Color(.systemGray4))
                    .frame(height: 1)

                Text("OR")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 16)

                Rectangle()
                    .fill(Color(.systemGray4))
                    .frame(height: 1)
            }

            // Social buttons row
            HStack(spacing: 12) {
                ForEach(mainProviders, id: \.displayName) { provider in
                    CompactSocialButton(
                        provider: provider,
                        isLoading: isLoading
                    ) {
                        onProviderSelected(provider)
                    }
                }
            }
        }
    }
}

struct CompactSocialButton: View {
    let provider: SocialProvider
    let isLoading: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .frame(height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )

                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: provider.color))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: provider.icon)
                        .foregroundColor(provider.color)
                        .font(.title2)
                }
            }
        }
        .disabled(isLoading)
    }
}

// Alternative full-width social buttons
struct FullWidthSocialLogin: View {
    let providers: [SocialProvider]
    let onProviderSelected: (SocialProvider) -> Void
    let isLoading: Bool
    let loadingProvider: SocialProvider?

    var body: some View {
        VStack(spacing: 12) {
            ForEach(providers, id: \.displayName) { provider in
                Button(action: {
                    onProviderSelected(provider)
                }) {
                    HStack(spacing: 12) {
                        Group {
                            if isLoading && loadingProvider == provider {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: provider.icon)
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(width: 20, height: 20)

                        Text("Continue with \(provider.displayName)")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)

                        Spacer()
                    }
                    .frame(height: 56)
                    .padding(.horizontal, 16)
                    .background(provider.color)
                    .cornerRadius(12)
                }
                .disabled(isLoading)
            }
        }
    }
}

#Preview {
    SocialLoginScreen()
}

#Preview("Compact Social Login") {
    VStack {
        CompactSocialLogin(
            onProviderSelected: { _ in },
            isLoading: false
        )
    }
    .padding()
}