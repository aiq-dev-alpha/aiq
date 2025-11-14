import SwiftUI

struct ContactDetailScreen: View {
    let contact: Contact
    @State private var isFavorite = false
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Header
                VStack(spacing: 16) {
                    // Avatar
                    ZStack {
                        Circle()
                            .fill(contact.avatarColor)
                            .frame(width: 100, height: 100)

                        Text(contact.avatar)
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                    }

                    // Name and Title
                    VStack(spacing: 4) {
                        Text(contact.name)
                            .font(.title)
                            .fontWeight(.bold)

                        Text("Contact")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 10)

                // Quick Actions
                HStack(spacing: 20) {
                    QuickActionButton(
                        icon: "phone.fill",
                        label: "Call",
                        color: .green
                    ) {
                        // Call action
                    }

                    QuickActionButton(
                        icon: "message.fill",
                        label: "Message",
                        color: .blue
                    ) {
                        // Message action
                    }

                    QuickActionButton(
                        icon: "envelope.fill",
                        label: "Email",
                        color: .orange
                    ) {
                        // Email action
                    }

                    QuickActionButton(
                        icon: "video.fill",
                        label: "Video",
                        color: .purple
                    ) {
                        // Video call action
                    }
                }
                .padding(.horizontal)

                // Contact Information
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("Contact Information")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 12)

                    VStack(spacing: 1) {
                        ContactInfoRow(
                            icon: "phone.fill",
                            iconColor: .green,
                            title: "Phone",
                            subtitle: contact.phone
                        ) {
                            // Copy phone number
                        }

                        Divider()
                            .padding(.leading, 60)

                        ContactInfoRow(
                            icon: "envelope.fill",
                            iconColor: .blue,
                            title: "Email",
                            subtitle: contact.email
                        ) {
                            // Copy email
                        }

                        Divider()
                            .padding(.leading, 60)

                        ContactInfoRow(
                            icon: "calendar",
                            iconColor: .red,
                            title: "Birthday",
                            subtitle: "January 15, 1990"
                        ) {
                            // Edit birthday
                        }

                        Divider()
                            .padding(.leading, 60)

                        ContactInfoRow(
                            icon: "building.2",
                            iconColor: .purple,
                            title: "Company",
                            subtitle: "Tech Solutions Inc."
                        ) {
                            // Edit company
                        }

                        Divider()
                            .padding(.leading, 60)

                        ContactInfoRow(
                            icon: "location",
                            iconColor: .red,
                            title: "Address",
                            subtitle: "123 Main St, Anytown, ST 12345"
                        ) {
                            // Open maps
                        }

                        Divider()
                            .padding(.leading, 60)

                        ContactInfoRow(
                            icon: "note.text",
                            iconColor: .orange,
                            title: "Notes",
                            subtitle: "Met at tech conference 2023. Interested in mobile development."
                        ) {
                            // Edit notes
                        }
                    }
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle(contact.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    isFavorite.toggle()
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .primary)
                }

                Button {
                    showingEditSheet = true
                } label: {
                    Image(systemName: "pencil")
                }

                Menu {
                    Button("Share Contact") {
                        // Share contact
                    }

                    Button("Delete Contact", role: .destructive) {
                        showingDeleteAlert = true
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditContactSheet(contact: contact)
        }
        .alert("Delete Contact", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                // Delete contact and go back
            }
        } message: {
            Text("Are you sure you want to delete \(contact.name)?")
        }
    }
}

struct QuickActionButton: View {
    let icon: String
    let label: String
    let color: Color
    let action: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            Button(action: action) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 56, height: 56)

                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(color)
                }
            }
            .buttonStyle(PlainButtonStyle())

            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
    }
}

struct ContactInfoRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.1))
                        .frame(width: 36, height: 36)

                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(iconColor)
                }

                // Text
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primary)

                    Text(subtitle)
                        .font(.system(size: 16))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EditContactSheet: View {
    let contact: Contact
    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @State private var email: String
    @State private var phone: String

    init(contact: Contact) {
        self.contact = contact
        self._name = State(initialValue: contact.name)
        self._email = State(initialValue: contact.email)
        self._phone = State(initialValue: contact.phone)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Contact Information") {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    TextField("Phone", text: $phone)
                        .keyboardType(.phonePad)
                }
            }
            .navigationTitle("Edit Contact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Save contact changes
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContactDetailScreen(
            contact: Contact(
                id: "1",
                name: "Alice Johnson",
                email: "alice@example.com",
                phone: "+1 555-0101",
                avatar: "AJ"
            )
        )
    }
}