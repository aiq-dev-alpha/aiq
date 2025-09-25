# Svelte TypeScript Template

A modern, production-ready Svelte TypeScript template with SvelteKit, Tailwind CSS, and comprehensive tooling setup.

## Features

- **SvelteKit** - Full-stack framework with SSR/SSG support
- **TypeScript** - Type-safe development experience
- **Tailwind CSS** - Utility-first CSS framework
- **Vite** - Lightning-fast build tool
- **ESLint & Prettier** - Code quality and formatting
- **Component Architecture** - Reusable Svelte components
- **Stores** - State management with Svelte stores
- **Routing** - File-based routing with layouts
- **API Integration** - Axios setup with interceptors

## Project Structure

```
├── src/
│   ├── app.html          # HTML template
│   ├── app.css          # Global styles with Tailwind
│   ├── app.d.ts         # TypeScript app definitions
│   ├── lib/             # Shared components and utilities
│   │   ├── Counter.svelte    # Example component
│   │   ├── stores.ts        # Svelte stores
│   │   └── api.ts          # API client setup
│   └── routes/          # File-based routing
│       ├── +layout.svelte   # Root layout
│       ├── +page.svelte     # Home page
│       ├── about/          # About page
│       └── todos/          # Todo list demo
├── static/              # Static assets
├── package.json         # Dependencies
├── svelte.config.js    # SvelteKit configuration
├── vite.config.ts      # Vite configuration
├── tsconfig.json       # TypeScript configuration
└── tailwind.config.js  # Tailwind configuration
```

## Library Choices

### Why SvelteKit?
- **Performance**: Compile-time optimizations, no virtual DOM
- **Simplicity**: Less boilerplate than React/Vue
- **Full-stack**: Built-in SSR, routing, and API routes
- **Developer Experience**: Intuitive reactivity model

### Why Tailwind CSS?
- **Rapid Development**: Utility classes for quick styling
- **Consistency**: Design system out of the box
- **Performance**: PurgeCSS removes unused styles
- **Responsive**: Mobile-first responsive design utilities

### Why TypeScript?
- **Type Safety**: Catch errors at compile time
- **Better IDE Support**: Autocomplete and refactoring
- **Documentation**: Types serve as inline documentation
- **Scalability**: Essential for large applications

### Why Vite?
- **Speed**: Instant server start and HMR
- **ESM**: Native ES modules support
- **Optimized Builds**: Automatic code splitting
- **Plugin Ecosystem**: Rich plugin ecosystem

## Development

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview

# Run type checking
npm run check

# Lint code
npm run lint

# Format code
npm run format
```

## Svelte Concepts

### Components
```svelte
<script lang="ts">
  export let name: string;
</script>

<h1>Hello {name}!</h1>
```

### Stores
```typescript
import { writable } from 'svelte/store';

export const count = writable(0);
```

### Reactivity
```svelte
<script lang="ts">
  let count = 0;
  $: doubled = count * 2;
</script>
```

### Lifecycle
```typescript
import { onMount } from 'svelte';

onMount(() => {
  console.log('Component mounted');
  return () => console.log('Component destroyed');
});
```

## Best Practices

1. **Component Organization**: Keep components small and focused
2. **Type Safety**: Always use TypeScript for props and stores
3. **State Management**: Use stores for shared state
4. **Performance**: Use `{#key}` blocks for list rendering
5. **Accessibility**: Include proper ARIA attributes
6. **Testing**: Write tests for critical functionality
7. **Code Splitting**: Leverage dynamic imports for large components

## Production Deployment

```bash
# Build the application
npm run build

# The build output will be in the build/ directory
# Deploy to your hosting platform (Vercel, Netlify, etc.)
```

### Environment Variables
Create a `.env` file for environment-specific configuration:
```env
VITE_API_URL=http://localhost:3000/api
```

## Resources

- [Svelte Documentation](https://svelte.dev/docs)
- [SvelteKit Documentation](https://kit.svelte.dev/docs)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [TypeScript Documentation](https://www.typescriptlang.org/docs/)

## License

MIT