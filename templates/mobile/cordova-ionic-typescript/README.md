# Cordova Ionic TypeScript Template

A hybrid mobile application template combining Apache Cordova with Ionic Framework and TypeScript for native mobile development.

## Features

- **Ionic Framework 7** - Beautiful UI components
- **Angular 17** - Powerful framework
- **Cordova** - Native device access
- **TypeScript** - Type-safe development
- **Ionic Native** - TypeScript wrappers for Cordova plugins
- **Cross-Platform** - iOS, Android, and Browser
- **Native Plugins** - Camera, GPS, File System, etc.

## Architecture

This template combines:
- **Cordova** for native device capabilities
- **Ionic** for UI components and tooling
- **Angular** for application framework
- **TypeScript** for type safety

## Project Structure

```
├── src/
│   ├── app/              # Angular application
│   │   ├── pages/        # Ionic pages
│   │   ├── services/     # Business logic
│   │   └── components/   # Shared components
│   ├── assets/           # Images, fonts
│   ├── environments/     # Environment configs
│   └── theme/           # SCSS theming
├── www/                  # Build output
├── platforms/           # Platform code
├── plugins/             # Cordova plugins
├── config.xml           # Cordova config
├── ionic.config.json    # Ionic config
└── angular.json         # Angular config
```

## Prerequisites

- Node.js 18+
- npm or yarn
- Ionic CLI: `npm install -g @ionic/cli`
- Cordova CLI: `npm install -g cordova`
- For iOS: macOS with Xcode
- For Android: Android SDK and Java JDK

## Quick Start

```bash
# Install dependencies
npm install

# Add platforms
ionic cordova platform add android
ionic cordova platform add ios
ionic cordova platform add browser

# Serve in browser
ionic serve

# Run on device
ionic cordova run android
ionic cordova run ios
```

## Development Commands

```bash
# Development server
ionic serve

# Build for production
ionic cordova build android --prod
ionic cordova build ios --prod

# Run on emulator
ionic cordova emulate android
ionic cordova emulate ios

# Run on device
ionic cordova run android --device
ionic cordova run ios --device
```

## Native Plugin Usage

### Camera
```typescript
import { Camera, CameraOptions } from '@ionic-native/camera/ngx';

constructor(private camera: Camera) {}

async takePicture() {
  const options: CameraOptions = {
    quality: 100,
    destinationType: this.camera.DestinationType.DATA_URL,
    encodingType: this.camera.EncodingType.JPEG,
    mediaType: this.camera.MediaType.PICTURE
  };

  const imageData = await this.camera.getPicture(options);
  const base64Image = 'data:image/jpeg;base64,' + imageData;
}
```

### Geolocation
```typescript
import { Geolocation } from '@ionic-native/geolocation/ngx';

constructor(private geolocation: Geolocation) {}

async getCurrentLocation() {
  const position = await this.geolocation.getCurrentPosition();
  console.log('Location:', position.coords.latitude, position.coords.longitude);
}
```

### File System
```typescript
import { File } from '@ionic-native/file/ngx';

constructor(private file: File) {}

async writeFile(data: string) {
  await this.file.writeFile(
    this.file.dataDirectory,
    'myfile.txt',
    data,
    { replace: true }
  );
}
```

## Ionic Components

This template includes examples of:
- Ion Menu
- Ion Tabs
- Ion Cards
- Ion Lists
- Ion Forms
- Ion Modals
- Ion Alerts
- Ion Loading

## Building for Production

### Android

```bash
# Build APK
ionic cordova build android --prod --release

# Build AAB (for Play Store)
ionic cordova build android --prod --release -- -- --packageType=bundle
```

### iOS

```bash
# Build for iOS
ionic cordova build ios --prod --release

# Open in Xcode
open platforms/ios/*.xcworkspace
```

## Configuration

### config.xml (Cordova)
```xml
<widget id="com.example.app" version="1.0.0">
    <name>MyApp</name>
    <description>My Ionic Cordova App</description>
    <preference name="ScrollEnabled" value="false" />
    <preference name="BackupWebStorage" value="none" />
</widget>
```

### ionic.config.json
```json
{
  "name": "my-app",
  "integrations": {
    "cordova": {}
  },
  "type": "angular"
}
```

## Platform-Specific Features

### iOS
- Safe area support
- iOS-specific styling
- App Store deployment ready

### Android
- Material Design support
- Google Play deployment ready
- Android-specific permissions

## Testing

```bash
# Unit tests
npm test

# E2E tests
npm run e2e

# Lint
npm run lint
```

## Deployment

### Google Play Store
1. Build signed APK/AAB
2. Upload to Play Console
3. Fill store listing
4. Submit for review

### Apple App Store
1. Build in Xcode
2. Archive and upload
3. Submit in App Store Connect
4. Wait for review

## Troubleshooting

### Common Issues

1. **Build failures**
```bash
# Clean and rebuild
ionic cordova platform rm android
ionic cordova platform add android
ionic cordova build android
```

2. **Plugin conflicts**
```bash
# Remove and re-add plugins
ionic cordova plugin rm <plugin>
ionic cordova plugin add <plugin>
```

3. **iOS signing issues**
- Check provisioning profiles in Xcode
- Verify certificates are valid

## Best Practices

1. **Performance**
   - Use lazy loading for pages
   - Optimize images
   - Minimize plugin usage

2. **Security**
   - Validate all inputs
   - Use HTTPS for APIs
   - Implement proper authentication

3. **UX**
   - Follow platform guidelines
   - Test on real devices
   - Handle offline scenarios

## Resources

- [Ionic Documentation](https://ionicframework.com/docs)
- [Cordova Documentation](https://cordova.apache.org/docs/)
- [Angular Documentation](https://angular.io/docs)
- [Ionic Native Plugins](https://ionicframework.com/docs/native)

## License

MIT