# React Native TypeScript Template

A comprehensive, production-ready React Native template with TypeScript, Redux Toolkit, React Navigation, and a clean architecture structure.

## Features

- **TypeScript**: Full TypeScript support with strict configuration
- **Redux Toolkit**: Modern Redux with RTK for state management
- **React Navigation**: Complete navigation setup with stack and tab navigators
- **Axios**: Pre-configured API client with interceptors and error handling
- **AsyncStorage**: Persistent storage utilities
- **Clean Architecture**: Well-organized folder structure
- **Custom Hooks**: Reusable hooks for common patterns
- **Common Components**: Pre-built UI components (Button, Input, Card, etc.)
- **ESLint & Prettier**: Code linting and formatting
- **Jest**: Testing setup with React Native testing utilities

## Project Structure

```
src/
├── components/          # Reusable UI components
│   ├── Button.tsx
│   ├── Input.tsx
│   ├── Card.tsx
│   ├── Loading.tsx
│   ├── ErrorMessage.tsx
│   └── SafeContainer.tsx
├── screens/             # Screen components
│   ├── auth/            # Authentication screens
│   │   ├── LoginScreen.tsx
│   │   ├── RegisterScreen.tsx
│   │   └── ForgotPasswordScreen.tsx
│   └── main/            # Main app screens
│       ├── HomeScreen.tsx
│       ├── ProfileScreen.tsx
│       └── SettingsScreen.tsx
├── navigation/          # Navigation configuration
│   ├── AppNavigator.tsx
│   ├── AuthNavigator.tsx
│   └── TabNavigator.tsx
├── services/            # API and external services
│   ├── api.ts           # Axios configuration
│   ├── authService.ts   # Authentication API calls
│   └── userService.ts   # User-related API calls
├── store/               # Redux store and slices
│   ├── index.ts         # Store configuration
│   └── slices/
│       ├── authSlice.ts
│       ├── userSlice.ts
│       └── appSlice.ts
├── hooks/               # Custom React hooks
│   ├── useRedux.ts      # Typed Redux hooks
│   ├── useApi.ts        # API call hook
│   ├── useDebounce.ts   # Debounce hook
│   └── useThrottle.ts   # Throttle hook
├── utils/               # Utility functions
│   ├── index.ts         # Common utilities
│   └── storage.ts       # AsyncStorage wrapper
└── types/               # TypeScript type definitions
    └── index.ts         # Common types and interfaces
```

## Getting Started

### Prerequisites

- Node.js (v16 or higher)
- npm or yarn
- React Native CLI
- Xcode (for iOS development on macOS)
- Android Studio (for Android development)

### Installation

1. **Use the template setup script:**
   ```bash
   ./setup-template.sh MyAwesomeApp /path/to/destination
   ```

2. **Or manually copy and configure:**
   ```bash
   # Copy template files
   cp -r react-native-template MyAwesomeApp
   cd MyAwesomeApp

   # Install dependencies
   npm install

   # For iOS (macOS only)
   cd ios && pod install && cd ..
   ```

### Running the App

#### iOS (macOS only)

```bash
# Start Metro bundler
npm start

# Run on iOS simulator
npm run ios

# Run on specific iOS simulator
npm run ios -- --simulator="iPhone 14 Pro"
```

#### Android

```bash
# Start Metro bundler
npm start

# Run on Android emulator/device
npm run android
```

## Available Scripts

| Script | Description |
|--------|-------------|
| `npm start` | Start the Metro bundler |
| `npm run ios` | Run the app on iOS simulator |
| `npm run android` | Run the app on Android emulator/device |
| `npm run lint` | Run ESLint |
| `npm run test` | Run Jest tests |
| `npm run typecheck` | Run TypeScript compiler check |
| `npm run clean` | Clean project cache and dependencies |
| `npm run build:android` | Build Android APK |
| `npm run build:ios` | Build iOS archive |

## Architecture Overview

### State Management

This template uses **Redux Toolkit** for state management with the following structure:

- **Auth Slice**: Handles authentication state, login, logout, registration
- **User Slice**: Manages user profile data and user-related operations
- **App Slice**: General app settings like theme, notifications, connectivity

