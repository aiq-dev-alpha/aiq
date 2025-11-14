#!/bin/bash

# Next.js TypeScript Template Update Script
# This script updates dependencies, build tools, and creates verification scripts
# Focus: Reliability and preventing template breakage

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR"
BACKUP_DIR="${TEMPLATE_DIR}/backup-$(date +%Y%m%d-%H%M%S)"
LOG_FILE="${TEMPLATE_DIR}/update.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}" | tee -a "$LOG_FILE"
}

warning() {
    echo -e "${YELLOW}[WARNING] $1${NC}" | tee -a "$LOG_FILE"
}

success() {
    echo -e "${GREEN}[SUCCESS] $1${NC}" | tee -a "$LOG_FILE"
}

# Check if Node.js and npm are available
check_prerequisites() {
    log "Checking prerequisites..."

    if ! command -v node &> /dev/null; then
        error "Node.js is not installed"
        exit 1
    fi

    if ! command -v npm &> /dev/null; then
        error "npm is not installed"
        exit 1
    fi

    NODE_VERSION=$(node --version | cut -d'v' -f2)
    log "Node.js version: $NODE_VERSION"

    # Check if Node version meets minimum requirement for Next.js
    if ! npx semver --range ">=18.17.0" "$NODE_VERSION" &> /dev/null; then
        error "Node.js version $NODE_VERSION does not meet Next.js requirements (>=18.17.0)"
        exit 1
    fi

    # Check for yarn as alternative
    if command -v yarn &> /dev/null; then
        YARN_VERSION=$(yarn --version)
        log "Yarn version: $YARN_VERSION (available as alternative)"
    fi
}

# Create backup
create_backup() {
    log "Creating backup in $BACKUP_DIR..."
    mkdir -p "$BACKUP_DIR"

    # Copy important files
    cp package.json "$BACKUP_DIR/" 2>/dev/null || true
    cp package-lock.json "$BACKUP_DIR/" 2>/dev/null || true
    cp yarn.lock "$BACKUP_DIR/" 2>/dev/null || true
    cp tsconfig.json "$BACKUP_DIR/" 2>/dev/null || true
    cp next.config.js "$BACKUP_DIR/" 2>/dev/null || true
    cp next.config.mjs "$BACKUP_DIR/" 2>/dev/null || true
    cp tailwind.config.js "$BACKUP_DIR/" 2>/dev/null || true
    cp tailwind.config.ts "$BACKUP_DIR/" 2>/dev/null || true
    cp postcss.config.js "$BACKUP_DIR/" 2>/dev/null || true
    cp .eslintrc.json "$BACKUP_DIR/" 2>/dev/null || true
    cp .eslintrc.js "$BACKUP_DIR/" 2>/dev/null || true
    cp prettier.config.js "$BACKUP_DIR/" 2>/dev/null || true

    success "Backup created successfully"
}

# Get Next.js latest stable version
get_nextjs_latest() {
    log "Checking for latest Next.js stable version..."

    # Get latest stable version (not canary/beta)
    local latest_version=$(npm view next version)
    log "Latest Next.js stable version: $latest_version"
    echo "$latest_version"
}

# Get React latest stable version
get_react_latest() {
    log "Checking for latest React stable version..."

    local latest_version=$(npm view react version)
    log "Latest React stable version: $latest_version"
    echo "$latest_version"
}

# Update package.json dependencies to latest stable versions
update_dependencies() {
    log "Updating dependencies to latest stable versions..."

    # Get latest versions
    local nextjs_version=$(get_nextjs_latest)
    local react_version=$(get_react_latest)

    # Core Next.js and React dependencies
    log "Updating Next.js to $nextjs_version..."
    npm install "next@$nextjs_version" --save

    log "Updating React to $react_version..."
    npm install "react@$react_version" "react-dom@$react_version" --save

    # Update other production dependencies
    local prod_deps=(
        "next-auth"
        "next-themes"
        "@radix-ui/react-dialog"
        "@radix-ui/react-dropdown-menu"
        "@radix-ui/react-label"
        "@radix-ui/react-slot"
        "@radix-ui/react-toast"
        "@radix-ui/react-tooltip"
        "class-variance-authority"
        "clsx"
        "lucide-react"
        "tailwind-merge"
        "tailwindcss-animate"
        "zod"
        "@hookform/resolvers"
        "react-hook-form"
    )

    for dep in "${prod_deps[@]}"; do
        log "Updating $dep..."
        npm install "$dep@latest" --save
    done

    # Update development dependencies
    local dev_deps=(
        "typescript"
        "@types/node"
        "@types/react"
        "@types/react-dom"
        "postcss"
        "tailwindcss"
        "eslint"
        "eslint-config-next"
        "@typescript-eslint/eslint-plugin"
        "@typescript-eslint/parser"
        "eslint-config-prettier"
        "eslint-plugin-prettier"
        "prettier"
        "prettier-plugin-tailwindcss"
    )

    for dep in "${dev_deps[@]}"; do
        log "Updating dev dependency $dep..."
        npm install "$dep@latest" --save-dev
    done

    success "Dependencies updated successfully"
}

