# Flutter Mobile Template

A comprehensive, production-ready Flutter template with clean architecture, essential dependencies, and best practices.

## 🚀 Features

- **Clean Architecture** - Organized into Data, Domain, and Presentation layers
- **State Management** - Provider for predictable state management
- **Navigation** - go_router for declarative routing
- **HTTP Client** - Dio with interceptors and error handling
- **Local Storage** - SharedPreferences and Hive for data persistence
- **Responsive Design** - Utilities for mobile, tablet, and desktop layouts
- **Theme Management** - Light/Dark mode with system preference support
- **Form Validation** - Comprehensive validation utilities
- **Authentication Flow** - Complete auth setup with login/logout
- **Common Widgets** - Reusable UI components
- **Error Handling** - Centralized error handling and display

## 📁 Project Structure

```
lib/
├── core/                   # Core utilities and configurations
│   ├── constants/         # App constants and configuration
│   ├── di/               # Dependency injection setup
│   ├── errors/           # Custom exceptions and error handling
│   ├── network/          # API client and network configuration
│   ├── routes/           # Navigation and routing setup
│   ├── storage/          # Local storage implementations
│   ├── theme/            # App themes and styling
│   └── utils/            # Utility functions and helpers
├── data/                   # Data layer
│   ├── datasources/      # Remote and local data sources
│   ├── models/           # Data models and DTOs
│   └── repositories/     # Repository implementations
├── domain/                 # Domain layer
│   ├── entities/         # Business entities
│   ├── repositories/     # Repository interfaces
│   └── usecases/         # Business logic and use cases
└── presentation/           # Presentation layer
    ├── pages/            # Screen/Page widgets
    ├── providers/        # State management providers
    └── widgets/          # Reusable UI components
```

## 📦 Dependencies & Library Choices

### 🎯 Core Architecture
| Category | Library | Why We Chose It |
|----------|---------|-----------------|
| **State Management** | `provider ^6.1.1` | Flutter's recommended solution, simple, performant, and well-maintained by the Flutter team |
| **Navigation** | `go_router ^13.0.1` | Declarative routing, deep linking support, officially recommended by Flutter team |
| **HTTP Client** | `dio ^5.4.0` | Powerful HTTP client with interceptors, better than http package for complex scenarios |
| **Local Storage** | `shared_preferences ^2.2.2` + `hive ^2.2.3` | SharedPreferences for simple key-value, Hive for complex offline data |
| **Dependency Injection** | Manual/GetIt pattern | Simple and effective without heavy frameworks |

### 🛠️ Utility Libraries
| Category | Library | Purpose |
|----------|---------|---------|
| **Equality Comparison** | `equatable ^2.0.5` | Simplifies value equality for models and entities |
| **Internationalization** | `intl ^0.19.0` | Official i18n solution with date/number formatting |
| **Logging** | `logger ^2.0.2` | Better logging with levels and formatting |
| **Image Caching** | `cached_network_image ^3.3.1` | Efficient image loading with caching |
| **SVG Support** | `flutter_svg ^2.0.9` | SVG rendering support |
| **Permissions** | `permission_handler ^11.2.0` | Cross-platform permission handling |
| **URL Launching** | `url_launcher ^6.2.3` | Open URLs in browser/apps |
| **Connectivity** | `connectivity_plus ^5.0.2` | Network connectivity monitoring |

### 📝 Why These Libraries?

**Provider over Riverpod/Bloc:**
- Official Flutter recommendation
- Simpler learning curve
- Sufficient for most apps
- Excellent documentation
- Smaller bundle size

**go_router over auto_route:**
- Official Flutter recommendation
- Better web support
- Simpler API
- Active maintenance by Flutter team

**Dio over http package:**
- Better error handling
- Request/response interceptors
- File upload/download support
- Request cancellation
- Better timeout handling

**Hive over sqflite:**
- NoSQL is simpler for most mobile apps
- Faster performance
- Easier to use
- Good for offline-first apps
- `dio` - HTTP client
- `shared_preferences` - Simple key-value storage
- `hive` - NoSQL database for complex data
- `equatable` - Value equality without boilerplate

### UI/UX Dependencies
- `cached_network_image` - Image caching and loading
- `intl` - Internationalization support

### Development Dependencies
- `flutter_lints` - Dart linting rules
- `hive_generator` - Code generation for Hive
- `build_runner` - Code generation runner

## 🛠️ Setup

