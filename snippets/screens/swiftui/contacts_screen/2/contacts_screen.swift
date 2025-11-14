import SwiftUI

struct ContactsScreen: View {
    @State private var searchText = ""
    @State private var contacts = [
        Contact(id: "1", name: "Alice Johnson", email: "alice@example.com", phone: "+1 555-0101", avatar: "AJ"),
        Contact(id: "2", name: "Bob Smith", email: "bob@example.com", phone: "+1 555-0102", avatar: "BS"),
        Contact(id: "3", name: "Carol Davis", email: "carol@example.com", phone: "+1 555-0103", avatar: "CD"),
        Contact(id: "4", name: "David Wilson", email: "david@example.com", phone: "+1 555-0104", avatar: "DW"),
        Contact(id: "5", name: "Emma Brown", email: "emma@example.com", phone: "+1 555-0105", avatar: "EB")
    ]
    @State private var showingAddContact = false

    var filteredContacts: [Contact] {
        if searchText.isEmpty {
            return contacts
        } else {
            return contacts.filter { contact in
                contact.name.localizedCaseInsensitiveContains(searchText) ||
                contact.email.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                    .padding(.top, 8)

                if filteredContacts.isEmpty {
                    // Empty State
                    VStack(spacing: 16) {
                        Spacer()

                        Image(systemName: "person.2")
                            .font(.system(size: 64))
                            .foregroundColor(.gray.opacity(0.5))

                        Text(searchText.isEmpty ? "No contacts yet" : "No contacts found")
                            .font(.title2)
                            .foregroundColor(.secondary)

                        if searchText.isEmpty {
                            Button("Add Contact") {
                                showingAddContact = true
                            }
                            .buttonStyle(.bordered)
                        }

                        Spacer()
                    }
                } else {
                    // Contacts List
                    List(filteredContacts) { contact in
                        NavigationLink(destination: ContactDetailScreen(contact: contact)) {
                            ContactRowView(contact: contact)
                        }
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Contacts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddContact = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddContact) {
                AddContactSheet(contacts: $contacts)
            }
        }
    }
}

struct ContactRowView: View {
    let contact: Contact

    var body: some View {
        HStack(spacing: 16) {
            // Avatar
            ZStack {
                Circle()
                    .fill(contact.avatarColor)
                    .frame(width: 50, height: 50)

                Text(contact.avatar)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }

            // Contact Info
            VStack(alignment: .leading, spacing: 4) {
                Text(contact.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)

                Text(contact.email)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)

                Text(contact.phone)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Action Buttons
            HStack(spacing: 8) {
                Button {
                    // Call action
                } label: {
                    Image(systemName: "phone.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.green)
                        .frame(width: 32, height: 32)
                        .background(Color.green.opacity(0.1))
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())

                Button {
                    // Message action
                } label: {
                    Image(systemName: "message.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                        .frame(width: 32, height: 32)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.vertical, 4)
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)

            TextField("Search contacts...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct AddContactSheet: View {
    @Binding var contacts: [Contact]
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""

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
            .navigationTitle("Add Contact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newContact = Contact(
                            id: UUID().uuidString,
                            name: name,
                            email: email,
                            phone: phone,
                            avatar: String(name.prefix(2)).uppercased()
                        )
                        contacts.append(newContact)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

struct Contact: Identifiable {
    let id: String
    let name: String
    let email: String
    let phone: String
    let avatar: String

    var avatarColor: Color {
        let colors: [Color] = [.blue, .green, .orange, .purple, .red, .pink]
        let hash = id.hashValue
        return colors[abs(hash) % colors.count]
    }
}

#Preview {
    ContactsScreen()
}