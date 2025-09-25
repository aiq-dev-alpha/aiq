# Cordova TypeScript Template

A modern Apache Cordova application template with TypeScript, Webpack, and native plugin support.

## Features

- **TypeScript** - Type-safe mobile development
- **Webpack 5** - Modern bundling with hot reload
- **Native Plugins** - Camera, GPS, File System, Network, etc.
- **Cross-Platform** - iOS, Android, and Browser support
- **Modern UI** - Responsive design with CSS3
- **Service Architecture** - Clean separation of concerns

## Project Structure

```
├── src/
│   ├── app/              # Application core
│   ├── services/         # Plugin services
│   ├── types/           # TypeScript definitions
│   ├── index.ts         # Entry point
│   ├── index.html       # HTML template
│   └── styles.css       # Global styles
├── www/                 # Build output
├── platforms/           # Platform-specific code
├── plugins/            # Cordova plugins
├── config.xml          # Cordova configuration
├── webpack.config.js   # Webpack configuration
├── tsconfig.json       # TypeScript configuration
└── package.json        # Dependencies
```

## Prerequisites

- Node.js 18+
- npm or yarn
- For iOS: macOS with Xcode
- For Android: Android SDK and Java JDK

## Quick Start

```bash
# Install dependencies
npm install

# Add platforms
npx cordova platform add android
npx cordova platform add ios
npx cordova platform add browser

# Development (with hot reload)
npm run dev

# Build for production
npm run build

# Run on device/emulator
npm run android
npm run ios
npm run browser
```

## Included Plugins

### Core Plugins
- **Device** - Device information
- **Network Information** - Network status
- **Status Bar** - Status bar control
- **Splash Screen** - Launch screen

### Feature Plugins
- **Camera** - Photo capture and gallery
- **Geolocation** - GPS location
- **File** - File system access
- **Dialogs** - Native alerts and prompts
- **Vibration** - Haptic feedback
- **InAppBrowser** - Web view

## Development

### TypeScript Services

Each Cordova plugin has a TypeScript service wrapper:

```typescript
import { CameraService } from './services/CameraService';

const camera = new CameraService();
const imageUrl = await camera.takePicture({
  quality: 75,
  targetWidth: 300,
  targetHeight: 300
});
```

### Building

```bash
# Development build
npm run dev

# Production build
npm run build

# Watch mode
npm run dev -- --watch
```

### Testing

```bash
# Browser testing
npm run browser

# Device testing
npm run android
npm run ios
```

## Platform Configuration

### Android

Edit `config.xml`:
```xml
<preference name="android-minSdkVersion" value="22" />
<preference name="android-targetSdkVersion" value="33" />
```

### iOS

Edit `config.xml`:
```xml
<preference name="deployment-target" value="12.0" />
<preference name="target-device" value="universal" />
```

## Deployment

### Android

1. Build release APK:
```bash
cordova build android --release
```

2. Sign the APK:
```bash
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore my-release-key.keystore platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk alias_name
```

3. Optimize with zipalign:
```bash
zipalign -v 4 app-release-unsigned.apk app-release.apk
```

### iOS

1. Build for release:
```bash
cordova build ios --release --device
```

2. Open in Xcode:
```bash
open platforms/ios/*.xcworkspace
```

3. Archive and upload to App Store Connect

## Plugin Usage Examples

### Camera
```typescript
const camera = new CameraService();
const photo = await camera.takePicture();
const gallery = await camera.selectFromGallery();
```

### Location
```typescript
const location = new LocationService();
const position = await location.getCurrentPosition();
console.log(`Lat: ${position.coords.latitude}, Lng: ${position.coords.longitude}`);
```

### Network
```typescript
const network = new NetworkService();
const isOnline = network.isOnline();
const connectionType = network.getConnectionType();
```

### Dialogs
```typescript
const dialog = new DialogService();
await dialog.showAlert('Hello World!');
const confirmed = await dialog.showConfirm('Are you sure?');
const input = await dialog.showPrompt('Enter your name');
```

## Troubleshooting

### Build Issues
```bash
# Clean and rebuild
npm run clean
cordova prepare
npm run build
```

### Plugin Issues
```bash
# Remove and re-add plugins
cordova plugin rm <plugin-name>
cordova plugin add <plugin-name>
```

### Platform Issues
```bash
# Remove and re-add platform
cordova platform rm android
cordova platform add android
```

## Best Practices

1. **Type Safety** - Always define interfaces for plugin responses
2. **Error Handling** - Wrap plugin calls in try-catch
3. **Permissions** - Check and request permissions before using plugins
4. **Testing** - Test on real devices, not just emulators
5. **Performance** - Minimize plugin calls and cache results

## Resources

- [Apache Cordova Documentation](https://cordova.apache.org/docs/)
- [TypeScript Documentation](https://www.typescriptlang.org/docs/)
- [Webpack Documentation](https://webpack.js.org/concepts/)
- [Cordova Plugins Registry](https://cordova.apache.org/plugins/)

## License

MIT