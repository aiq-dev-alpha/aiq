import SwiftUI

struct SetupProfileScreen: View {
    @State private var fullName: String = ""
    @State private var bio: String = ""
    @State private var selectedAvatar: String = "👤"
    @State private var selectedAgeRange: Int = 0
    @State private var selectedOccupation: String = ""
    @State private var isLoading: Bool = false

    @State private var contentOpacity: Double = 0
    @State private var contentOffset: CGFloat = 30

    private let avatars = ["👤", "👨", "👩", "🧑", "👴", "👵", "🤵", "👩‍💼"]
    private let ageRanges = ["18-24", "25-34", "35-44", "45-54", "55-64", "65+"]
    private let occupations = [
        "Student", "Software Developer", "Data Scientist", "Researcher",
        "Teacher/Professor", "Business Analyst", "Product Manager", "Designer",
        "Entrepreneur", "Other"
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.39, green: 0.40, blue: 0.95),
                                            Color(red: 0.55, green: 0.36, blue: 0.96)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 48, height: 48)

                            Image(systemName: "person.badge.plus")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Create Your Profile")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.22))

                            Text("Tell us about yourself")
                                .font(.system(size: 14))
                                .foregroundColor(Color(red: 0.42, green: 0.45, blue: 0.50))
                        }

                        Spacer()
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 40)

                VStack(spacing: 24) {
                    // Avatar selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Choose Avatar")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.22))

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(avatars, id: \.self) { avatar in
                                    AvatarButton(
                                        avatar: avatar,
                                        isSelected: selectedAvatar == avatar,
                                        onTap: { selectedAvatar = avatar }
                                    )
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                    }

                    // Form fields
                    VStack(spacing: 16) {
                        // Name field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Full Name")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(red: 0.37, green: 0.41, blue: 0.51))

                            HStack {
                                Image(systemName: "person")
                                    .foregroundColor(Color(red: 0.61, green: 0.64, blue: 0.69))

                                TextField("Enter your full name", text: $fullName)
                                    .textFieldStyle(PlainTextFieldStyle())
                            }
                            .padding()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.90, green: 0.91, blue: 0.92), lineWidth: 1)
                            )
                        }

                        // Age range selection
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Age Range")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(red: 0.37, green: 0.41, blue: 0.51))

                            Menu {
                                ForEach(Array(ageRanges.enumerated()), id: \.offset) { index, range in
                                    Button(range) {
                                        selectedAgeRange = index
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(ageRanges[selectedAgeRange])
                                        .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.22))

                                    Spacer()

                                    Image(systemName: "chevron.down")
                                        .foregroundColor(Color(red: 0.61, green: 0.64, blue: 0.69))
                                        .font(.system(size: 12))
                                }
                                .padding()
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 0.90, green: 0.91, blue: 0.92), lineWidth: 1)
                                )
                            }
                        }

                        // Occupation selection
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Occupation")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(red: 0.37, green: 0.41, blue: 0.51))

                            Menu {
                                ForEach(occupations, id: \.self) { occupation in
                                    Button(occupation) {
                                        selectedOccupation = occupation
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedOccupation.isEmpty ? "Select your occupation" : selectedOccupation)
                                        .foregroundColor(selectedOccupation.isEmpty ?
                                                       Color(red: 0.61, green: 0.64, blue: 0.69) :
                                                       Color(red: 0.12, green: 0.16, blue: 0.22))

                                    Spacer()

                                    Image(systemName: "chevron.down")
                                        .foregroundColor(Color(red: 0.61, green: 0.64, blue: 0.69))
                                        .font(.system(size: 12))
                                }
                                .padding()
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 0.90, green: 0.91, blue: 0.92), lineWidth: 1)
                                )
                            }
                        }

                        // Bio field
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Bio")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color(red: 0.37, green: 0.41, blue: 0.51))

                                Text("(Optional)")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(red: 0.61, green: 0.64, blue: 0.69))

                                Spacer()

                                Text("\(bio.count)/150")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(red: 0.61, green: 0.64, blue: 0.69))
                            }

                            ZStack(alignment: .topLeading) {
                                if bio.isEmpty {
                                    Text("Tell us something about yourself...")
                                        .foregroundColor(Color(red: 0.61, green: 0.64, blue: 0.69))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                }

                                TextEditor(text: $bio)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minHeight: 80)
                                    .onChange(of: bio) { newValue in
                                        if newValue.count > 150 {
                                            bio = String(newValue.prefix(150))
                                        }
                                    }
                            }
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.90, green: 0.91, blue: 0.92), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
        .opacity(contentOpacity)
        .offset(y: contentOffset)
        .background(Color.white)
        .safeAreaInset(edge: .bottom) {
            // Create profile button
            Button(action: createProfile) {
                HStack {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Text("Create Profile")
                            .font(.system(size: 16, weight: .semibold))

                        Image(systemName: "checkmark")
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
                .foregroundColor(isFormValid ? .white : Color(red: 0.61, green: 0.64, blue: 0.69))
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(isFormValid && !isLoading ?
                           Color(red: 0.39, green: 0.40, blue: 0.95) :
                           Color(red: 0.90, green: 0.91, blue: 0.92)
                )
                .cornerRadius(16)
                .disabled(!isFormValid || isLoading)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 24)
            .background(Color.white)
        }
        .onAppear {
            startAnimations()
        }
    }

    private var isFormValid: Bool {
        !fullName.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private func startAnimations() {
        withAnimation(.easeOut(duration: 0.8)) {
            contentOpacity = 1
            contentOffset = 0
        }
    }

    private func createProfile() {
        guard isFormValid else { return }

        isLoading = true

        // Simulate profile creation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
            // Navigate to success screen
            // NavigationManager.shared.navigate(to: .success)
        }
    }
}

struct AvatarButton: View {
    let avatar: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                Circle()
                    .fill(isSelected ?
                          Color(red: 0.39, green: 0.40, blue: 0.95) :
                          Color(red: 0.95, green: 0.96, blue: 0.97)
                    )
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle()
                            .stroke(isSelected ?
                                   Color(red: 0.39, green: 0.40, blue: 0.95) :
                                   Color.clear,
                                   lineWidth: 3
                            )
                    )

                Text(avatar)
                    .font(.system(size: 24))
            }
        }
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0), value: isSelected)
    }
}

#Preview {
    SetupProfileScreen()
}