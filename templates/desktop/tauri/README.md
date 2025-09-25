# Tauri Desktop Template

A modern desktop application template using Tauri, React, TypeScript, and Tailwind CSS.

## Features

- **Tauri** - Lightweight, secure desktop app framework
- **React + TypeScript** - Modern frontend development
- **Rust Backend** - High-performance native backend
- **Tailwind CSS** - Utility-first CSS framework
- **File System Access** - Native file operations
- **System Tray** - Background operation support
- **Custom Window Controls** - Native window management
- **IPC Communication** - Seamless frontend-backend communication

## Project Structure

```
├── src/                    # React frontend
│   ├── App.tsx            # Main application component
│   ├── main.tsx           # React entry point
│   └── styles.css         # Global styles with Tailwind
├── src-tauri/             # Rust backend
│   ├── src/
│   │   └── main.rs        # Rust application logic
│   ├── Cargo.toml         # Rust dependencies
│   ├── build.rs           # Build configuration
│   └── tauri.conf.json    # Tauri configuration
├── index.html             # HTML entry point
├── package.json           # Node dependencies
├── vite.config.ts         # Vite configuration
└── tailwind.config.js     # Tailwind configuration
```

## Library Choices

### Why Tauri?
- **Small Bundle Size**: ~10MB vs Electron's ~150MB
- **Memory Efficient**: Uses system WebView instead of bundling Chromium
- **Security**: Rust backend with secure IPC
- **Performance**: Native performance with Rust
- **Cross-Platform**: Windows, macOS, Linux support

### Why React + TypeScript?
- **Component Reusability**: Modular UI development
- **Type Safety**: Catch errors at compile time
- **Large Ecosystem**: Extensive library support
- **Developer Experience**: Excellent tooling and debugging

### Why Rust Backend?
- **Performance**: Near-native speed
- **Memory Safety**: No null pointer exceptions
- **Concurrency**: Safe multi-threading
- **System Access**: Direct OS integration

## Prerequisites

- Node.js 18+ and npm
- Rust and Cargo
- Platform-specific dependencies:
  - **Windows**: Microsoft C++ Build Tools
  - **macOS**: Xcode Command Line Tools
  - **Linux**: webkit2gtk, build-essential

## Development

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build
```

## Tauri Commands

The template includes example Tauri commands:

### Frontend → Backend
```typescript
import { invoke } from '@tauri-apps/api/tauri';

// Call Rust function
const result = await invoke('greet', { name: 'World' });
```

### Backend Implementation
```rust
#[tauri::command]
fn greet(name: &str) -> String {
    format!("Hello, {}!", name)
}
```

## File Operations

```typescript
import { open, save } from '@tauri-apps/api/dialog';
import { readTextFile, writeTextFile } from '@tauri-apps/api/fs';

// Open file dialog
const selected = await open({
  multiple: false,
  filters: [{ name: 'Text', extensions: ['txt'] }]
});

// Read file
const content = await readTextFile(selected);

// Save file
const path = await save();
await writeTextFile(path, content);
```

## Window Management

```typescript
import { appWindow } from '@tauri-apps/api/window';

// Window controls
await appWindow.minimize();
await appWindow.maximize();
await appWindow.close();

// Window state
const isMaximized = await appWindow.isMaximized();
```

## System Tray

The template includes system tray support:
- Click to show/hide window
- Context menu with options
- Background operation capability

## Building for Production

```bash
# Build for current platform
npm run build

# Output will be in src-tauri/target/release/bundle/
```

### Platform-Specific Builds

```bash
# Windows (.msi, .exe)
npm run tauri build -- --target x86_64-pc-windows-msvc

# macOS (.app, .dmg)
npm run tauri build -- --target x86_64-apple-darwin

# Linux (.deb, .AppImage)
npm run tauri build -- --target x86_64-unknown-linux-gnu
```

## Configuration

Edit `src-tauri/tauri.conf.json` to customize:
- App name and version
- Window size and behavior
- Security permissions
- Bundle identifiers
- Icon paths

## Security

Tauri provides secure defaults:
- Content Security Policy
- Isolated contexts
- Permission-based API access
- No remote code execution

## Best Practices

1. **IPC Design**: Keep commands simple and focused
2. **Error Handling**: Handle both JS and Rust errors gracefully
3. **State Management**: Use React state for UI, Rust for business logic
4. **Performance**: Offload heavy computation to Rust
5. **Security**: Validate all user input in Rust backend
6. **Updates**: Implement auto-updater for production apps

## Resources

- [Tauri Documentation](https://tauri.app/docs/)
- [Rust Documentation](https://doc.rust-lang.org/)
- [React Documentation](https://react.dev/)
- [TypeScript Documentation](https://www.typescriptlang.org/docs/)

## License

MIT