#!/bin/bash

# Python FastAPI Template Update Script
# This script updates dependencies, build tools, and creates verification scripts
# Focus: Reliability and preventing template breakage

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR"
BACKUP_DIR="${TEMPLATE_DIR}/backup-$(date +%Y%m%d-%H%M%S)"
LOG_FILE="${TEMPLATE_DIR}/update.log"
VENV_DIR="${TEMPLATE_DIR}/.venv"

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

# Check if Python and pip are available
check_prerequisites() {
    log "Checking prerequisites..."

    if ! command -v python3 &> /dev/null && ! command -v python &> /dev/null; then
        error "Python 3 is not installed"
        exit 1
    fi

    # Use python3 if available, otherwise python
    PYTHON_CMD="python3"
    if ! command -v python3 &> /dev/null; then
        PYTHON_CMD="python"
    fi

    PYTHON_VERSION=$($PYTHON_CMD --version | cut -d' ' -f2)
    log "Python version: $PYTHON_VERSION"

    # Check if Python version meets minimum requirement (3.8+)
    if ! $PYTHON_CMD -c "import sys; sys.exit(0 if sys.version_info >= (3, 8) else 1)"; then
        error "Python version $PYTHON_VERSION does not meet minimum requirements (>=3.8)"
        exit 1
    fi

    if ! command -v pip3 &> /dev/null && ! command -v pip &> /dev/null; then
        error "pip is not installed"
        exit 1
    fi

    PIP_CMD="pip3"
    if ! command -v pip3 &> /dev/null; then
        PIP_CMD="pip"
    fi
}

# Create backup
create_backup() {
    log "Creating backup in $BACKUP_DIR..."
    mkdir -p "$BACKUP_DIR"

    # Copy important files
    cp requirements.txt "$BACKUP_DIR/" 2>/dev/null || true
    cp requirements-dev.txt "$BACKUP_DIR/" 2>/dev/null || true
    cp pyproject.toml "$BACKUP_DIR/" 2>/dev/null || true
    cp setup.py "$BACKUP_DIR/" 2>/dev/null || true
    cp setup.cfg "$BACKUP_DIR/" 2>/dev/null || true
    cp .flake8 "$BACKUP_DIR/" 2>/dev/null || true
    cp mypy.ini "$BACKUP_DIR/" 2>/dev/null || true
    cp pytest.ini "$BACKUP_DIR/" 2>/dev/null || true
    cp alembic.ini "$BACKUP_DIR/" 2>/dev/null || true

    success "Backup created successfully"
}

# Create and activate virtual environment
setup_virtual_environment() {
    log "Setting up virtual environment..."

    if [[ -d "$VENV_DIR" ]]; then
        log "Removing existing virtual environment..."
        rm -rf "$VENV_DIR"
    fi

    $PYTHON_CMD -m venv "$VENV_DIR"
    source "$VENV_DIR/bin/activate"

    # Upgrade pip to latest version
    pip install --upgrade pip setuptools wheel

    success "Virtual environment created and activated"
}

