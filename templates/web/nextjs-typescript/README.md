# Next.js 14 TypeScript Template

A modern, production-ready Next.js 14 template with TypeScript, Tailwind CSS, NextAuth.js, and more. Built with the latest features including App Router, Server Components, and comprehensive tooling setup.

## ✨ Features

### Core Technologies
- **Next.js 14** - Latest version with App Router and Server Components
- **TypeScript** - Full type safety with strict configuration
- **Tailwind CSS** - Utility-first CSS framework for rapid UI development
- **shadcn/ui** - Beautiful, accessible components built on Radix UI

### Authentication & Security
- **NextAuth.js** - Complete authentication solution
- **Multiple OAuth Providers** - Google, GitHub support out of the box
- **Credentials Authentication** - Email/password login with bcrypt
- **Session Management** - JWT-based sessions with secure configuration

### Developer Experience
- **ESLint + Prettier** - Code linting and formatting
- **TypeScript Strict Mode** - Catch errors early with strict type checking
- **Path Aliases** - Clean imports with @ prefixes
- **Hot Reload** - Fast development with instant updates

### UI & Styling
- **Dark Mode Support** - Built-in theme switching with next-themes
- **Responsive Design** - Mobile-first approach with Tailwind breakpoints
- **Component Library** - Pre-built components following best practices
- **Icon Library** - Lucide React icons included

### SEO & Performance
- **SEO Optimized** - Meta tags, Open Graph, Twitter Cards
- **Performance Optimized** - Lighthouse-ready configuration
- **Image Optimization** - Next.js Image component with optimization
- **Font Optimization** - Google Fonts with display optimization

## 📁 Project Structure

```
├── app/                    # App Router directory
│   ├── api/               # API routes
│   │   ├── auth/          # Authentication endpoints
│   │   └── users/         # User management endpoints
│   ├── auth/              # Authentication pages
│   │   ├── signin/        # Sign in page
│   │   └── signup/        # Sign up page
│   ├── dashboard/         # Dashboard pages
│   ├── globals.css        # Global styles
│   ├── layout.tsx         # Root layout component
│   ├── page.tsx           # Home page
│   ├── loading.tsx        # Loading UI
│   ├── error.tsx          # Error UI
│   └── not-found.tsx      # 404 page
├── components/            # Reusable components
│   ├── ui/                # UI components (shadcn/ui)
│   ├── forms/             # Form components
│   ├── layout/            # Layout components
│   └── providers/         # Context providers
├── lib/                   # Utility libraries
│   ├── auth.ts            # NextAuth configuration
│   ├── utils.ts           # Utility functions
│   └── validations.ts     # Zod validation schemas
├── public/                # Static assets
├── styles/                # Additional styles
└── types/                 # TypeScript type definitions
```

## 🚀 Quick Start

### Prerequisites

- Node.js 18.17.0 or later
- npm, yarn, or pnpm

### Installation

1. **Use the setup script** (recommended):
   ```bash
   ./setup-template.sh my-project /path/to/destination
   ```

2. **Or manually clone and setup**:
   ```bash
   git clone <repository-url> my-project
   cd my-project
   npm install
   cp .env.example .env.local
   ```

### Development

1. **Start the development server**:
   ```bash
   npm run dev
   ```

