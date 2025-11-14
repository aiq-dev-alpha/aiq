# AIQ Snippets Structure Documentation

## Overview

This directory contains a comprehensive collection of UI components, screens, flows, and patterns organized by framework and version. All files and folders use **snake_case** naming convention for consistency.

## Directory Structure

```
snippets/
├── screens/          # Individual screen components
├── components/       # Reusable UI components
├── u_flow/          # User flow patterns
├── navigation/       # Navigation patterns
├── state/           # State management examples
├── data/            # Data handling patterns
└── apps/            # Full application examples
```

## Naming Convention

- **Folders**: `snake_case` (e.g., `login_screen`, `product_list`)
- **Files**: `snake_case` (e.g., `login_screen.tsx`, `product_list.jsx`)
- **Versioning**: Numeric folders (e.g., `/1/`, `/2/`, `/3/`)

## Versioned Structure

All screens, components, and flows now support multiple versions with different UI/UX implementations:

### Example Structure
```
screens/
└── react/
    ├── login_screen/
    │   ├── 1/
    │   │   ├── login_screen.tsx
    │   │   └── login_screen.css
    │   ├── 2/
    │   │   ├── login_screen.tsx
    │   │   └── login_screen.css
    │   └── 3/
    │       ├── login_screen.tsx
    │       └── login_screen.css
    └── product_list_screen/
        ├── 1/
        │   └── product_list_screen.jsx
        └── 2/
            └── product_list_screen.jsx
```

## Screens

### React Screens

All React screens are organized in versioned folders with different design approaches:

#### Login Screens
- **Version 1**: Traditional card-based design with emoji icons
- **Version 2**: Gradient background with floating card and social login
- **Version 3**: Minimal split-screen design with geometric patterns

#### Product List Screens
- **Version 1**: Grid/List toggle view with filters
- **Version 2**: Carousel/Slider layout with category sections

#### Available Screens (All Frameworks)
- `login_screen` - User authentication
- `signup_screen` - User registration
- `profile_screen` - User profile
- `product_list_screen` - Product catalog
- `product_detail_screen` - Product details
- `cart_screen` - Shopping cart
- `search_screen` - Search interface
- `advanced_search_screen` - Advanced search filters
- `article_list_screen` - Article/blog listing
- `onboarding_carousel_screen` - App introduction
- `welcome_screen` - Welcome/landing
- `splash_screen` - App splash screen
- `loading_screen` - Loading state
- `error_screen` - Error state
- `success_screen` - Success state
- `empty_state_screen` - Empty state
- `maintenance_screen` - Maintenance mode
- `forgot_password_screen` - Password recovery
- `reset_password_screen` - Password reset
- `otp_verification_screen` - OTP verification
- `biometric_auth_screen` - Biometric authentication
- `two_factor_auth_screen` - 2FA authentication
- `social_login_screen` - Social media login
- `permissions_screen` - App permissions
- `tutorial_screen` - Tutorial/walkthrough
- `setup_profile_screen` - Profile setup
- `choose_interests_screen` - Interest selection
- `survey_screen` - Survey/questionnaire
- `contact_form_screen` - Contact form

### Angular/Ionic Screens

Organized with component/page structure:
- Files: `*.component.ts`, `*.page.ts`
- Styles: `*.component.scss`, `*.page.scss`
- Templates: `*.component.html`, `*.page.html`

### Compose (Android) Screens

Kotlin Compose screens organized by type:
- Single file: `*.kt`
- Supports Material Design 3

### React Native Screens

Mobile-optimized screens:
- TypeScript: `*.tsx`
- JavaScript: `*.jsx`, `*.js`

## Components

### React Components

Each component has 3 versions with different design styles:

#### Button Component
- **Version 1**: Solid fill with hover effects
- **Version 2**: Outlined with gradient hover
- **Version 3**: Glassmorphism style

#### Available Components
- `button/` - Action buttons
- `card/` - Content cards
- `modal/` - Modal dialogs
- `navigation/` - Navigation bars
- `form_input/` - Form inputs
- `dropdown/` - Dropdown menus
- `toast/` - Toast notifications
- `tabs/` - Tab navigation
- `accordion/` - Accordion panels
- `sidebar/` - Side navigation

#### Component Features
- Multiple size variants (sm, md, lg)
- Color variants (primary, secondary, success, danger, warning, info)
- Loading states
- Icon support
- Accessibility features

## UI Flows

### Authentication Flow
- **Version 1**: Step-by-step traditional flow
  - Login → Signup → Forgot Password → Email Verification → Success
- **Version 2**: Tab-based interface
  - Side-by-side login/signup with social auth options

### Available Flows
- `auth_flow/` - Authentication flow
- `onboarding_flow/` - User onboarding
- `checkout_flow/` - E-commerce checkout
- `profile_setup_flow/` - Profile configuration

## Framework Support

### Web Frameworks
- React (`.jsx`, `.tsx`)
- Vue (`.vue`)
- Angular (`.component.ts`, `.page.ts`)
- Svelte (`.svelte`)

### Mobile Frameworks
- React Native (`.jsx`, `.tsx`)
- Flutter (`.dart`)
- SwiftUI (`.swift`)
- Jetpack Compose (`.kt`)
- Ionic (Angular/React)

## Version Philosophy

Each version represents a distinct UI/UX approach:

1. **Version 1**: Traditional/Conservative
   - Proven patterns
   - High compatibility
   - Classic design language

2. **Version 2**: Modern/Trendy
   - Contemporary design
   - Rich interactions
   - Enhanced visuals

3. **Version 3**: Experimental/Cutting-edge
   - Innovative patterns
   - Advanced effects
   - Modern CSS features

## Usage

### Importing a Component

```typescript
// React Button v1
import { Button } from './components/react/button/1/button';

// React Button v2
import { Button } from './components/react/button/2/button';

// React Button v3
import { Button } from './components/react/button/3/button';
```

### Using Different Screen Versions

```typescript
// Login Screen v1 - Traditional
import { LoginScreen } from './screens/react/login_screen/1/login_screen';

// Login Screen v2 - Gradient design
import { LoginScreen } from './screens/react/login_screen/2/login_screen';

// Login Screen v3 - Minimal split-screen
import { LoginScreen } from './screens/react/login_screen/3/login_screen';
```

## Best Practices

1. **Choose the right version** based on your design system
2. **Maintain consistency** within your application
3. **Customize as needed** - these are starting points
4. **Consider accessibility** - all versions include a11y features
5. **Test across devices** - especially for mobile frameworks

## Contributing

When adding new versions:

1. Create a new numbered folder (e.g., `/4/`)
2. Follow the snake_case naming convention
3. Include all necessary files (component + styles)
4. Document the version's unique approach
5. Test for accessibility and responsiveness

## Migration Guide

If you have existing PascalCase files:

```bash
# Use the provided rename script
./scripts/rename_to_snake_case.sh
```

This will:
- Convert all filenames to snake_case
- Organize files into versioned folders
- Preserve file extensions and content

## Future Additions

Planned additions:
- More component variations
- Advanced animation examples
- Dark mode variants
- Accessibility-focused versions
- Framework-specific optimizations
- Performance-optimized versions

## Support

For questions or issues:
1. Check the version documentation
2. Review the example implementations
3. Refer to framework-specific guidelines
4. Test in your target environment

---

**Last Updated**: 2025-11-14
**Structure Version**: 2.0