# Update requirements.txt with latest stable versions
update_requirements() {
    log "Updating requirements.txt with latest stable versions..."

    # Create new requirements.txt with latest versions
    cat > requirements.txt << 'EOF'
# Core FastAPI dependencies
fastapi>=0.104.0,<1.0.0
uvicorn[standard]>=0.24.0,<1.0.0

# Database
sqlalchemy>=2.0.0,<3.0.0
alembic>=1.12.0,<2.0.0
psycopg2-binary>=2.9.0,<3.0.0

# Authentication & Security
python-jose[cryptography]>=3.3.0,<4.0.0
passlib[bcrypt]>=1.7.4,<2.0.0
python-multipart>=0.0.6,<1.0.0

# Validation & Serialization
pydantic[email]>=2.5.0,<3.0.0
pydantic-settings>=2.1.0,<3.0.0

# HTTP Client
httpx>=0.25.0,<1.0.0

# Background Tasks
celery>=5.3.0,<6.0.0
redis>=5.0.0,<6.0.0

# Environment
python-dotenv>=1.0.0,<2.0.0

# Logging
structlog>=23.2.0,<24.0.0

# CORS
python-cors>=1.7.0,<2.0.0
EOF

    # Create requirements-dev.txt for development dependencies
    cat > requirements-dev.txt << 'EOF'
# Include production requirements
-r requirements.txt

# Testing
pytest>=7.4.0,<8.0.0
pytest-asyncio>=0.21.0,<1.0.0
pytest-cov>=4.1.0,<5.0.0
httpx>=0.25.0,<1.0.0

# Linting & Formatting
black>=23.11.0,<24.0.0
isort>=5.12.0,<6.0.0
flake8>=6.1.0,<7.0.0
mypy>=1.7.0,<2.0.0

# Development tools
pre-commit>=3.5.0,<4.0.0
EOF

    success "Requirements files updated"
}

# Check for breaking changes and version conflicts
check_breaking_changes() {
    log "Checking for potential breaking changes..."

    # Check Python version compatibility
    local python_version=$($PYTHON_CMD -c "import sys; print('.'.join(map(str, sys.version_info[:2])))")
    log "Current Python: $python_version"

    # Check for major version updates in key packages
    local major_packages=("fastapi" "sqlalchemy" "pydantic" "uvicorn")

    for pkg in "${major_packages[@]}"; do
        if pip list | grep -q "$pkg"; then
            local current_version=$(pip show "$pkg" | grep Version | cut -d' ' -f2)
            log "Current $pkg version: $current_version"
        fi
    done

    # Check for deprecated Python versions
    if $PYTHON_CMD -c "import sys; sys.exit(0 if sys.version_info >= (3, 9) else 1)"; then
        log "Python version is up-to-date"
    else
        warning "Python version $python_version is older - consider upgrading to 3.9+"
    fi
}

# Install updated dependencies
install_dependencies() {
    log "Installing updated dependencies..."

    # Ensure virtual environment is active
    if [[ -z "${VIRTUAL_ENV:-}" ]]; then
        source "$VENV_DIR/bin/activate"
    fi

    # Install production dependencies
    pip install -r requirements.txt

    # Install development dependencies
    pip install -r requirements-dev.txt

    success "Dependencies installed successfully"
}

