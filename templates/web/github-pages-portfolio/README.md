# GitHub Pages Portfolio Template

A modern, responsive portfolio website template built with Next.js, TypeScript, and Tailwind CSS, optimized for GitHub Pages deployment.

## Features

- **Next.js 14** - Static site generation for GitHub Pages
- **TypeScript** - Type-safe development
- **Tailwind CSS** - Utility-first styling
- **Framer Motion** - Smooth animations
- **Dark Mode** - Automatic theme switching
- **Responsive Design** - Mobile-first approach
- **SEO Optimized** - Meta tags and structured data
- **GitHub Pages Ready** - Configured for easy deployment

## Sections

1. **Hero** - Eye-catching introduction with CTA buttons
2. **About** - Personal introduction and statistics
3. **Skills** - Technical skills organized by category
4. **Projects** - Portfolio showcase with live demos
5. **Experience** - Professional work history
6. **Contact** - Contact form and information
7. **Navigation** - Smooth scroll navigation

## Quick Start

```bash
# Install dependencies
npm install

# Run development server
npm run dev

# Build for production
npm run build

# Deploy to GitHub Pages
npm run deploy
```

## Deployment to GitHub Pages

### Method 1: Using gh-pages Package (Recommended)

1. Update `next.config.js` with your repository name:
```javascript
const nextConfig = {
  basePath: '/your-repo-name',
  assetPrefix: '/your-repo-name',
}
```

2. Build and deploy:
```bash
npm run deploy
```

### Method 2: GitHub Actions

Create `.github/workflows/deploy.yml`:
```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [main]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - uses: actions/setup-node@v3
        with:
          node-version: '18'

      - run: npm ci
      - run: npm run build
      - run: touch ./out/.nojekyll

      - uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./out
```

### Method 3: Manual Deployment

1. Build the project:
```bash
npm run build
npm run export
```

2. Create `.nojekyll` file in `out` directory:
```bash
touch out/.nojekyll
```

3. Push to `gh-pages` branch:
```bash
git add out/
git commit -m "Deploy to GitHub Pages"
git subtree push --prefix out origin gh-pages
```

## Customization

### Personal Information
Edit components to add your information:
- `src/components/Hero.tsx` - Name and title
- `src/components/About.tsx` - Bio and statistics
- `src/components/Skills.tsx` - Your technical skills
- `src/components/Projects.tsx` - Your projects
- `src/components/Experience.tsx` - Work history
- `src/components/Contact.tsx` - Contact details

### Styling
- Edit `tailwind.config.js` for theme customization
- Modify `src/styles/globals.css` for global styles
- Update color scheme in component files

### Images
Place your images in `public/` directory and reference them in components.

## Project Structure

```
├── src/
│   ├── pages/           # Next.js pages
│   ├── components/       # React components
│   └── styles/          # CSS files
├── public/              # Static assets
├── next.config.js       # Next.js configuration
├── tailwind.config.js   # Tailwind configuration
├── tsconfig.json        # TypeScript configuration
└── package.json         # Dependencies
```

## Performance Optimization

- **Static Generation** - Pre-rendered at build time
- **Image Optimization** - Next.js Image component
- **Code Splitting** - Automatic with Next.js
- **CSS Optimization** - Tailwind purges unused styles
- **Lazy Loading** - Components loaded on scroll

## SEO Optimization

- Meta tags in `_document.tsx`
- Open Graph tags for social sharing
- Structured data for search engines
- Sitemap generation
- Robots.txt configuration

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)
- Mobile browsers

## Customization Tips

1. **Colors**: Update `tailwind.config.js` primary colors
2. **Fonts**: Change font imports in `_document.tsx`
3. **Animations**: Adjust Framer Motion settings in components
4. **Content**: Update all text content in components
5. **Layout**: Modify grid layouts in component files

## Common Issues

### Images not loading on GitHub Pages
Ensure image paths are relative or use the base path:
```jsx
<img src={`${process.env.NEXT_PUBLIC_BASE_PATH}/image.jpg`} />
```

### 404 on refresh
Add a `404.html` file that redirects to index:
```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Portfolio</title>
  <script>
    window.location.href = "/your-repo-name/";
  </script>
</head>
</html>
```

### Build errors
- Clear cache: `rm -rf .next out node_modules`
- Reinstall: `npm install`
- Rebuild: `npm run build`

## License

MIT - Feel free to use for your own portfolio!

## Support

For issues or questions, please open an issue on GitHub.