```typescript
// Example usage
import { useAppSelector, useAppDispatch } from '@/hooks';
import { loginUser } from '@/store/slices/authSlice';

const { user, isAuthenticated } = useAppSelector(state => state.auth);
const dispatch = useAppDispatch();

const handleLogin = async () => {
  await dispatch(loginUser({ email, password }));
};
```

### API Integration

The template includes a robust API client built with Axios:

```typescript
// services/api.ts - Auto-handles auth tokens and errors
import { apiClient } from '@/services';

const response = await apiClient.get('/users/profile');
```

### Navigation

Uses **React Navigation v6** with:
- **Stack Navigator**: For screen transitions
- **Tab Navigator**: For main app screens
- **Conditional Navigation**: Shows auth or main flow based on authentication state

### Storage

AsyncStorage is wrapped in a service class for better error handling:

```typescript
import { storageService } from '@/utils/storage';
import { StorageKeys } from '@/types';

await storageService.setItem(StorageKeys.USER_TOKEN, token);
const token = await storageService.getItem(StorageKeys.USER_TOKEN);
```

## Customization

### Adding New Screens

1. Create screen component in `src/screens/`
2. Add to appropriate navigator in `src/navigation/`
3. Update TypeScript types if needed

### Adding New API Endpoints

1. Add service methods in `src/services/`
2. Create corresponding Redux slice if needed
3. Use in components with `useAppSelector` and `useAppDispatch`

### Styling

The template uses React Native's StyleSheet API. You can:

- Modify existing component styles
- Add theme support by extending the app slice
- Integrate styled-components if preferred

### Environment Configuration

Create environment files:

```bash
# .env.development
API_BASE_URL=http://localhost:3000/api

# .env.production
API_BASE_URL=https://your-api-domain.com/api
```

## Testing

The template includes Jest configuration for testing:

```bash
# Run all tests
npm test

# Run tests in watch mode
npm test -- --watch

# Run tests with coverage
npm test -- --coverage
```

## Deployment

### Android

```bash
# Generate signed APK
npm run build:android

# The APK will be in android/app/build/outputs/apk/release/
```

### iOS

```bash
# Archive for App Store
npm run build:ios

# Or use Xcode for more control
open ios/YourApp.xcworkspace
```

## Troubleshooting

### Common Issues

#### Metro bundler issues
```bash
# Clear Metro cache
npx react-native start --reset-cache

# Or use the clean script
npm run clean
```

#### iOS build issues
```bash
# Clean iOS build
cd ios && xcodebuild clean && cd ..

# Reinstall pods
cd ios && pod install && cd ..
```

#### Android build issues
```bash
# Clean Android build
cd android && ./gradlew clean && cd ..

# Reset Android project
cd android && ./gradlew --stop && cd ..
```

#### TypeScript errors
```bash
# Check for TypeScript errors
npm run typecheck

# Common fixes
rm -rf node_modules && npm install
```

### Performance Optimization

1. **Enable Hermes** (React Native 0.70+):
   - iOS: Set `hermes_enabled => true` in `ios/Podfile`
   - Android: Already enabled by default

2. **Bundle Analysis**:
   ```bash
   npx react-native bundle --platform android --dev false --entry-file index.js --bundle-output android-bundle.js --analyze
   ```

3. **Image Optimization**:
   - Use appropriate image formats (WebP for Android, HEIF for iOS)
   - Implement lazy loading for large lists

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes following the existing code style
4. Add tests for new functionality
5. Submit a pull request

## Dependencies

### Core Dependencies

- **react**: ^18.2.0
- **react-native**: ^0.72.4
- **@reduxjs/toolkit**: ^1.9.5
- **react-redux**: ^8.1.2
- **@react-navigation/native**: ^6.1.7
- **axios**: ^1.5.0
- **@react-native-async-storage/async-storage**: ^1.19.3

### Development Dependencies

- **typescript**: ^5.1.6
- **@types/react**: ^18.2.20
- **@types/react-native**: ^0.72.2
- **eslint**: ^8.47.0
- **prettier**: ^3.0.2
- **jest**: ^29.6.3

## License

This template is available under the MIT License. See the LICENSE file for more info.

## Support

For issues and questions:

1. Check the troubleshooting section above
2. Search existing GitHub issues
3. Create a new issue with detailed information
4. Check React Native documentation: https://reactnative.dev/

---

**Happy coding!** 🚀

This template provides a solid foundation for building production-ready React Native applications with modern best practices and a clean architecture.