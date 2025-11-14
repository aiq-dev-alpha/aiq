import SwiftUI
import Combine

struct OTPVerificationScreen: View {
    let phoneNumber: String
    let email: String
    @StateObject private var viewModel = OTPVerificationViewModel()
    @Environment(\.presentationMode) var presentationMode

    init(phoneNumber: String = "", email: String = "") {
        self.phoneNumber = phoneNumber
        self.email = email
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                Spacer()

                // Icon
                Image(systemName: "smartphone")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)

                // Header
                VStack(spacing: 8) {
                    Text("Verify Your Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("We've sent a 6-digit code to\n\(!phoneNumber.isEmpty ? phoneNumber : email)")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }

                // OTP Input
                OTPInputView(otp: $viewModel.otp, isEnabled: !viewModel.isLoading)
                    .onChange(of: viewModel.otp) { newValue in
                        if newValue.count == 6 {
                            viewModel.verifyOTP()
                        }
                    }

                if let error = viewModel.error {
                    ErrorView(message: error)
                }

                // Resend section
                HStack {
                    Text("Didn't receive the code?")
                        .font(.body)
                        .foregroundColor(.secondary)

                    if viewModel.canResend {
                        Button("Resend") {
                            viewModel.resendOTP()
                        }
                        .foregroundColor(.blue)
                        .disabled(viewModel.isLoading)
                    } else {
                        Text("Resend in \(viewModel.countdown)s")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }

                // Verify button
                Button(action: viewModel.verifyOTP) {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Verify OTP")
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(viewModel.otp.count != 6 || viewModel.isLoading)

                // Info box
                VStack(spacing: 8) {
                    Image(systemName: "info.circle")
                        .foregroundColor(.blue)

                    Text("Enter the 6-digit code sent to your \(!phoneNumber.isEmpty ? "phone" : "email"). The code expires in 10 minutes.")
                        .font(.caption)
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                )

                Spacer()

                // Change number/email
                Button("Change \(!phoneNumber.isEmpty ? "Phone Number" : "Email")") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.blue)
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
        .onAppear {
            viewModel.startCountdown()
        }
    }
}

struct OTPInputView: View {
    @Binding var otp: String
    let isEnabled: Bool
    @FocusState private var focusedField: Int?

    private let otpLength = 6

    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<otpLength, id: \.self) { index in
                OTPDigitView(
                    digit: digitAt(index),
                    isFocused: focusedField == index,
                    isEnabled: isEnabled
                )
                .focused($focusedField, equals: index)
                .onChange(of: otp) { newValue in
                    updateFocus(for: newValue)
                }
                .onTapGesture {
                    focusedField = index
                }
            }
        }
        .onAppear {
            focusedField = 0
        }
    }

    private func digitAt(_ index: Int) -> String {
        guard index < otp.count else { return "" }
        let digitIndex = otp.index(otp.startIndex, offsetBy: index)
        return String(otp[digitIndex])
    }

    private func updateFocus(for newValue: String) {
        if newValue.count <= otpLength {
            focusedField = min(newValue.count, otpLength - 1)
        }
    }
}

struct OTPDigitView: View {
    let digit: String
    let isFocused: Bool
    let isEnabled: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
                .frame(width: 50, height: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isFocused ? Color.blue : Color(.systemGray4), lineWidth: isFocused ? 2 : 1)
                )

            Text(digit)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(isEnabled ? .primary : .secondary)
        }
    }
}

class OTPVerificationViewModel: ObservableObject {
    @Published var otp = ""
    @Published var isLoading = false
    @Published var error: String?
    @Published var canResend = false
    @Published var countdown = 30

    private var timer: Timer?

    func startCountdown() {
        canResend = false
        countdown = 30

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            if self.countdown > 0 {
                self.countdown -= 1
            } else {
                self.canResend = true
                self.timer?.invalidate()
                self.timer = nil
            }
        }
    }

    func verifyOTP() {
        guard otp.count == 6 else { return }

        isLoading = true
        error = nil

        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false

            if self.otp == "123456" {
                // Success - navigate to next screen
            } else {
                self.error = "Invalid OTP. Please check and try again."
                self.otp = ""
            }
        }
    }

    func resendOTP() {
        guard canResend else { return }

        isLoading = true
        error = nil

        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
            self.startCountdown()
        }
    }

    deinit {
        timer?.invalidate()
    }
}

// Custom OTP TextField that handles single digit input
struct OTPTextField: UIViewRepresentable {
    @Binding var text: String
    let index: Int
    let maxLength: Int
    let onEditingChanged: (Int, String) -> Void

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.backgroundColor = UIColor.systemGray6

        // Add toolbar with done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: context.coordinator, action: #selector(Coordinator.dismissKeyboard))
        toolbar.setItems([doneButton], animated: false)
        textField.inputAccessoryView = toolbar

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        let parent: OTPTextField

        init(_ parent: OTPTextField) {
            self.parent = parent
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)

            // Only allow digits
            if !string.isEmpty && !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) {
                return false
            }

            // Limit to single digit
            if newText.count <= 1 {
                parent.text = newText
                parent.onEditingChanged(parent.index, newText)
                return true
            }

            return false
        }

        @objc func dismissKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

#Preview {
    OTPVerificationScreen(phoneNumber: "+1 (555) 123-4567")
}