#!/bin/bash

# Node.js Express Template Update Script
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

    # Check if Node version meets minimum requirement
    if ! npx semver --range ">=16.0.0" "$NODE_VERSION" &> /dev/null; then
        warning "Node.js version $NODE_VERSION may not meet minimum requirements (>=16.0.0)"
    fi
}

# Create backup
create_backup() {
    log "Creating backup in $BACKUP_DIR..."
    mkdir -p "$BACKUP_DIR"

    # Copy important files
    cp package.json "$BACKUP_DIR/" 2>/dev/null || true
    cp package-lock.json "$BACKUP_DIR/" 2>/dev/null || true
    cp tsconfig.json "$BACKUP_DIR/" 2>/dev/null || true
    cp .eslintrc.js "$BACKUP_DIR/" 2>/dev/null || true
    cp .eslintrc.json "$BACKUP_DIR/" 2>/dev/null || true
    cp jest.config.js "$BACKUP_DIR/" 2>/dev/null || true

    success "Backup created successfully"
}

# Update package.json dependencies to latest stable versions
update_dependencies() {
    log "Updating dependencies to latest stable versions..."

    # Production dependencies - update to latest stable
    local prod_deps=(
        "express"
        "mongoose"
        "jsonwebtoken"
        "bcryptjs"
        "joi"
        "cors"
        "helmet"
        "compression"
        "express-rate-limit"
        "winston"
        "dotenv"
        "swagger-jsdoc"
        "swagger-ui-express"
        "express-validator"
        "cookie-parser"
        "express-mongo-sanitize"
        "xss"
    )

    for dep in "${prod_deps[@]}"; do
        log "Updating $dep..."
        npm install "$dep@latest" --save
    done

    # Development dependencies
    local dev_deps=(
        "@types/node"
        "@types/express"
        "@types/bcryptjs"
        "@types/jsonwebtoken"
        "@types/cors"
        "@types/compression"
        "@types/swagger-jsdoc"
        "@types/swagger-ui-express"
        "@types/cookie-parser"
        "@types/jest"
        "@types/supertest"
        "@types/xss"
        "typescript"
        "ts-node-dev"
        "jest"
        "ts-jest"
        "supertest"
        "mongodb-memory-server"
        "tsconfig-paths"
        "eslint"
        "@typescript-eslint/eslint-plugin"
        "@typescript-eslint/parser"
        "prettier"
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

    # Check Node.js engine requirements
    local node_version=$(node --version | cut -d'v' -f2)
    local package_node_req=$(node -p "require('./package.json').engines.node" 2>/dev/null || echo ">=16.0.0")

    log "Current Node.js: v$node_version, Package requires: $package_node_req"

    # Check for major version updates that might have breaking changes
    local major_update_packages=("express" "mongoose" "typescript" "jest")

    for pkg in "${major_update_packages[@]}"; do
        if npm outdated "$pkg" 2>/dev/null | grep -q "^$pkg"; then
            warning "Major version update detected for $pkg - review changelog"
        fi
    done
}

# Update TypeScript configuration
update_typescript_config() {
    log "Updating TypeScript configuration..."

    # Update tsconfig.json with latest recommendations
    cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "lib": ["ES2022"],
    "module": "commonjs",
    "rootDir": "./src",
    "outDir": "./dist",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "moduleResolution": "node",
    "allowSyntheticDefaultImports": true,
    "experimentalDecorators": true,
    "emitDecoratorMetadata": true,
    "resolveJsonModule": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "removeComments": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "**/*.test.ts", "**/*.spec.ts"]
}
EOF

    success "TypeScript configuration updated"
}