# Check for breaking changes
check_breaking_changes() {
    log "Checking for potential breaking changes..."

    # Check Next.js version for major updates
    if npm ls next 2>/dev/null | grep -q "next@"; then
        local current_version=$(npm ls next --depth=0 2>/dev/null | grep next@ | cut -d'@' -f2 | cut -d' ' -f1)
        log "Current Next.js version: $current_version"
    fi

    # Check for major version updates that might have breaking changes
    local breaking_change_packages=("next" "react" "typescript" "tailwindcss")

    for pkg in "${breaking_change_packages[@]}"; do
        if npm outdated "$pkg" 2>/dev/null | grep -q "^$pkg"; then
            warning "Major version update detected for $pkg - review changelog and migration guide"
        fi
    done

    # Check Node.js version against Next.js requirements
    local node_version=$(node --version | cut -d'v' -f2)
    log "Verifying Node.js compatibility with Next.js..."

    if npx semver --range ">=18.17.0" "$node_version" &> /dev/null; then
        success "Node.js version is compatible"
    else
        warning "Node.js version may not be compatible with latest Next.js"
    fi
}

# Update Next.js configuration
update_nextjs_config() {
    log "Updating Next.js configuration..."

    # Create modern next.config.js
    cat > next.config.js << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    typedRoutes: true,
  },
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: '**',
      },
    ],
  },
  // Enable strict mode for better development experience
  reactStrictMode: true,
  // Enable SWC minifier for better performance
  swcMinify: true,
  // Compiler options
  compiler: {
    removeConsole: process.env.NODE_ENV === 'production' ? {
      exclude: ['error']
    } : false,
  },
  // Headers for better security
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          {
            key: 'X-Frame-Options',
            value: 'DENY',
          },
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff',
          },
          {
            key: 'Referrer-Policy',
            value: 'origin-when-cross-origin',
          },
        ],
      },
    ]
  },
}

module.exports = nextConfig
EOF

    success "Next.js configuration updated"
}

# Update TypeScript configuration
update_typescript_config() {
    log "Updating TypeScript configuration..."

    cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "lib": ["dom", "dom.iterable", "es6"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"],
      "@/components/*": ["./src/components/*"],
      "@/lib/*": ["./src/lib/*"],
      "@/hooks/*": ["./src/hooks/*"],
      "@/types/*": ["./src/types/*"],
      "@/styles/*": ["./src/styles/*"]
    },
    "target": "ES2022",
    "forceConsistentCasingInFileNames": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true
  },
  "include": [
    "next-env.d.ts",
    "**/*.ts",
    "**/*.tsx",
    ".next/types/**/*.ts"
  ],
  "exclude": [
    "node_modules"
  ]
}
EOF

    success "TypeScript configuration updated"
}

# Update Tailwind CSS configuration
update_tailwind_config() {
    log "Updating Tailwind CSS configuration..."

    cat > tailwind.config.ts << 'EOF'
import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        border: 'hsl(var(--border))',
        input: 'hsl(var(--input))',
        ring: 'hsl(var(--ring))',
        background: 'hsl(var(--background))',
        foreground: 'hsl(var(--foreground))',
        primary: {
          DEFAULT: 'hsl(var(--primary))',
          foreground: 'hsl(var(--primary-foreground))',
        },
        secondary: {
          DEFAULT: 'hsl(var(--secondary))',
          foreground: 'hsl(var(--secondary-foreground))',
        },
        destructive: {
          DEFAULT: 'hsl(var(--destructive))',
          foreground: 'hsl(var(--destructive-foreground))',
        },
        muted: {
          DEFAULT: 'hsl(var(--muted))',
          foreground: 'hsl(var(--muted-foreground))',
        },
        accent: {
          DEFAULT: 'hsl(var(--accent))',
          foreground: 'hsl(var(--accent-foreground))',
        },
        popover: {
          DEFAULT: 'hsl(var(--popover))',
          foreground: 'hsl(var(--popover-foreground))',
        },
        card: {
          DEFAULT: 'hsl(var(--card))',
          foreground: 'hsl(var(--card-foreground))',
        },
      },
      borderRadius: {
        lg: 'var(--radius)',
        md: 'calc(var(--radius) - 2px)',
        sm: 'calc(var(--radius) - 4px)',
      },
      fontFamily: {
        sans: ['var(--font-sans)'],
        mono: ['var(--font-mono)'],
      },
      keyframes: {
        'accordion-down': {
          from: { height: '0' },
          to: { height: 'var(--radix-accordion-content-height)' },
        },
        'accordion-up': {
          from: { height: 'var(--radix-accordion-content-height)' },
          to: { height: '0' },
        },
      },
      animation: {
        'accordion-down': 'accordion-down 0.2s ease-out',
        'accordion-up': 'accordion-up 0.2s ease-out',
      },
    },
  },
  plugins: [require('tailwindcss-animate')],
}

