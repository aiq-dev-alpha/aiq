import CoreData
import Foundation

// MARK: - Persistence Service Protocol

protocol PersistenceServiceProtocol {
    func fetchUsers() throws -> [User]
    func saveUsers(_ users: [User]) throws
    func deleteUser(id: UUID) throws
    func updateUser(_ user: User) throws
}

// MARK: - Persistence Service

final class PersistenceService: PersistenceServiceProtocol {
    // MARK: - Singleton

    static let shared = PersistenceService()

    // MARK: - Properties

    private let persistenceController: PersistenceController

    // MARK: - Initialization

    init(persistenceController: PersistenceController = .shared) {
        self.persistenceController = persistenceController
    }

    // MARK: - User Operations

    func fetchUsers() throws -> [User] {
        let context = persistenceController.container.viewContext
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \UserEntity.name, ascending: true)]

        do {
            let userEntities = try context.fetch(request)
            return userEntities.compactMap { $0.toUser() }
        } catch {
            throw PersistenceError.fetchFailure
        }
    }

    func saveUsers(_ users: [User]) throws {
        let context = persistenceController.container.viewContext

        // Clear existing users
        try clearUsers()

        // Create new user entities
        for user in users {
            let userEntity = UserEntity(context: context)
            userEntity.update(from: user)
        }

        do {
            try context.save()
        } catch {
            throw PersistenceError.saveFailure
        }
    }

    func deleteUser(id: UUID) throws {
        let context = persistenceController.container.viewContext
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let users = try context.fetch(request)
            for user in users {
                context.delete(user)
            }
            try context.save()
        } catch {
            throw PersistenceError.deleteFailure
        }
    }

    func updateUser(_ user: User) throws {
        let context = persistenceController.container.viewContext
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", user.id as CVarArg)

        do {
            let userEntities = try context.fetch(request)
            if let userEntity = userEntities.first {
                userEntity.update(from: user)
                try context.save()
            } else {
                // User doesn't exist, create new one
                let userEntity = UserEntity(context: context)
                userEntity.update(from: user)
                try context.save()
            }
        } catch {
            throw PersistenceError.saveFailure
        }
    }

    // MARK: - Private Methods

    private func clearUsers() throws {
        let context = persistenceController.container.viewContext
        let request: NSFetchRequest<NSFetchRequestResult> = UserEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            throw PersistenceError.deleteFailure
        }
    }
}

// MARK: - User Entity Extensions

extension UserEntity {
    func toUser() -> User? {
        guard let id = self.id,
              let name = self.name,
              let email = self.email,
              let createdAt = self.createdAt,
              let updatedAt = self.updatedAt else {
            return nil
        }

        return User(
            id: id,
            name: name,
            email: email,
            profileImageURL: self.profileImageURL,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    func update(from user: User) {
        self.id = user.id
        self.name = user.name
        self.email = user.email
        self.profileImageURL = user.profileImageURL
        self.createdAt = user.createdAt
        self.updatedAt = user.updatedAt
    }
}