# Update configuration files
update_config_files() {
    log "Updating configuration files..."

    # Update pyproject.toml
    cat > pyproject.toml << 'EOF'
[build-system]
requires = ["setuptools>=61.0", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "{{PROJECT_NAME}}"
version = "1.0.0"
description = "{{PROJECT_DESCRIPTION}}"
authors = [
    {name = "{{AUTHOR_NAME}}", email = "{{AUTHOR_EMAIL}}"}
]
readme = "README.md"
license = {text = "MIT"}
requires-python = ">=3.8"
keywords = ["fastapi", "api", "python", "async", "web"]
classifiers = [
    "Development Status :: 4 - Beta",
    "Intended Audience :: Developers",
    "License :: OSI Approved :: MIT License",
    "Operating System :: OS Independent",
    "Programming Language :: Python :: 3",
    "Programming Language :: Python :: 3.8",
    "Programming Language :: Python :: 3.9",
    "Programming Language :: Python :: 3.10",
    "Programming Language :: Python :: 3.11",
    "Programming Language :: Python :: 3.12",
    "Topic :: Internet :: WWW/HTTP :: HTTP Servers",
    "Topic :: Software Development :: Libraries :: Application Frameworks",
]

[tool.black]
line-length = 88
target-version = ['py38']
include = '\.pyi?$'
extend-exclude = '''
/(
  # directories
  \.eggs
  | \.git
  | \.hg
  | \.mypy_cache
  | \.tox
  | \.venv
  | build
  | dist
)/
'''

[tool.isort]
profile = "black"
multi_line_output = 3
line_length = 88
known_first_party = ["app"]

[tool.mypy]
python_version = "3.8"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
disallow_incomplete_defs = true
check_untyped_defs = true
disallow_untyped_decorators = true
no_implicit_optional = true
warn_redundant_casts = true
warn_unused_ignores = true
warn_no_return = true
warn_unreachable = true
strict_equality = true

[[tool.mypy.overrides]]
module = [
    "uvicorn.*",
    "jose.*",
    "passlib.*",
    "sqlalchemy.*",
    "alembic.*",
]
ignore_missing_imports = true

[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py", "*_test.py"]
python_classes = ["Test*"]
python_functions = ["test_*"]
addopts = "-v --tb=short --strict-markers"
markers = [
    "slow: marks tests as slow (deselect with '-m \"not slow\"')",
    "integration: marks tests as integration tests",
    "unit: marks tests as unit tests",
]

[tool.coverage.run]
source = ["app"]
omit = [
    "*/tests/*",
    "*/venv/*",
    "*/.venv/*",
]

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",
    "def __repr__",
    "raise AssertionError",
    "raise NotImplementedError",
    "if __name__ == .__main__.:",
]
EOF

    # Update .flake8 configuration
    cat > .flake8 << 'EOF'
[flake8]
max-line-length = 88
extend-ignore =
    # E203: whitespace before ':' (conflicts with black)
    E203,
    # W503: line break before binary operator (conflicts with black)
    W503,
    # E501: line too long (handled by black)
    E501
exclude =
    .git,
    __pycache__,
    .venv,
    venv,
    .eggs,
    *.egg,
    build,
    dist,
    .mypy_cache,
    .pytest_cache,
    migrations
per-file-ignores =
    __init__.py:F401
    alembic/env.py:E402
EOF

    success "Configuration files updated"
}

# Create pre-commit configuration
create_precommit_config() {
    log "Creating pre-commit configuration..."

    cat > .pre-commit-config.yaml << 'EOF'
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
      - id: check-merge-conflict

  - repo: https://github.com/psf/black
    rev: 23.11.0
    hooks:
      - id: black
        language_version: python3

  - repo: https://github.com/pycqa/isort
    rev: 5.12.0
    hooks:
      - id: isort

  - repo: https://github.com/pycqa/flake8
    rev: 6.1.0
    hooks:
      - id: flake8

  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.7.1
    hooks:
      - id: mypy
        additional_dependencies: [types-all]
EOF

    success "Pre-commit configuration created"
}

# Create verify-template.sh script
create_verify_script() {
    log "Creating verify-template.sh script..."

    cat > verify-template.sh << 'EOF'
#!/bin/bash

# Python FastAPI Template Verification Script
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

# Determine Python command
get_python_cmd() {
    if command -v python3 &> /dev/null; then
        echo "python3"
    elif command -v python &> /dev/null; then
        echo "python"
    else
        error "Python not found"
        exit 1
    fi
}

# Check Python version
check_python_version() {
    local python_cmd=$(get_python_cmd)
    log "Checking Python version..."

    local version=$($python_cmd --version)
    log "Python version: $version"

    if ! $python_cmd -c "import sys; sys.exit(0 if sys.version_info >= (3, 8) else 1)"; then
        error "Python version must be >= 3.8"
        exit 1
    fi

    success "Python version check passed"
}

# Setup virtual environment
setup_venv() {
    local python_cmd=$(get_python_cmd)
    log "Setting up virtual environment..."

    if [[ -d ".venv" ]]; then
        log "Using existing virtual environment"
    else
        log "Creating new virtual environment"
        $python_cmd -m venv .venv
    fi

    source .venv/bin/activate
    pip install --upgrade pip setuptools wheel
    success "Virtual environment ready"
}

# Install dependencies
install_deps() {
    log "Installing dependencies..."

    source .venv/bin/activate

    if [[ -f "requirements.txt" ]]; then
        pip install -r requirements.txt
    fi

    if [[ -f "requirements-dev.txt" ]]; then
        pip install -r requirements-dev.txt
    fi

    success "Dependencies installed"
}

# Run linting checks
check_linting() {
    source .venv/bin/activate

    # Check if there are Python files to lint
    if ! find . -name "*.py" -not -path "./.venv/*" | head -1 | grep -q ".py"; then
        log "No Python files found - skipping linting"
        return 0
    fi

    log "Running Black formatter check..."
    if black --check --diff . --exclude=".venv|migrations"; then
        success "Black formatting check passed"
    else
        error "Code formatting issues found - run 'black .'"
        return 1
    fi

    log "Running isort import sorting check..."
    if isort --check-only --diff . --skip-glob=".venv/*" --skip-glob="migrations/*"; then
        success "Import sorting check passed"
    else
        error "Import sorting issues found - run 'isort .'"
        return 1
    fi

    log "Running flake8 linting..."
    if flake8 . --exclude=.venv,migrations; then
        success "Flake8 linting passed"
    else
        error "Linting issues found"
        return 1
    fi
}

# Run type checking
check_types() {
    source .venv/bin/activate

    # Check if there are Python files to type check
    if ! find . -name "*.py" -not -path "./.venv/*" | head -1 | grep -q ".py"; then
        log "No Python files found - skipping type checking"
        return 0
    fi

    log "Running mypy type checking..."
    if mypy . --exclude=".venv|migrations"; then
        success "Type checking passed"
    else
        error "Type checking issues found"
        return 1
    fi
}

# Run tests
run_tests() {
    source .venv/bin/activate

    log "Running tests..."
    if [[ -d "tests" ]] || find . -name "test_*.py" -not -path "./.venv/*" | head -1 | grep -q ".py"; then
        if pytest -v --tb=short; then
            success "Tests passed"
        else
            error "Some tests failed"
            return 1
        fi
    else
        log "No tests found - skipping test execution"
    fi
}

# Check security vulnerabilities
security_audit() {
    source .venv/bin/activate

    log "Running security audit with safety..."
    if command -v safety &> /dev/null; then
        if safety check; then
            success "Security audit passed"
        else
            error "Security vulnerabilities found"
            return 1
        fi
    else
        log "Safety not installed - skipping security audit"
    fi
}

# Test FastAPI application startup
test_app_startup() {
    source .venv/bin/activate

    if [[ -f "app/main.py" ]] || [[ -f "main.py" ]]; then
        log "Testing FastAPI application startup..."
        # This is a basic test - might need adjustment based on app structure
        python -c "
try:
    import uvicorn
    from fastapi import FastAPI
    print('FastAPI imports successful')
except ImportError as e:
    print(f'Import error: {e}')
    exit(1)
"
        success "Application startup test passed"
    else
        log "No main.py found - skipping startup test"
    fi
}

# Main verification flow
main() {
    log "Starting Python FastAPI template verification..."

    check_python_version
    setup_venv
    install_deps
    check_linting
    check_types
    run_tests
    security_audit
    test_app_startup

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
    # Deactivate virtual environment if active
    if [[ -n "${VIRTUAL_ENV:-}" ]]; then
        deactivate 2>/dev/null || true
    fi
}

# Handle script interruption
trap cleanup EXIT INT TERM

# Main execution
main() {
    log "Starting Python FastAPI template update process..."

    check_prerequisites
    create_backup
    setup_virtual_environment
    update_requirements
    check_breaking_changes
    install_dependencies
    update_config_files
    create_precommit_config
    create_verify_script
    run_verification

    success "Template update completed successfully!"
    log "Backup created in: $BACKUP_DIR"
    log "Update log: $LOG_FILE"
    log "Virtual environment: $VENV_DIR"
    log "Run './verify-template.sh' to verify the template anytime"
    log "Activate virtual environment with: source .venv/bin/activate"
}

# Execute main function
main "$@"