export default config
EOF

    success "Tailwind CSS configuration updated"
}

# Update ESLint configuration
update_eslint_config() {
    log "Updating ESLint configuration..."

    cat > .eslintrc.json << 'EOF'
{
  "extends": [
    "next/core-web-vitals",
    "@typescript-eslint/recommended",
    "prettier"
  ],
  "parser": "@typescript-eslint/parser",
  "parserOptions": {
    "ecmaVersion": "latest",
    "sourceType": "module",
    "project": "./tsconfig.json"
  },
  "plugins": ["@typescript-eslint", "prettier"],
  "rules": {
    "prettier/prettier": "error",
    "@typescript-eslint/no-unused-vars": ["error", { "argsIgnorePattern": "^_" }],
    "@typescript-eslint/explicit-function-return-type": "off",
    "@typescript-eslint/explicit-module-boundary-types": "off",
    "@typescript-eslint/no-explicit-any": "warn",
    "@typescript-eslint/prefer-const": "error",
    "@typescript-eslint/no-var-requires": "error",
    "prefer-const": "error",
    "no-console": ["warn", { "allow": ["warn", "error"] }],
    "react-hooks/exhaustive-deps": "error"
  },
  "ignorePatterns": [
    "next.config.js",
    "tailwind.config.ts",
    "postcss.config.js",
    ".next/",
    "node_modules/"
  ]
}
EOF

    success "ESLint configuration updated"
}

# Update Prettier configuration
update_prettier_config() {
    log "Updating Prettier configuration..."

    cat > prettier.config.js << 'EOF'
/** @type {import('prettier').Config} */
module.exports = {
  semi: false,
  singleQuote: true,
  printWidth: 80,
  tabWidth: 2,
  trailingComma: 'es5',
  endOfLine: 'lf',
  arrowParens: 'avoid',
  bracketSpacing: true,
  bracketSameLine: false,
  plugins: ['prettier-plugin-tailwindcss'],
  tailwindFunctions: ['clsx', 'cn'],
}
EOF

    success "Prettier configuration updated"
}

# Install dependencies
install_dependencies() {
    log "Installing dependencies..."

    # Clean install to avoid version conflicts
    rm -rf node_modules package-lock.json
    npm install

    success "Dependencies installed successfully"
}

# Create verify-template.sh script
create_verify_script() {
    log "Creating verify-template.sh script..."

    cat > verify-template.sh << 'EOF'
#!/bin/bash

# Next.js TypeScript Template Verification Script
# This script verifies that the template is working correctly

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[VERIFY] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}"
}

success() {
    echo -e "${GREEN}[SUCCESS] $1${NC}"
}

warning() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

# Check Node.js and npm versions
check_versions() {
    log "Checking Node.js and npm versions..."
    local node_version=$(node --version)
    local npm_version=$(npm --version)

    log "Node.js: $node_version"
    log "npm: $npm_version"

    # Check if package.json exists
    if [[ ! -f "package.json" ]]; then
        error "package.json not found"
        exit 1
    fi

    # Check Node version meets Next.js requirements
    local node_num=$(echo "$node_version" | cut -d'v' -f2)
    if ! npx semver --range ">=18.17.0" "$node_num" &> /dev/null; then
        error "Node.js version $node_version does not meet Next.js requirements (>=18.17.0)"
        exit 1
    fi

    success "Version checks passed"
}

# Install dependencies
install_deps() {
    log "Installing dependencies..."

    if [[ -f "package-lock.json" ]]; then
        npm ci
    else
        npm install
    fi

    success "Dependencies installed"
}

# Run TypeScript type checking
check_typescript() {
    log "Running TypeScript type checking..."

    if npm run type-check; then
        success "TypeScript type checking passed"
    else
        error "TypeScript errors found"
        return 1
    fi
}

# Run linting
check_linting() {
    log "Running ESLint..."

    if npm run lint; then
        success "Linting passed"
    else
        error "Linting errors found"
        return 1
    fi
}

# Check code formatting
check_formatting() {
    log "Checking code formatting..."

    if npm run format:check; then
        success "Code formatting is correct"
    else
        warning "Code formatting issues found - run 'npm run format' to fix"
        return 1
    fi
}

