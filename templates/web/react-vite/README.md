# React + Vite + TypeScript Template

A modern, production-ready React application template with Vite, TypeScript, Redux Toolkit, React Query, and Tailwind CSS.

## 🚀 Features

- **Vite** - Lightning fast build tool with instant HMR
- **React 18** - Latest React with concurrent features
- **TypeScript** - Type safety and better developer experience
- **Redux Toolkit** - Modern Redux with less boilerplate
- **React Query** - Powerful data synchronization for server state
- **React Router v6** - Declarative routing
- **React Hook Form** - Performant forms with easy validation
- **Tailwind CSS** - Utility-first CSS framework
- **Zod** - TypeScript-first schema validation
- **Axios** - Promise-based HTTP client
- **Vitest** - Unit testing framework
- **ESLint** - Code linting and formatting

## 📁 Project Structure

```
├── public/                   # Static assets
├── src/
│   ├── components/          # Reusable UI components
│   │   ├── Layout.tsx      # Main layout wrapper
│   │   ├── Header.tsx      # App header
│   │   └── Sidebar.tsx     # Navigation sidebar
│   ├── pages/              # Page components
│   │   ├── HomePage.tsx    # Landing page
│   │   ├── LoginPage.tsx   # Authentication
│   │   ├── DashboardPage.tsx
│   │   └── NotFoundPage.tsx
│   ├── hooks/              # Custom React hooks
│   │   └── useAuth.ts      # Authentication hook
│   ├── services/           # API service layer
│   │   └── api.ts          # Axios configuration
│   ├── store/              # Redux store
│   │   ├── index.ts        # Store configuration
│   │   └── slices/         # Redux slices
│   │       ├── authSlice.ts
│   │       └── uiSlice.ts
│   ├── types/              # TypeScript type definitions
│   ├── utils/              # Utility functions
│   ├── App.tsx             # Main app component
│   ├── main.tsx            # Application entry point
│   └── index.css           # Global styles
├── vite.config.ts          # Vite configuration
├── tsconfig.json           # TypeScript configuration
├── tailwind.config.js      # Tailwind CSS configuration
└── package.json            # Dependencies and scripts
```

## 📦 Dependencies & Library Choices

### 🎯 Core Framework
| Library | Version | Why We Chose It |
|---------|---------|-----------------|
| **React** | `18.2` | Industry standard, excellent ecosystem, concurrent features |
| **Vite** | `5.0` | Fastest build tool, instant HMR, native ESM support |
| **TypeScript** | `5.3` | Type safety, better IDE support, fewer runtime errors |

### 🗂️ State Management
| Library | Purpose | Why This Choice |
|---------|---------|----------------|
| **Redux Toolkit** | Global state | Official Redux solution, less boilerplate, built-in best practices |
| **React Query** | Server state | Caching, synchronization, background updates, optimistic updates |
| **React Hook Form** | Form state | Better performance, less re-renders, easy validation |

### 🎨 Styling & UI
| Library | Purpose | Benefits |
|---------|---------|---------|
| **Tailwind CSS** | Styling | Utility-first, no CSS-in-JS runtime, smaller bundles |
| **PostCSS** | CSS processing | Autoprefixer, modern CSS features |

### 🔧 Development Tools
| Library | Purpose | Features |
|---------|---------|---------|
| **Zod** | Schema validation | TypeScript-first, composable, runtime + compile-time safety |
| **Axios** | HTTP client | Interceptors, request/response transformation, better error handling |
| **Vitest** | Testing | Vite-native, fast, Jest-compatible API |

### 🔄 Why These Libraries?

**Vite over Create React App:**
- 10-100x faster cold starts
- Instant Hot Module Replacement
- Optimized production builds
- Native ESM support
- Better TypeScript performance

**Redux Toolkit over Context API:**
- Better DevTools
- Time-travel debugging
- Predictable state updates
- Middleware support
- Better performance for complex apps

**React Query over SWR:**
- More features out of the box
- Better DevTools
- Optimistic updates
- Infinite queries support
- Larger community

**Tailwind over Styled Components:**
- No runtime overhead
- Smaller bundle sizes
- Better performance
- Consistent design system
- Easier to maintain