2. **Open your browser** and visit [http://localhost:3000](http://localhost:3000)

### Environment Configuration

1. **Copy the environment file**:
   ```bash
   cp .env.example .env.local
   ```

2. **Configure your environment variables**:
   ```env
   NEXTAUTH_URL=http://localhost:3000
   NEXTAUTH_SECRET=your-secret-key

   # OAuth Providers
   GOOGLE_CLIENT_ID=your-google-client-id
   GOOGLE_CLIENT_SECRET=your-google-client-secret

   GITHUB_CLIENT_ID=your-github-client-id
   GITHUB_CLIENT_SECRET=your-github-client-secret
   ```

## 🔐 Authentication Setup

### OAuth Providers

#### Google OAuth
1. Go to the [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable Google+ API
4. Create OAuth 2.0 credentials
5. Add authorized redirect URI: `http://localhost:3000/api/auth/callback/google`

#### GitHub OAuth
1. Go to GitHub Settings > Developer settings > OAuth Apps
2. Create a new OAuth App
3. Set Authorization callback URL: `http://localhost:3000/api/auth/callback/github`

### Credentials Authentication

The template includes a demo credentials provider. In production:
1. Replace the mock user lookup with actual database queries
2. Implement proper password hashing with bcrypt
3. Add user registration functionality

## 🎨 Customization

### Adding New Components

1. **Create component file**:
   ```typescript
   // components/ui/my-component.tsx
   import { cn } from '@/lib/utils'

   interface MyComponentProps {
     className?: string
     children: React.ReactNode
   }

   export function MyComponent({ className, children }: MyComponentProps) {
     return (
       <div className={cn('default-classes', className)}>
         {children}
       </div>
     )
   }
   ```

2. **Export from index** (optional):
   ```typescript
   // components/ui/index.ts
   export { MyComponent } from './my-component'
   ```

### Styling Guidelines

- Use Tailwind utility classes for styling
- Follow the established color palette in `tailwind.config.ts`
- Utilize the `cn()` utility for conditional classes
- Maintain consistent spacing and typography scales

### Adding New Pages

1. **Create page file** in the `app` directory:
   ```typescript
   // app/my-page/page.tsx
   import { Metadata } from 'next'

   export const metadata: Metadata = {
     title: 'My Page',
     description: 'Description of my page',
   }

   export default function MyPage() {
     return <div>My Page Content</div>
   }
   ```

2. **Add navigation** (if needed) in layout or navigation components

## 🛠️ Available Scripts

```bash
npm run dev          # Start development server
npm run build        # Build for production
npm run start        # Start production server
npm run lint         # Run ESLint
npm run lint:fix     # Fix ESLint issues
npm run type-check   # Run TypeScript type checking
npm run format       # Format code with Prettier
npm run format:check # Check code formatting
```

## 📦 Dependencies

### Core Dependencies
- `next` - React framework
- `react` & `react-dom` - React library
- `typescript` - TypeScript support
- `next-auth` - Authentication
- `next-themes` - Theme management

### UI Dependencies
- `@radix-ui/*` - Accessible UI primitives
- `tailwindcss` - CSS framework
- `class-variance-authority` - Component variants
- `clsx` & `tailwind-merge` - Conditional classes
- `lucide-react` - Icon library

### Form & Validation
- `react-hook-form` - Form management
- `@hookform/resolvers` - Form validation resolvers
- `zod` - Schema validation

### Development Dependencies
- `eslint` - Code linting
- `prettier` - Code formatting
- `@typescript-eslint/*` - TypeScript ESLint rules

## 🚀 Deployment

### Vercel (Recommended)

1. **Push your code** to a Git repository
2. **Connect your repository** to Vercel
3. **Configure environment variables** in Vercel dashboard
4. **Deploy** - Vercel will automatically build and deploy

### Other Platforms

The template works with any platform that supports Next.js:
- Netlify
- Railway
- DigitalOcean App Platform
- AWS Amplify

Make sure to:
1. Set `NEXTAUTH_URL` to your production URL
2. Configure all environment variables
3. Update OAuth redirect URIs

## 🔧 Troubleshooting

### Common Issues

**NextAuth callback URL mismatch**
- Ensure `NEXTAUTH_URL` matches your domain
- Update OAuth provider redirect URIs

**Build errors**
- Run `npm run type-check` to find TypeScript errors
- Check for unused imports with `npm run lint`

**Styling not loading**
- Verify Tailwind configuration
- Check PostCSS setup
- Ensure CSS imports are correct

### Getting Help

- Check the [Next.js documentation](https://nextjs.org/docs)
- Visit [NextAuth.js documentation](https://next-auth.js.org/)
- Review [Tailwind CSS documentation](https://tailwindcss.com/docs)
- Check [shadcn/ui documentation](https://ui.shadcn.com/)

## 📄 License

This template is open source and available under the [MIT License](LICENSE).

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support

If you have any questions or run into issues, please open an issue on the repository.

---

**Happy coding!** 🎉