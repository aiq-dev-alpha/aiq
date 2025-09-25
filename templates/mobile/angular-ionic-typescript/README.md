# Angular Ionic TypeScript Template

A production-ready mobile application template using Angular, Ionic Framework, and Capacitor.

## Features

- **Angular 17** - Modern Angular with standalone components support
- **Ionic 7** - Beautiful UI components and native functionality
- **Capacitor 5** - Native runtime for iOS, Android, and PWA
- **TypeScript** - Type-safe development
- **Ionic Storage** - Key-value storage with SQLite support
- **HTTP Client** - API integration ready
- **Side Menu Navigation** - Pre-configured menu layout
- **Dark Mode Support** - Automatic theme switching
- **Native Plugins** - Camera, Geolocation, Push Notifications ready

## Project Structure

```
├── src/
│   ├── app/
│   │   ├── pages/          # Application pages
│   │   ├── services/        # Shared services
│   │   ├── components/      # Shared components
│   │   ├── guards/          # Route guards
│   │   ├── models/          # TypeScript interfaces
│   │   ├── app.component.*  # Root component
│   │   └── app.module.ts    # Root module
│   ├── assets/              # Images, fonts, etc.
│   ├── environments/        # Environment configs
│   ├── theme/              # SCSS variables and theming
│   └── global.scss         # Global styles
├── capacitor.config.json    # Capacitor configuration
├── ionic.config.json       # Ionic configuration
├── angular.json           # Angular configuration
└── package.json           # Dependencies
```

## Library Choices

### Why Ionic + Angular?
- **Enterprise Ready**: Angular's robust architecture
- **Rich Component Library**: 100+ mobile-optimized components
- **Native Access**: Capacitor provides full native API access
- **Cross-Platform**: iOS, Android, PWA from single codebase
- **Active Community**: Large ecosystem and support

### Why Capacitor over Cordova?
- **Modern Architecture**: Built with modern web APIs
- **Better Performance**: Native project management
- **PWA Support**: First-class Progressive Web App support
- **Plugin Compatibility**: Supports Cordova plugins
- **Better Developer Experience**: Easier debugging

### Key Dependencies
- **@ionic/angular** - Ionic Angular integration
- **@capacitor/core** - Native runtime
- **@ionic/storage-angular** - Encrypted storage
- **rxjs** - Reactive programming
- **@angular/common/http** - HTTP client

## Development

```bash
# Install dependencies
npm install

# Serve in browser
ionic serve

# Add platforms
ionic capacitor add ios
ionic capacitor add android

# Run on device/emulator
ionic capacitor run ios
ionic capacitor run android

# Build for production
ionic build --prod
```

## Capacitor Plugins

Pre-configured plugins:
- **Camera** - Photo capture and gallery
- **Filesystem** - File operations
- **Geolocation** - GPS location
- **Network** - Network status
- **Push Notifications** - Remote notifications
- **Splash Screen** - App launch screen
- **Status Bar** - System status bar
- **Storage** - Secure key-value storage

## Native Features

### Camera Usage
```typescript
import { Camera, CameraResultType } from '@capacitor/camera';

const image = await Camera.getPhoto({
  quality: 90,
  allowEditing: true,
  resultType: CameraResultType.Uri
});
```

### Geolocation
```typescript
import { Geolocation } from '@capacitor/geolocation';

const coordinates = await Geolocation.getCurrentPosition();
console.log('Current', coordinates);
```

### Push Notifications
```typescript
import { PushNotifications } from '@capacitor/push-notifications';

await PushNotifications.requestPermissions();
await PushNotifications.register();
```

## Theming

Edit `src/theme/variables.scss`:
```scss
:root {
  --ion-color-primary: #3880ff;
  --ion-color-secondary: #3dc2ff;
  // ... customize colors
}
```

## Building for Production

### iOS
```bash
ionic capacitor build ios --prod
# Open in Xcode and deploy
```

### Android
```bash
ionic capacitor build android --prod
# Open in Android Studio and deploy
```

### PWA
```bash
ionic build --prod
# Deploy www folder to web server
```

## Best Practices

1. **Lazy Loading**: Use Angular lazy loading for pages
2. **Offline Support**: Implement service workers for PWA
3. **Performance**: Use OnPush change detection
4. **Security**: Validate all inputs, use HTTPS
5. **Testing**: Write unit and e2e tests
6. **Accessibility**: Follow WCAG guidelines

## Common Commands

```bash
# Generate new page
ionic generate page pages/my-page

# Generate service
ionic generate service services/my-service

# Generate component
ionic generate component components/my-component

# Update Capacitor
npm update @capacitor/core @capacitor/cli

# Sync native projects
ionic capacitor sync
```

## Deployment

### App Store (iOS)
1. Build in Xcode with production profile
2. Archive and upload to App Store Connect
3. Submit for review

### Google Play (Android)
1. Build signed APK/AAB in Android Studio
2. Upload to Google Play Console
3. Submit for review

### Web (PWA)
1. Build with `ionic build --prod`
2. Deploy `www` folder to hosting service
3. Ensure HTTPS and service worker

## Resources

- [Ionic Documentation](https://ionicframework.com/docs)
- [Angular Documentation](https://angular.io/docs)
- [Capacitor Documentation](https://capacitorjs.com/docs)
- [Ionic Components](https://ionicframework.com/docs/components)

## License

MIT