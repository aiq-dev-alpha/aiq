import Foundation

// MARK: - User Model

struct User: Codable, Identifiable, Hashable {
    let id: UUID
    let name: String
    let email: String
    let profileImageURL: URL?
    let createdAt: Date
    let updatedAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        email: String,
        profileImageURL: URL? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.profileImageURL = profileImageURL
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - User Extensions

extension User {
    static let mock = User(
        name: "John Doe",
        email: "john.doe@example.com",
        profileImageURL: URL(string: "https://via.placeholder.com/150")
    )

    var displayName: String {
        name.isEmpty ? email : name
    }

    var initials: String {
        let components = name.components(separatedBy: " ")
        let initials = components.compactMap { $0.first }.map(String.init)
        return initials.joined().uppercased()
    }
}

// MARK: - User Response

struct UserResponse: Codable {
    let user: User
    let token: String?
}

// MARK: - User Request

struct UserUpdateRequest: Codable {
    let name: String?
    let email: String?
    let profileImageURL: URL?
}