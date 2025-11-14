#!/bin/bash

set -euo pipefail

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Validate arguments
if [ $# -ne 2 ]; then
    log_error "Usage: $0 <project_name> <destination_path>"
    log_info "Example: $0 my-awesome-api /path/to/projects"
    exit 1
fi

PROJECT_NAME="$1"
DESTINATION_PATH="$2"
PROJECT_PATH="$DESTINATION_PATH/$PROJECT_NAME"
TEMPLATE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log_info "Setting up FastAPI project: $PROJECT_NAME"
log_info "Template path: $TEMPLATE_PATH"
log_info "Destination path: $PROJECT_PATH"

# Check if destination already exists
if [ -d "$PROJECT_PATH" ]; then
    log_error "Directory $PROJECT_PATH already exists!"
    exit 1
fi

# Create destination directory
log_info "Creating project directory..."
mkdir -p "$PROJECT_PATH"

# Copy template files
log_info "Copying template files..."
cp -r "$TEMPLATE_PATH"/* "$PROJECT_PATH/" 2>/dev/null || true
cp -r "$TEMPLATE_PATH"/.[!.]* "$PROJECT_PATH/" 2>/dev/null || true

# Remove setup script from destination
rm -f "$PROJECT_PATH/setup-template.sh"

cd "$PROJECT_PATH"

# Check if Python 3.10+ is available
PYTHON_CMD=""
if command -v python3.11 &> /dev/null; then
    PYTHON_CMD="python3.11"
elif command -v python3.10 &> /dev/null; then
    PYTHON_CMD="python3.10"
elif command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 -c "import sys; print('.'.join(map(str, sys.version_info[:2])))")
    if [ "$(echo "$PYTHON_VERSION >= 3.10" | bc -l)" -eq 1 ]; then
        PYTHON_CMD="python3"
    fi
fi

if [ -z "$PYTHON_CMD" ]; then
    log_error "Python 3.10 or higher is required but not found!"
    exit 1
fi

log_success "Found Python: $PYTHON_CMD"

# Create virtual environment
log_info "Creating virtual environment..."
$PYTHON_CMD -m venv venv

# Activate virtual environment
log_info "Activating virtual environment..."
source venv/bin/activate

# Install dependencies
log_info "Installing Python dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# Create .env file from example
log_info "Creating .env file from .env.example..."
cp .env.example .env

# Generate a random secret key
SECRET_KEY=$(openssl rand -hex 32 2>/dev/null || python3 -c "import secrets; print(secrets.token_hex(32))")
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s/your-super-secret-key-change-this-in-production/$SECRET_KEY/g" .env
else
    # Linux
    sed -i "s/your-super-secret-key-change-this-in-production/$SECRET_KEY/g" .env
fi

# Update project name in .env
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s/PROJECT_NAME=FastAPI Template/PROJECT_NAME=$PROJECT_NAME/g" .env
else
    # Linux
    sed -i "s/PROJECT_NAME=FastAPI Template/PROJECT_NAME=$PROJECT_NAME/g" .env
fi

log_success "Generated random secret key and updated project name"

# Initialize Alembic (only if database is available)
log_info "Checking database connection..."
if command -v psql &> /dev/null; then
    log_info "PostgreSQL client found. You can now set up your database."
    log_warning "Make sure to update the DATABASE_URL in .env before running migrations"
    log_info "To initialize database migrations, run:"
    log_info "  source venv/bin/activate"
    log_info "  alembic revision --autogenerate -m 'Initial migration'"
    log_info "  alembic upgrade head"
else
    log_warning "PostgreSQL client not found. Install PostgreSQL to set up database migrations."
fi

# Create .gitignore if it doesn't exist
if [ ! -f .gitignore ]; then
    log_info "Creating .gitignore..."
    cat > .gitignore << EOF
# Python
__pycache__/
*.py[cod]
*\$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
share/python-wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# Virtual environments
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Logs
logs
*.log

# Database
*.db
*.sqlite3

# Testing
.pytest_cache/
.coverage
htmlcov/
.tox/

# MyPy
.mypy_cache/
.dmypy.json
dmypy.json

# Jupyter
.ipynb_checkpoints

# Docker
.dockerignore
EOF
fi

# Initialize git repository
if [ ! -d .git ]; then
    log_info "Initializing Git repository..."
    git init
    git add .
    git commit -m "Initial commit: FastAPI template setup"
    log_success "Git repository initialized with initial commit"
fi

log_success "FastAPI project '$PROJECT_NAME' has been set up successfully!"
echo
log_info "Next steps:"
echo "1. Navigate to your project: cd $PROJECT_PATH"
echo "2. Activate virtual environment: source venv/bin/activate"
echo "3. Update .env file with your database and other settings"
echo "4. Set up your database and run migrations:"
echo "   - alembic revision --autogenerate -m 'Initial migration'"
echo "   - alembic upgrade head"
echo "5. Run the application: uvicorn main:app --reload"
echo "6. Visit http://localhost:8000/docs to see the API documentation"
echo
log_info "To run with Docker:"
echo "   - docker-compose up --build"
echo
log_success "Happy coding! 🚀"