import SwiftUI
import PhotosUI

struct EditProfileScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = "John Doe"
    @State private var username = "johndoe"
    @State private var bio = "Software Engineer | Flutter Developer | Tech Enthusiast\nBuilding amazing apps with Flutter 🚀"
    @State private var email = "john.doe@example.com"
    @State private var phone = "+1 (555) 123-4567"
    @State private var location = "San Francisco, CA"
    @State private var website = "www.johndoe.dev"

    @State private var publicProfile = true
    @State private var showEmail = false
    @State private var showPhone = false

    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var profileImage: UIImage? = nil
    @State private var showingImagePicker = false
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            Form {
                Section {
                    // Profile Picture
                    HStack {
                        Spacer()

                        VStack {
                            ZStack(alignment: .bottomTrailing) {
                                Group {
                                    if let profileImage {
                                        Image(uiImage: profileImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } else {
                                        AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=80")) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        } placeholder: {
                                            Image(systemName: "person.circle.fill")
                                                .foregroundColor(.gray)
                                                .font(.system(size: 80))
                                        }
                                    }
                                }
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())

                                Button(action: { showingImagePicker = true }) {
                                    Image(systemName: "camera.fill")
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(Color.blue)
                                        .clipShape(Circle())
                                }
                            }
                        }

                        Spacer()
                    }
                    .padding(.vertical)
                }

                Section("Profile Information") {
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(.secondary)
                            .frame(width: 20)
                        TextField("Full Name", text: $name)
                    }

                    HStack {
                        Image(systemName: "at")
                            .foregroundColor(.secondary)
                            .frame(width: 20)
                        TextField("Username", text: $username)
                            .autocapitalization(.none)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "text.alignleft")
                                .foregroundColor(.secondary)
                                .frame(width: 20)
                            Text("Bio")
                                .foregroundColor(.secondary)
                        }
                        TextField("Tell people about yourself...", text: $bio, axis: .vertical)
                            .lineLimit(4...6)
                    }
                }

                Section("Contact Information") {
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.secondary)
                            .frame(width: 20)
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }

                    HStack {
                        Image(systemName: "phone")
                            .foregroundColor(.secondary)
                            .frame(width: 20)
                        TextField("Phone Number", text: $phone)
                            .keyboardType(.phonePad)
                    }

                    HStack {
                        Image(systemName: "location")
                            .foregroundColor(.secondary)
                            .frame(width: 20)
                        TextField("Location", text: $location)
                    }

                    HStack {
                        Image(systemName: "globe")
                            .foregroundColor(.secondary)
                            .frame(width: 20)
                        TextField("Website", text: $website)
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                    }
                }

                Section("Privacy Settings") {
                    Toggle("Public Profile", isOn: $publicProfile)
                    Toggle("Show Email", isOn: $showEmail)
                    Toggle("Show Phone", isOn: $showPhone)
                }

                Section {
                    HStack {
                        Button("Cancel") {
                            dismiss()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.primary)
                        .cornerRadius(8)

                        Spacer()

                        Button(action: saveProfile) {
                            if isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                            } else {
                                Text("Save Changes")
                            }
                        }
                        .disabled(isLoading)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProfile()
                    }
                    .disabled(isLoading)
                }
            }
            .photosPicker(isPresented: $showingImagePicker, selection: $selectedImage)
            .onChange(of: selectedImage) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        profileImage = uiImage
                    }
                }
            }
        }
    }

    private func saveProfile() {
        isLoading = true

        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
            dismiss()
            // In a real app, show success message
        }
    }
}

#Preview {
    EditProfileScreen()
}