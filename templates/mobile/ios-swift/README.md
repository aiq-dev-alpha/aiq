# iOS Swift Template

A comprehensive iOS application template built with Swift 5.9+, SwiftUI, and modern iOS development patterns. This template provides a solid foundation for building scalable iOS applications with clean architecture, networking, persistence, and common UI components.

## Features

- **Modern iOS Stack**: Swift 5.9+, SwiftUI, iOS 16+ deployment target
- **MVVM Architecture**: Clean separation of concerns with ViewModels and Models
- **Networking Layer**: URLSession with async/await for modern asynchronous networking
- **Core Data Integration**: Complete persistence layer with Core Data
- **Tab-based Navigation**: TabView with Home, Profile, and Settings screens
- **Error Handling**: Comprehensive error handling with custom error types
- **Combine Framework**: Reactive programming for data binding and state management
- **Swift Package Manager**: Modern dependency management
- **Development Scripts**: Automated setup and update scripts

## Architecture Overview

### Project Structure

```
Sources/App/
├── App.swift                 # App entry point with SwiftUI App lifecycle
├── ContentView.swift         # Main content view with tab navigation
├── Models/                   # Data models and entities
│   ├── User.swift           # User model with Codable support
│   └── AppError.swift       # Custom error types
├── ViewModels/              # MVVM view models
│   ├── BaseViewModel.swift  # Base class for view models
│   └── HomeViewModel.swift  # Home screen view model
├── Views/                   # SwiftUI views organized by feature
│   ├── Home/               # Home screen views
│   ├── Profile/            # Profile screen views
│   └── Settings/           # Settings screen views
├── Services/               # Business logic and external integrations
│   ├── Networking/         # Network layer
│   └── Persistence/        # Core Data layer
└── Utils/                  # Utility classes and extensions

Resources/
└── Info.plist             # App configuration

Tests/AppTests/             # Unit tests
```

### Architecture Patterns

#### MVVM (Model-View-ViewModel)

- **Models**: Plain Swift structs/classes representing data
- **Views**: SwiftUI views that observe ViewModels
- **ViewModels**: Business logic and state management using `@Published` properties

```swift
// Example ViewModel
@MainActor
final class HomeViewModel: BaseViewModel {
    @Published var users: [User] = []
    @Published var isLoading = false

    func fetchUsers() async {
        // Business logic here
    }
}
```

#### Dependency Injection

Services are injected into ViewModels for better testability:

```swift
init(
    networkingService: NetworkingServiceProtocol = NetworkingService.shared,
    persistenceService: PersistenceServiceProtocol = PersistenceService.shared
) {
    self.networkingService = networkingService
    self.persistenceService = persistenceService
}
```

#### Protocol-Oriented Design

All services implement protocols for easy mocking and testing:

```swift
protocol NetworkingServiceProtocol {
    func fetchUsers() async throws -> [User]
    func fetchUser(id: UUID) async throws -> User
}
```

## Key Components

### Networking Service

Modern async/await networking with URLSession:

- **Async/Await**: Modern asynchronous programming
- **Error Handling**: Comprehensive error mapping
- **JSON Coding**: Automatic encoding/decoding with custom strategies
- **Request Building**: Reusable request creation
- **Mock Support**: Mock implementation for testing

```swift
// Usage example
let users = try await NetworkingService.shared.fetchUsers()
```

### Persistence Layer

Core Data integration with modern Swift patterns:

- **PersistenceController**: Manages Core Data stack
- **Background Operations**: Async background context operations
- **Entity Mapping**: Automatic mapping between Core Data entities and Swift models
- **Error Handling**: Typed persistence errors

### Base View Model

Common functionality for all view models:

- **Loading States**: Centralized loading state management
- **Error Handling**: Consistent error handling across the app
- **Async Operations**: Helper methods for async task management
- **Combine Integration**: Publisher-based operations

### Custom Error System

Hierarchical error system with recovery suggestions:

- **AppError**: Top-level error enum
- **NetworkError**: Network-specific errors
- **PersistenceError**: Core Data errors
- **Localized Messages**: User-friendly error descriptions

## Setup Instructions

### Prerequisites

- Xcode 15.0+ or Swift 5.9+ toolchain
- iOS 16.0+ deployment target
- Git (for version control)

### Quick Start

1. **Run the setup script**:
   ```bash
   ./setup-template.sh
   ```

2. **Follow the prompts**:
   - Enter your app name
   - Specify bundle identifier
   - Set organization name
   - Configure API base URL

3. **Open in Xcode**:
   ```bash
   open Package.swift
   # or
   swift package generate-xcodeproj
   open YourApp.xcodeproj
   ```

### Manual Setup

1. **Copy template files**:
   ```bash
   cp -R ios-swift-template/ YourNewApp/
   cd YourNewApp/
   ```

2. **Update configuration**:
   - Modify `Package.swift` with your app name
   - Update `Resources/Info.plist` with your bundle identifier
   - Configure API base URL in `NetworkingService.swift`

3. **Build and run**:
   ```bash
   swift build
   swift run  # For command-line testing
   ```

## Development Workflow

### Available Scripts

- **`./build.sh`**: Build the project
- **`./test.sh`**: Run unit tests
- **`./run.sh`**: Run the app (command-line mode)
- **`./update-template.sh`**: Update from template (for existing projects)

### Adding New Features

1. **Create Model**: Add data structures in `Models/`
2. **Create ViewModel**: Implement business logic in `ViewModels/`
3. **Create Views**: Build UI in `Views/[Feature]/`
4. **Add Services**: Implement external integrations in `Services/`
5. **Write Tests**: Add unit tests in `Tests/AppTests/`

### Code Organization

