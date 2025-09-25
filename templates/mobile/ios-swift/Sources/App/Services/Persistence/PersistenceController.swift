import CoreData
import Foundation

// MARK: - Persistence Controller

final class PersistenceController {
    // MARK: - Singleton

    static let shared = PersistenceController()

    // MARK: - Preview

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        // Add sample data for previews
        let sampleUser = UserEntity(context: viewContext)
        sampleUser.id = UUID()
        sampleUser.name = "John Doe"
        sampleUser.email = "john.doe@example.com"
        sampleUser.createdAt = Date()
        sampleUser.updatedAt = Date()

        do {
            try viewContext.save()
        } catch {
            // Handle preview data error
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }

        return result
    }()

    // MARK: - Core Data Stack

    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                // Handle error appropriately in production
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    // MARK: - Properties

    private let inMemory: Bool

    // MARK: - Initialization

    init(inMemory: Bool = false) {
        self.inMemory = inMemory
    }

    // MARK: - Core Data Saving

    func save() throws {
        let context = container.viewContext

        if context.hasChanges {
            try context.save()
        }
    }

    func saveContext() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                // Handle error appropriately in production
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    // MARK: - Background Context

    func newBackgroundContext() -> NSManagedObjectContext {
        return container.newBackgroundContext()
    }

    func performBackgroundTask<T>(_ block: @escaping (NSManagedObjectContext) throws -> T) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            container.performBackgroundTask { context in
                do {
                    let result = try block(context)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}