### Prerequisites
- Flutter SDK (3.1.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Git

### Using the Template

1. **Run the setup script:**
   ```bash
   ./setup-template.sh my_awesome_app ~/projects/
   ```

2. **Navigate to your project:**
   ```bash
   cd ~/projects/my_awesome_app
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

### Manual Setup

1. **Copy the template:**
   ```bash
   cp -r flutter-template my_project
   cd my_project
   ```

2. **Update project name in `pubspec.yaml`:**
   ```yaml
   name: my_project
   ```

3. **Get dependencies:**
   ```bash
   flutter pub get
   ```

4. **Generate code:**
   ```bash
   flutter packages pub run build_runner build
   ```

5. **Run the app:**
   ```bash
   flutter run
   ```

## 🏗️ Architecture

This template follows Clean Architecture principles with three main layers:

### Data Layer
- **Models**: Data transfer objects and serialization
- **Repositories**: Concrete implementations of domain repositories
- **Data Sources**: API clients, local storage, etc.

### Domain Layer
- **Entities**: Core business objects
- **Repositories**: Abstract interfaces for data access
- **Use Cases**: Business logic and application rules

### Presentation Layer
- **Pages**: UI screens and navigation
- **Providers**: State management with Provider
- **Widgets**: Reusable UI components

## 🎨 Theming

The app supports both light and dark themes with system preference detection:

```dart
// Access theme in widgets
Theme.of(context).colorScheme.primary

// Toggle theme
context.read<ThemeProvider>().toggleTheme()

// Set specific theme
context.read<ThemeProvider>().setThemeMode(ThemeMode.dark)
```

## 📱 Responsive Design

Built-in utilities for responsive layouts:

```dart
// Check device type
ResponsiveHelper.isMobile(context)
ResponsiveHelper.isTablet(context)
ResponsiveHelper.isDesktop(context)

// Get responsive values
ResponsiveHelper.getResponsiveValue(
  context,
  mobile: 16.0,
  tablet: 20.0,
  desktop: 24.0,
)

// Responsive padding
ResponsiveHelper.getResponsivePadding(context)
```

## 🔐 Authentication

Complete authentication flow with:
- Login/Logout functionality
- Token management
- Auth state management
- Protected routes

```dart
// Login
final success = await context.read<AuthProvider>().login(email, password);

// Check auth status
final isAuthenticated = context.read<AuthProvider>().isAuthenticated;

// Logout
await context.read<AuthProvider>().logout();
```

## 🌐 Networking

HTTP client with built-in features:
- Automatic token attachment
- Request/response logging
- Error handling and retry logic
- Timeout configuration

```dart
// GET request
final response = await ApiClient().get('/users');

// POST request
final response = await ApiClient().post('/login', data: {
  'email': email,
  'password': password,
});
```

## 💾 Local Storage

Two storage options available:
- **SharedPreferences**: Simple key-value pairs
- **Hive**: Complex objects and relationships

```dart
// Simple storage
await localStorage.saveString('key', 'value');
final value = await localStorage.getString('key');

// Object storage
await localStorage.saveObject('user', user.toMap());
final userData = await localStorage.getObject('user');
```

## ✅ Form Validation

Comprehensive validation utilities:

```dart
CustomTextField(
  controller: emailController,
  validator: Validators.email,
),

CustomTextField(
  controller: passwordController,
  validator: Validators.combine([
    (value) => Validators.required(value, 'Password'),
    (value) => Validators.minLength(value, 8, 'Password'),
  ]),
),
```

## 🧪 Testing

```bash
# Run tests
flutter test

# Run tests with coverage
flutter test --coverage
```

## 🚢 Building

```bash
# Build APK (Android)
flutter build apk --release

# Build App Bundle (Android)
flutter build appbundle --release

# Build iOS (requires macOS)
flutter build ios --release
```

## 📋 Common Commands

```bash
# Clean project
flutter clean

# Get dependencies
flutter pub get

# Run code generation
flutter packages pub run build_runner build

# Analyze code
flutter analyze

# Format code
flutter format .

# Run on specific device
flutter run -d <device-id>

# Build for web
flutter build web
```

## 🎯 Best Practices

### Code Organization
- Follow the established folder structure
- Use meaningful names for files and classes
- Keep files focused and single-purpose

### State Management
- Use Provider for app-wide state
- Keep providers focused and minimal
- Use Consumer widgets for efficient rebuilds

### Navigation
- Use named routes for better maintainability
- Keep route definitions centralized
- Handle deep linking appropriately

### Error Handling
- Use try-catch blocks for async operations
- Provide meaningful error messages to users
- Log errors for debugging

### Performance
- Use const constructors where possible
- Implement lazy loading for large lists
- Optimize image loading and caching
- Profile your app regularly

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Provider Documentation](https://pub.dev/packages/provider)
- [go_router Documentation](https://pub.dev/packages/go_router)

## 🗺️ Roadmap

- [ ] Unit and widget tests
- [ ] Integration tests
- [ ] CI/CD pipeline
- [ ] Internationalization (i18n)
- [ ] Push notifications
- [ ] Offline support
- [ ] Performance monitoring
- [ ] Crash reporting

---

Built with ❤️ using Flutter