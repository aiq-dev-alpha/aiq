# Android Kotlin Template

A modern Android application template built with Kotlin, featuring clean architecture, Jetpack Compose UI, and best practices for Android development.

## 🏗️ Architecture

This template follows **MVVM (Model-View-ViewModel)** architecture with **Clean Architecture** principles:

```
┌─────────────────┐
│   Presentation  │ ← Jetpack Compose UI + ViewModels
├─────────────────┤
│     Domain      │ ← Use Cases + Models + Repository Interfaces
├─────────────────┤
│      Data       │ ← Repository Implementations + Local/Remote Data Sources
└─────────────────┘
```

### Layer Breakdown

#### 🎨 **Presentation Layer** (`ui/`)
- **Jetpack Compose** for modern, declarative UI
- **ViewModels** for managing UI state and business logic
- **Navigation Component** for screen navigation
- **Material Design 3** theming

#### 🎯 **Domain Layer** (`domain/`)
- **Use Cases** for business logic operations
- **Domain Models** representing core business entities
- **Repository Interfaces** defining data access contracts

#### 💾 **Data Layer** (`data/`)
- **Repository Implementations** coordinating between local and remote data
- **Local Database** with Room for offline storage
- **Remote API** with Retrofit for network communication
- **Data Transfer Objects (DTOs)** for API responses

## 🚀 Features

- ✅ **Modern UI** with Jetpack Compose and Material Design 3
- ✅ **MVVM Architecture** with ViewModels and StateFlow
- ✅ **Dependency Injection** with Hilt
- ✅ **Local Database** with Room
- ✅ **Network Communication** with Retrofit and Kotlinx Serialization
- ✅ **Navigation** with Navigation Compose
- ✅ **Coroutines** for asynchronous programming
- ✅ **ProGuard** rules for code obfuscation
- ✅ **Unit Testing** setup with JUnit
- ✅ **Instrumented Testing** setup with Espresso

## 📦 Dependencies

### Core Android
- **Android SDK** 35 (compileSdk)
- **Min SDK** 24 (supports 95%+ of devices)
- **Kotlin** 2.0.21
- **Android Gradle Plugin** 8.7.2

### UI Framework
- **Jetpack Compose BOM** 2024.12.01
- **Activity Compose** 1.9.3
- **Navigation Compose** 2.8.4
- **Material Design 3** 1.3.1

### Architecture Components
- **Lifecycle ViewModel Compose** 2.8.7
- **Lifecycle Runtime KTX** 2.8.7

### Dependency Injection
- **Hilt** 2.52
- **Hilt Navigation Compose** 1.2.0

### Database
- **Room** 2.6.1 (Runtime + Compiler + KTX)

### Networking
- **Retrofit** 2.11.0
- **Kotlinx Serialization** 1.7.3
- **OkHttp Logging Interceptor** 4.12.0

### Asynchronous Programming
- **Kotlinx Coroutines** 1.9.0

### Testing
- **JUnit** 4.13.2
- **AndroidX Test** 1.6.1
- **Espresso** 3.6.1

## 🛠️ Setup Instructions

### 1. **Quick Setup**
Run the setup script to customize the template:

```bash
./setup-template.sh --package-name com.yourcompany.yourapp --app-name "Your App Name"
```

Or run interactively:
```bash
./setup-template.sh
```

### 2. **Manual Customization**

1. **Update Package Name**: Replace `com.template.android` throughout the project
2. **Update App Name**: Modify `app_name` in `strings.xml`
3. **Configure API Base URL**: Update the base URL in `NetworkModule.kt`
4. **Add App Icons**: Replace icons in `mipmap-*` directories
5. **Customize Colors**: Update theme colors in `Color.kt`

### 3. **Update Dependencies**
Use the update script to keep dependencies current:

```bash
./update-template.sh --all
```

## 📁 Project Structure

```
app/src/main/java/com/template/android/
├── data/                           # Data Layer
│   ├── local/                      # Local database
│   │   ├── dao/                    # Room DAOs
│   │   ├── entity/                 # Room entities
│   │   └── TemplateDatabase.kt     # Database configuration
│   ├── remote/                     # Remote API
│   │   ├── api/                    # Retrofit API interfaces
│   │   └── dto/                    # Data transfer objects
│   └── repository/                 # Repository implementations
├── di/                            # Dependency injection modules
│   ├── DatabaseModule.kt          # Database dependencies
│   ├── NetworkModule.kt           # Network dependencies
│   └── RepositoryModule.kt        # Repository bindings
├── domain/                        # Domain Layer
│   ├── model/                     # Domain models
│   ├── repository/                # Repository interfaces
│   └── usecase/                   # Use cases
├── ui/                           # Presentation Layer
│   ├── components/               # Reusable UI components
│   ├── navigation/               # Navigation setup
│   ├── screens/                  # Screen composables
│   │   ├── home/                # Home screen + ViewModel
│   │   ├── profile/             # Profile screen
│   │   └── settings/            # Settings screen
│   └── theme/                   # Material Design theme
├── MainActivity.kt              # Main activity
└── TemplateApplication.kt       # Application class
```

