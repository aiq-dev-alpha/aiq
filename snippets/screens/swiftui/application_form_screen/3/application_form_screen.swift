import SwiftUI

struct ApplicationFormScreen: View {
    @State private var selectedTab = 0
    @State private var isSubmitting = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    // Personal Information
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var address = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zipCode = ""
    @State private var dateOfBirth = Date()
    @State private var ssn = ""

    // Professional Information
    @State private var currentEmployer = ""
    @State private var jobTitle = ""
    @State private var annualIncome = ""
    @State private var yearsEmployed = ""
    @State private var employmentStatus = "Full-time"
    @State private var educationLevel = "High School"

    // Documents & Consent
    @State private var reference1Name = ""
    @State private var reference1Phone = ""
    @State private var reference2Name = ""
    @State private var reference2Phone = ""
    @State private var backgroundCheckConsent = false
    @State private var drugTestConsent = false

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                // Tab selector
                Picker("Section", selection: $selectedTab) {
                    Text("Personal").tag(0)
                    Text("Professional").tag(1)
                    Text("Documents").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                TabView(selection: $selectedTab) {
                    personalTab.tag(0)
                    professionalTab.tag(1)
                    documentsTab.tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                Button(action: submitApplication) {
                    HStack {
                        if isSubmitting {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "paperplane.fill")
                        }
                        Text("Submit Application")
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                }
                .disabled(isSubmitting || !isFormValid())
                .buttonStyle(PrimaryButtonStyle())
                .padding()
            }
            .navigationTitle("Job Application")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Application Submitted!"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("Done")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
        }
    }

    private var personalTab: some View {
        Form {
            Section(header: Text("Basic Information")) {
                HStack {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                }
                TextField("Email Address", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                TextField("Phone Number", text: $phone)
                    .keyboardType(.phonePad)
                DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                TextField("SSN (123-45-6789)", text: $ssn)
                    .keyboardType(.numberPad)
            }

            Section(header: Text("Address")) {
                TextField("Street Address", text: $address)
                HStack {
                    TextField("City", text: $city)
                    TextField("State", text: $state)
                    TextField("ZIP", text: $zipCode)
                        .keyboardType(.numberPad)
                }
            }
        }
    }

    private var professionalTab: some View {
        Form {
            Section(header: Text("Employment")) {
                Picker("Employment Status", selection: $employmentStatus) {
                    Text("Full-time").tag("Full-time")
                    Text("Part-time").tag("Part-time")
                    Text("Contract").tag("Contract")
                    Text("Unemployed").tag("Unemployed")
                }
                .pickerStyle(MenuPickerStyle())

                TextField("Current Employer", text: $currentEmployer)
                TextField("Job Title", text: $jobTitle)
                TextField("Annual Income", text: $annualIncome)
                    .keyboardType(.numberPad)
                TextField("Years Employed", text: $yearsEmployed)
                    .keyboardType(.numberPad)
            }

            Section(header: Text("Education")) {
                Picker("Education Level", selection: $educationLevel) {
                    Text("High School").tag("High School")
                    Text("Associate Degree").tag("Associate Degree")
                    Text("Bachelor's Degree").tag("Bachelor's Degree")
                    Text("Master's Degree").tag("Master's Degree")
                    Text("Doctorate").tag("Doctorate")
                }
                .pickerStyle(MenuPickerStyle())
            }
        }
    }

    private var documentsTab: some View {
        Form {
            Section(header: Text("References")) {
                VStack(alignment: .leading) {
                    Text("Reference 1")
                        .font(.headline)
                    TextField("Full Name", text: $reference1Name)
                    TextField("Phone Number", text: $reference1Phone)
                        .keyboardType(.phonePad)
                }

                VStack(alignment: .leading) {
                    Text("Reference 2")
                        .font(.headline)
                    TextField("Full Name", text: $reference2Name)
                    TextField("Phone Number", text: $reference2Phone)
                        .keyboardType(.phonePad)
                }
            }

            Section(header: Text("Consent Forms")) {
                Toggle("Background Check Consent", isOn: $backgroundCheckConsent)
                Toggle("Drug Test Consent", isOn: $drugTestConsent)
            }
        }
    }

    private func isFormValid() -> Bool {
        return !firstName.isEmpty &&
               !lastName.isEmpty &&
               !email.isEmpty &&
               !phone.isEmpty &&
               !address.isEmpty &&
               backgroundCheckConsent &&
               drugTestConsent &&
               isValidEmail(email)
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    private func submitApplication() {
        guard isFormValid() else { return }

        isSubmitting = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isSubmitting = false
            alertMessage = "Thank you for your application. We have received your information and will review it shortly.\n\nApplication ID: APP-2024-001234"
            showAlert = true
        }
    }
}

struct ApplicationFormScreen_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationFormScreen()
    }
}