# Vue 3 TypeScript Starter Template

A modern, fully-featured Vue 3 TypeScript starter template with Composition API, Pinia, Vite, and comprehensive development tools.

## Features

### Core Technologies
- ⚡ **Vue 3** with Composition API and `<script setup>`
- 🔷 **TypeScript** with strict configuration
- 🚀 **Vite** for lightning-fast development
- 🎨 **Tailwind CSS** for utility-first styling
- 🛣️ **Vue Router 4** for client-side routing
- 🍍 **Pinia** for state management

### Development Tools
- 🧪 **Vitest** for unit testing
- 🔧 **Vue Test Utils** for component testing
- 📏 **ESLint** with Vue and TypeScript rules
- 💅 **Prettier** for code formatting
- 🔍 **TypeScript** strict mode enabled
- 📁 **Path aliases** for clean imports

### Additional Features
- 🌓 **Dark mode** support with Tailwind
- 📱 **Responsive design** components
- 🎯 **Composables** for reusable logic
- 🔄 **LocalStorage integration**
- 📊 **Test coverage** reporting
- 🎭 **Testing UI** with Vitest
- 🔧 **Auto-imports** support

## Project Structure

```
src/
├── components/     # Reusable Vue components
├── views/          # Route components (pages)
├── composables/    # Composition API functions
├── stores/         # Pinia stores
├── utils/          # Utility functions
├── types/          # TypeScript type definitions
├── router/         # Vue Router configuration
└── test/           # Test setup files
```

## Getting Started

### Prerequisites
- Node.js (v18 or higher)
- npm, yarn, or pnpm

### Installation

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Start development server:**
   ```bash
   npm run dev
   ```

3. **Open your browser:**
   Navigate to `http://localhost:3000`

### Available Scripts

| Command | Description |
|---------|-------------|
| `npm run dev` | Start development server with hot reload |
| `npm run build` | Build the project for production |
| `npm run preview` | Preview the production build locally |
| `npm run test` | Run tests once |
| `npm run test:ui` | Run tests with UI interface |
| `npm run test:coverage` | Run tests with coverage report |
| `npm run lint` | Lint and fix code with ESLint |
| `npm run lint:check` | Check linting without fixing |
| `npm run format` | Format code with Prettier |
| `npm run format:check` | Check code formatting |
| `npm run type-check` | Run TypeScript type checking |

## Configuration

### Path Aliases
The template includes pre-configured path aliases:
- `@/*` → `./src/*`
- `@/components/*` → `./src/components/*`
- `@/views/*` → `./src/views/*`
- `@/composables/*` → `./src/composables/*`
- `@/stores/*` → `./src/stores/*`
- `@/utils/*` → `./src/utils/*`
- `@/types/*` → `./src/types/*`

### Tailwind Configuration
Custom colors and utilities are configured in `tailwind.config.js`:
- Primary colors (cyan theme)
- Secondary colors (gray theme)
- Custom component classes in `src/style.css`

### State Management with Pinia
The template uses Pinia with the Composition API approach:
- Setup stores using the `defineStore` function
- Composable-like syntax with `ref`, `computed`, and functions
- TypeScript support out of the box
- Optional persistence with localStorage

## Vue 3 Features

### Composition API
All components use the Composition API with `<script setup>` syntax:
```vue
<template>
  <div>{{ count }}</div>
  <button @click="increment">+</button>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const count = ref(0)
const increment = () => count.value++
</script>
```

### Composables
Create reusable logic with composables:
```typescript
// composables/useCounter.ts
import { ref } from 'vue'

export function useCounter(initialValue = 0) {
  const count = ref(initialValue)
  const increment = () => count.value++
  const decrement = () => count.value--

  return { count, increment, decrement }
}
```

### Reactive State Management
```typescript
// stores/user.ts
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useUserStore = defineStore('user', () => {
  const user = ref<User | null>(null)
  const isLoggedIn = computed(() => !!user.value)

  const login = (userData: User) => {
    user.value = userData
  }

  return { user, isLoggedIn, login }
})
```

## Testing

The template includes a comprehensive testing setup with Vitest:

### Testing Libraries
- **Vitest** as the test runner (Jest-compatible)
- **Vue Test Utils** for component testing
- **jsdom** environment for DOM testing
- **@vitest/ui** for interactive test interface

### Running Tests
```bash
# Run all tests
npm run test

# Run tests with UI
npm run test:ui

# Run tests with coverage
npm run test:coverage
```

### Writing Tests
```typescript
import { describe, it, expect } from 'vitest'
import { mount } from '@vue/test-utils'
import MyComponent from '@/components/MyComponent.vue'

describe('MyComponent', () => {
  it('renders properly', () => {
    const wrapper = mount(MyComponent, {
      props: { msg: 'Hello Vue 3' }
    })

    expect(wrapper.text()).toContain('Hello Vue 3')
  })
})
```

## Code Quality

### ESLint Configuration
- Vue 3 specific rules
- TypeScript integration
- Prettier compatibility
- Custom rules for better code quality

### Prettier Configuration
- Vue-specific formatting
- TypeScript support
- Consistent styling across the project

### TypeScript Configuration
- Strict mode enabled
- Vue SFC support with `vue-tsc`
- Path mapping configured
- Proper typing for Vue Router and Pinia

## Customization

### Adding New Routes
1. Create a new component in `src/views/`
2. Add the route to `src/router/index.ts`
3. Update navigation in `src/components/TheNavbar.vue`

### Creating Stores
1. Create a new store file in `src/stores/`
2. Use the Composition API syntax with `defineStore`
3. Export and use in components

### Adding Composables
1. Create new composables in `src/composables/`
2. Follow the `use` naming convention
3. Return reactive values and functions

## Deployment

### Build for Production
```bash
npm run build
```

The build artifacts will be stored in the `dist/` directory.

### Environment Variables
Create a `.env.local` file:
```env
VITE_API_URL=https://api.example.com
VITE_APP_TITLE=My Vue App
```

Access in your code:
```typescript
const apiUrl = import.meta.env.VITE_API_URL
```

### Deployment Platforms
This template works with all major platforms:
- **Vercel**: Zero-config deployment
- **Netlify**: Drag and drop or Git integration
- **GitHub Pages**: Static site hosting
- **Docker**: Containerized deployment

## Browser Support

This template supports all modern browsers:
- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)

## Performance

### Built-in Optimizations
- **Tree shaking** with Vite
- **Code splitting** with Vue Router
- **Lazy loading** for route components
- **Component caching** with KeepAlive
- **Bundle analysis** available

### Performance Tips
- Use `shallowRef` for large objects
- Implement virtual scrolling for long lists
- Use `defineAsyncComponent` for heavy components
- Optimize images and assets

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Resources

- [Vue 3 Documentation](https://vuejs.org/)
- [Vite Documentation](https://vitejs.dev/)
- [Pinia Documentation](https://pinia.vuejs.org/)
- [Vue Router Documentation](https://router.vuejs.org/)
- [Vitest Documentation](https://vitest.dev/)

---

Happy coding with Vue 3! 🚀