**Zod over Yup:**
- TypeScript-first design
- Better type inference
- Smaller bundle size
- Composable schemas
- Better error messages

## 🛠️ Setup

### Prerequisites
- Node.js 18 or higher
- npm or yarn
- Git

### Using the Template

1. **Run the setup script:**
   ```bash
   ./setup-template.sh my-app ~/projects/
   ```

2. **Navigate to project:**
   ```bash
   cd ~/projects/my-app
   ```

3. **Start development server:**
   ```bash
   npm run dev
   ```

### Manual Setup

1. **Copy template:**
   ```bash
   cp -r react-vite-template my-app
   cd my-app
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Start development:**
   ```bash
   npm run dev
   ```

## 📝 Available Scripts

```bash
# Development
npm run dev           # Start dev server at http://localhost:3000
npm run build        # Build for production
npm run preview      # Preview production build

# Testing
npm run test         # Run tests
npm run test:ui      # Run tests with UI
npm run test:coverage # Generate coverage report

# Code Quality
npm run lint         # Lint code
npm run type-check   # Type checking
```

## 🏗️ Architecture Decisions

### Component Structure
- **Pages**: Route-level components
- **Components**: Reusable UI components
- **Hooks**: Custom React hooks for logic reuse
- **Services**: API communication layer

### State Management Strategy
- **Redux**: Authentication, UI state, app-wide state
- **React Query**: Server data, caching, synchronization
- **Component State**: Local UI state
- **React Hook Form**: Form data and validation

### TypeScript Configuration
- Strict mode enabled
- Path aliases for cleaner imports
- No implicit any
- Consistent return types

## 🔐 Authentication Flow

```typescript
// Login flow
1. User submits credentials
2. API validates and returns JWT token
3. Token stored in localStorage
4. Redux state updated
5. Axios interceptor adds token to requests
6. Protected routes become accessible

// Logout flow
1. Clear Redux state
2. Remove token from localStorage
3. Redirect to login page
```

## 🎨 Styling Guidelines

### Tailwind Classes Organization
```tsx
// Recommended order
<div className="
  {/* Layout */}
  flex items-center justify-between
  {/* Spacing */}
  p-4 m-2
  {/* Sizing */}
  w-full h-32
  {/* Typography */}
  text-lg font-bold
  {/* Colors */}
  bg-white text-gray-900
  {/* Borders */}
  border border-gray-200 rounded-lg
  {/* Effects */}
  shadow-md hover:shadow-lg
  {/* Transitions */}
  transition-all duration-200
">
```

## 🧪 Testing

```typescript
// Component testing example
import { render, screen } from '@testing-library/react'
import { describe, it, expect } from 'vitest'
import Button from './Button'

describe('Button', () => {
  it('renders with text', () => {
    render(<Button>Click me</Button>)
    expect(screen.getByText('Click me')).toBeInTheDocument()
  })
})
```

## 🚀 Deployment

### Production Build
```bash
npm run build
# Output in dist/ directory
```

### Environment Variables
```bash
# .env.production
VITE_API_URL=https://api.example.com
```

### Deployment Options
- **Vercel**: Zero config deployment
- **Netlify**: Drag and drop deployment
- **AWS S3 + CloudFront**: Static hosting
- **Docker**: Containerized deployment

## 🎯 Best Practices

### Performance
- Code splitting with React.lazy()
- Image optimization
- Bundle size monitoring
- Lighthouse audits

### Code Quality
- Consistent file naming
- Type everything
- Extract reusable logic to hooks
- Keep components focused

### Security
- Sanitize user input
- Validate API responses
- Use HTTPS in production
- Keep dependencies updated

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Open Pull Request

## 📄 License

MIT License

## 🆘 Support

- [React Documentation](https://react.dev/)
- [Vite Documentation](https://vitejs.dev/)
- [Redux Toolkit Documentation](https://redux-toolkit.js.org/)
- [React Query Documentation](https://tanstack.com/query/)
- [Tailwind CSS Documentation](https://tailwindcss.com/)

---

Built with ❤️ using React, Vite, and TypeScript