# Test Next.js build
test_build() {
    log "Testing Next.js build..."

    if npm run build; then
        success "Build completed successfully"

        # Clean up build output
        rm -rf .next
    else
        error "Build failed"
        return 1
    fi
}

# Test development server startup
test_dev_server() {
    log "Testing development server startup..."

    # Start dev server in background
    npm run dev &
    DEV_PID=$!

    # Wait for server to start
    sleep 10

    # Check if server is responding
    if curl -f http://localhost:3000 > /dev/null 2>&1; then
        success "Development server started successfully"
        kill $DEV_PID 2>/dev/null || true
        wait $DEV_PID 2>/dev/null || true
    else
        error "Development server failed to start or respond"
        kill $DEV_PID 2>/dev/null || true
        wait $DEV_PID 2>/dev/null || true
        return 1
    fi
}

# Check for security vulnerabilities
security_audit() {
    log "Running security audit..."

    if npm audit --audit-level=high; then
        success "Security audit passed"
    else
        warning "Security vulnerabilities found - review and fix with 'npm audit fix'"
        return 1
    fi
}

# Verify Next.js and React versions
check_core_versions() {
    log "Checking Next.js and React versions..."

    local next_version=$(npm ls next --depth=0 2>/dev/null | grep next@ | cut -d'@' -f2 | cut -d' ' -f1 || echo "not found")
    local react_version=$(npm ls react --depth=0 2>/dev/null | grep react@ | cut -d'@' -f2 | cut -d' ' -f1 || echo "not found")

    log "Next.js version: $next_version"
    log "React version: $react_version"

    if [[ "$next_version" == "not found" ]] || [[ "$react_version" == "not found" ]]; then
        error "Core dependencies not properly installed"
        return 1
    fi

    success "Core versions verified"
}

# Check configuration files
check_configs() {
    log "Checking configuration files..."

    local required_configs=("next.config.js" "tsconfig.json" "tailwind.config.ts" ".eslintrc.json")

    for config in "${required_configs[@]}"; do
        if [[ -f "$config" ]]; then
            log "✓ $config exists"
        else
            warning "✗ $config missing"
        fi
    done

    success "Configuration check completed"
}

# Main verification flow
main() {
    log "Starting Next.js TypeScript template verification..."

    check_versions
    install_deps
    check_configs
    check_core_versions
    check_typescript
    check_linting
    check_formatting
    test_build
    security_audit

    # Only test dev server if curl is available and we're not in CI
    if command -v curl &> /dev/null && [[ -z "${CI:-}" ]]; then
        test_dev_server
    else
        log "Skipping dev server test (curl not available or running in CI)"
    fi

    success "Template verification completed successfully!"
    log "Template is ready for development"
    log ""
    log "Next steps:"
    log "- Run 'npm run dev' to start development server"
    log "- Visit http://localhost:3000 to see your app"
    log "- Run 'npm run build' to create production build"
}

# Cleanup function for dev server
cleanup() {
    if [[ -n "${DEV_PID:-}" ]]; then
        kill $DEV_PID 2>/dev/null || true
        wait $DEV_PID 2>/dev/null || true
    fi
}

trap cleanup EXIT

main "$@"
EOF

    chmod +x verify-template.sh
    success "verify-template.sh created and made executable"
}

# Run verification
run_verification() {
    log "Running template verification..."

    if ./verify-template.sh; then
        success "Template verification passed"
    else
        error "Template verification failed - check logs"
        exit 1
    fi
}

# Cleanup function
cleanup() {
    log "Cleaning up temporary files..."
    # Clean up any temporary files if needed
}

# Handle script interruption
trap cleanup EXIT INT TERM

# Main execution
main() {
    log "Starting Next.js TypeScript template update process..."

    check_prerequisites
    create_backup
    update_dependencies
    check_breaking_changes
    update_nextjs_config
    update_typescript_config
    update_tailwind_config
    update_eslint_config
    update_prettier_config
    install_dependencies
    create_verify_script
    run_verification

    success "Template update completed successfully!"
    log "Backup created in: $BACKUP_DIR"
    log "Update log: $LOG_FILE"
    log "Run './verify-template.sh' to verify the template anytime"
    log ""
    log "Updated to:"
    log "- Next.js: $(npm ls next --depth=0 2>/dev/null | grep next@ | cut -d'@' -f2 | cut -d' ' -f1)"
    log "- React: $(npm ls react --depth=0 2>/dev/null | grep react@ | cut -d'@' -f2 | cut -d' ' -f1)"
    log "- TypeScript: $(npm ls typescript --depth=0 2>/dev/null | grep typescript@ | cut -d'@' -f2 | cut -d' ' -f1)"
}

# Execute main function
main "$@"