## 🎯 Key Components

### **Dependency Injection (Hilt)**
```kotlin
@HiltAndroidApp
class TemplateApplication : Application()

@AndroidEntryPoint
class MainActivity : ComponentActivity()

@HiltViewModel
class HomeViewModel @Inject constructor(/* dependencies */) : ViewModel()
```

### **Database (Room)**
```kotlin
@Entity(tableName = "sample_items")
data class SampleEntity(...)

@Dao
interface SampleDao { ... }

@Database(entities = [SampleEntity::class], version = 1)
abstract class TemplateDatabase : RoomDatabase()
```

### **Network (Retrofit + Kotlinx Serialization)**
```kotlin
@Serializable
data class SampleDto(...)

interface SampleApiService {
    @GET("samples")
    suspend fun getSamples(): List<SampleDto>
}
```

### **UI State Management**
```kotlin
@HiltViewModel
class HomeViewModel @Inject constructor(...) : ViewModel() {
    private val _uiState = MutableStateFlow(HomeUiState())
    val uiState: StateFlow<HomeUiState> = _uiState.asStateFlow()
}

@Composable
fun HomeScreen(viewModel: HomeViewModel = hiltViewModel()) {
    val uiState by viewModel.uiState.collectAsStateWithLifecycle()
    // UI implementation
}
```

## 🧪 Testing

### Unit Tests
```bash
./gradlew test
```

### Instrumented Tests
```bash
./gradlew connectedAndroidTest
```

### Test Structure
- **Unit Tests**: `app/src/test/java/`
- **Instrumented Tests**: `app/src/androidTest/java/`

## 🔧 Build Variants

- **Debug**: Development build with logging enabled
- **Release**: Production build with ProGuard optimization

```bash
# Debug build
./gradlew assembleDebug

# Release build
./gradlew assembleRelease
```

## 📱 Material Design 3

The template includes a complete Material Design 3 theme with:
- **Dynamic Colors** (Android 12+)
- **Light/Dark theme** support
- **Custom color schemes**
- **Typography scales**
- **Consistent spacing**

## 🔒 ProGuard Configuration

Includes comprehensive ProGuard rules for:
- Retrofit and networking
- Room database
- Kotlinx Serialization
- Hilt dependency injection
- Jetpack Compose

## 🌐 API Configuration

Update the base URL in `NetworkModule.kt`:
```kotlin
.baseUrl("https://your-api.com/") // Replace with your API URL
```

## 📝 Development Guidelines

### **Code Style**
- Follow [Android Kotlin Style Guide](https://developer.android.com/kotlin/style-guide)
- Use meaningful variable and function names
- Keep functions small and focused
- Write unit tests for business logic

### **Architecture Guidelines**
- **Single Responsibility**: Each class has one reason to change
- **Dependency Inversion**: Depend on abstractions, not concretions
- **Separation of Concerns**: UI, business logic, and data are separate

### **State Management**
- Use `StateFlow` for reactive state management
- Collect state with `collectAsStateWithLifecycle()`
- Handle loading, success, and error states explicitly

## 🚀 Deployment

1. **Update version** in `app/build.gradle.kts`
2. **Generate signed APK** or AAB
3. **Test on multiple devices**
4. **Upload to Google Play Console**

## 📚 Additional Resources

- [Android Developer Documentation](https://developer.android.com)
- [Jetpack Compose Documentation](https://developer.android.com/jetpack/compose)
- [Kotlin Coroutines Guide](https://kotlinlang.org/docs/coroutines-guide.html)
- [Material Design 3](https://m3.material.io)
- [Hilt Documentation](https://dagger.dev/hilt)

## 🤝 Contributing

1. Follow the existing architecture patterns
2. Write tests for new features
3. Update documentation when needed
4. Follow code style guidelines

---

**Happy Coding! 🎉**

This template provides a solid foundation for modern Android development with industry best practices and up-to-date dependencies.