# Update ESLint configuration
update_eslint_config() {
    log "Updating ESLint configuration..."

    cat > .eslintrc.json << 'EOF'
{
  "env": {
    "node": true,
    "es2022": true,
    "jest": true
  },
  "extends": [
    "eslint:recommended",
    "@typescript-eslint/recommended",
    "@typescript-eslint/recommended-requiring-type-checking"
  ],
  "parser": "@typescript-eslint/parser",
  "parserOptions": {
    "ecmaVersion": "latest",
    "sourceType": "module",
    "project": "./tsconfig.json"
  },
  "plugins": ["@typescript-eslint"],
  "rules": {
    "@typescript-eslint/no-unused-vars": ["error", { "argsIgnorePattern": "^_" }],
    "@typescript-eslint/explicit-function-return-type": "warn",
    "@typescript-eslint/no-explicit-any": "warn",
    "@typescript-eslint/prefer-const": "error",
    "no-console": "warn"
  },
  "ignorePatterns": ["dist/", "node_modules/", "*.js"]
}
EOF

    success "ESLint configuration updated"
}

# Update Jest configuration
update_jest_config() {
    log "Updating Jest configuration..."

    cat > jest.config.js << 'EOF'
/** @type {import('jest').Config} */
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  roots: ['<rootDir>/src'],
  testMatch: ['**/__tests__/**/*.ts', '**/?(*.)+(spec|test).ts'],
  transform: {
    '^.+\\.ts$': 'ts-jest',
  },
  collectCoverageFrom: [
    'src/**/*.ts',
    '!src/**/*.d.ts',
    '!src/server.ts',
  ],
  coverageDirectory: 'coverage',
  coverageReporters: ['text', 'lcov', 'html'],
  setupFilesAfterEnv: ['<rootDir>/src/tests/setup.ts'],
  testTimeout: 10000,
};
EOF

    success "Jest configuration updated"
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

# Node.js Express Template Verification Script
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

# Check Node.js and npm versions
check_versions() {
    log "Checking Node.js and npm versions..."
    node --version
    npm --version

    # Check if package.json exists
    if [[ ! -f "package.json" ]]; then
        error "package.json not found"
        exit 1
    fi

    success "Versions check passed"
}

# Install dependencies
install_deps() {
    log "Installing dependencies..."
    npm ci || npm install
    success "Dependencies installed"
}

# Run TypeScript compilation
check_typescript() {
    log "Checking TypeScript compilation..."
    npm run build
    success "TypeScript compilation passed"
}

# Run linting
check_linting() {
    log "Running ESLint..."
    npm run lint
    success "Linting passed"
}

# Run tests
run_tests() {
    log "Running tests..."
    if npm run test; then
        success "Tests passed"
    else
        error "Some tests failed - check test output"
        return 1
    fi
}

# Check for security vulnerabilities
security_audit() {
    log "Running security audit..."
    if npm audit --audit-level=high; then
        success "Security audit passed"
    else
        error "Security vulnerabilities found - run 'npm audit fix'"
        return 1
    fi
}

# Verify Docker build (if Dockerfile exists)
check_docker() {
    if [[ -f "Dockerfile" ]]; then
        log "Checking Docker build..."
        if command -v docker &> /dev/null; then
            docker build -t nodejs-express-template-test . > /dev/null
            docker rmi nodejs-express-template-test > /dev/null
            success "Docker build passed"
        else
            log "Docker not available - skipping Docker build check"
        fi
    fi
}

# Main verification flow
main() {
    log "Starting Node.js Express template verification..."

    check_versions
    install_deps
    check_typescript
    check_linting
    run_tests
    security_audit
    check_docker

    success "Template verification completed successfully!"
    log "Template is ready for use"
}

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
    log "Starting Node.js Express template update process..."

    check_prerequisites
    create_backup
    update_dependencies
    check_breaking_changes
    update_typescript_config
    update_eslint_config
    update_jest_config
    install_dependencies
    create_verify_script
    run_verification

    success "Template update completed successfully!"
    log "Backup created in: $BACKUP_DIR"
    log "Update log: $LOG_FILE"
    log "Run ./verify-template.sh to verify the template anytime"
}

# Execute main function
main "$@"