- **Feature-based**: Group related files by feature
- **Layered Architecture**: Separate concerns into different layers
- **Protocol-first**: Use protocols for abstractions
- **Testable**: Design for easy unit testing

## Testing

The template includes a comprehensive testing setup:

### Unit Testing

```swift
// Example test
@testable import App
import XCTest

final class HomeViewModelTests: XCTestCase {
    func testFetchUsers() async throws {
        let viewModel = HomeViewModel(
            networkingService: MockNetworkingService(),
            persistenceService: MockPersistenceService()
        )

        await viewModel.refreshData()

        XCTAssertFalse(viewModel.users.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }
}
```

### Running Tests

```bash
swift test                    # Run all tests
swift test --parallel         # Run tests in parallel
./test.sh                     # Use the provided script
```

## Configuration

### Environment Variables

The template supports configuration through environment variables:

- **API_BASE_URL**: API server base URL
- **BUNDLE_IDENTIFIER**: App bundle identifier
- **APP_NAME**: Application display name

### Info.plist Configuration

Key configurations in `Resources/Info.plist`:

- **Privacy Permissions**: Camera, Photo Library, Location access
- **App Transport Security**: Network security settings
- **Background Modes**: Background execution capabilities
- **URL Schemes**: Custom URL scheme handling

### Package Dependencies

Add new dependencies in `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.0"),
    .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.10.0"),
],
targets: [
    .executableTarget(
        name: "App",
        dependencies: [
            "Alamofire",
            "Kingfisher",
        ]
    )
]
```

## Customization

### Theming

The template includes basic theming support:

```swift
// In SettingsViewModel
enum AppTheme: String, CaseIterable {
    case light = "light"
    case dark = "dark"
    case system = "system"
}
```

### Navigation

Customize the tab structure in `ContentView.swift`:

```swift
TabView(selection: $appState.selectedTab) {
    HomeView()
        .tabItem {
            Label("Home", systemImage: "house.fill")
        }
        .tag(0)
    // Add more tabs here
}
```

### Networking

Configure networking in `NetworkingService.swift`:

- **Base URL**: Set your API endpoint
- **Headers**: Add authentication or custom headers
- **Timeouts**: Configure request timeouts
- **SSL Pinning**: Add certificate pinning for security

### Core Data

Customize the data model in `DataModel.xcdatamodeld`:

1. Open in Xcode
2. Add new entities and relationships
3. Generate NSManagedObject classes
4. Update mapping in `PersistenceService.swift`

## Deployment

### App Store Deployment

1. **Update Info.plist**:
   - Set correct bundle identifier
   - Update app name and version
   - Configure required permissions

2. **Archive and Upload**:
   ```bash
   # In Xcode
   Product -> Archive -> Upload to App Store
   ```

3. **TestFlight Distribution**:
   - Upload build to App Store Connect
   - Add to TestFlight for beta testing

### Enterprise Distribution

1. **Configure signing**:
   - Set up enterprise certificates
   - Configure provisioning profiles

2. **Build for enterprise**:
   ```bash
   xcodebuild archive -scheme YourApp -archivePath YourApp.xcarchive
   xcodebuild -exportArchive -archivePath YourApp.xcarchive -exportPath ./
   ```

## Best Practices

### Code Style

- **Swift Style Guide**: Follow Swift community conventions
- **SwiftLint**: Use SwiftLint for consistent code style
- **Documentation**: Document public APIs with Swift documentation comments

### Performance

- **Lazy Loading**: Load data on demand
- **Image Caching**: Use AsyncImage with caching
- **Memory Management**: Avoid retain cycles with weak references
- **Background Processing**: Use background queues for heavy operations

### Security

- **API Keys**: Never commit API keys to version control
- **Certificate Pinning**: Pin SSL certificates in production
- **Keychain**: Store sensitive data in Keychain
- **Biometric Authentication**: Implement Face ID/Touch ID

### Accessibility

- **VoiceOver**: Add accessibility labels and hints
- **Dynamic Type**: Support system font sizes
- **High Contrast**: Test with accessibility modes
- **Voice Control**: Ensure voice control compatibility

## Troubleshooting

### Common Issues

**Build Errors**:
- Clean build folder: `swift package clean`
- Reset package cache: `swift package reset`
- Update dependencies: `swift package update`

**Core Data Issues**:
- Check entity names match code
- Verify relationships are correctly configured
- Review migration strategy for schema changes

**Networking Issues**:
- Verify API endpoints are accessible
- Check App Transport Security settings
- Review network error handling

### Getting Help

- **Documentation**: Check Swift and SwiftUI documentation
- **Community**: Swift community forums and Stack Overflow
- **WWDC Sessions**: Apple's developer session videos
- **Template Issues**: Create issues in the template repository

## Contributing

### Development Setup

1. Fork the template repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

### Template Updates

Use `update-template.sh` to pull in template updates:

```bash
./update-template.sh
```

Choose which components to update:
- Core architecture only
- UI components only
- Configuration files only
- Full update

## License

This template is released under the MIT License. See LICENSE file for details.

---

## Quick Reference

### Common Commands

```bash
# Setup new project
./setup-template.sh

# Build project
swift build

# Run tests
swift test

# Update from template
./update-template.sh

# Clean build
swift package clean
```

### File Locations

- **App Entry**: `Sources/App/App.swift`
- **Main View**: `Sources/App/ContentView.swift`
- **Models**: `Sources/App/Models/`
- **ViewModels**: `Sources/App/ViewModels/`
- **Views**: `Sources/App/Views/`
- **Services**: `Sources/App/Services/`
- **Configuration**: `Resources/Info.plist`
- **Dependencies**: `Package.swift`

This template provides a solid foundation for iOS development with modern Swift patterns, comprehensive error handling, and scalable architecture. Happy coding!