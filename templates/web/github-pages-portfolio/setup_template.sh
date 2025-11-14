#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR"

PROJECT_DIR=""
PROJECT_NAME=""
REPO_NAME=""

cleanup_on_failure() {
    local exit_code=$?
    if [ $exit_code -ne 0 ] && [ -n "$PROJECT_DIR" ] && [ -d "$PROJECT_DIR" ]; then
        echo "Setup failed. Removing $PROJECT_DIR"
        rm -rf "$PROJECT_DIR"
    fi
}

trap cleanup_on_failure EXIT

validate_project_name() {
    local name="$1"

    if [ -z "$name" ]; then
        echo "Error: Project name cannot be empty"
        return 1
    fi

    if [[ ! "$name" =~ ^[a-z][a-z0-9-]*$ ]]; then
        echo "Error: Project name must start with lowercase letter and contain only lowercase letters, numbers, and hyphens"
        return 1
    fi

    return 0
}

check_node() {
    if ! command -v node >/dev/null 2>&1; then
        echo "Error: Node.js is not installed"
        exit 1
    fi

    if ! command -v npm >/dev/null 2>&1; then
        echo "Error: npm is not installed"
        exit 1
    fi

    local node_version=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$node_version" -lt 18 ]; then
        echo "Error: Node.js 18 or higher is required"
        exit 1
    fi
}

copy_template() {
    local dest_dir="$1"
    local project_name="$2"

    echo "Setting up GitHub Pages portfolio: $project_name"

    mkdir -p "$dest_dir"

    find "$TEMPLATE_DIR" -maxdepth 1 -type f ! -name "*.sh" ! -name "README.md" -exec cp {} "$dest_dir/" \;

    for dir in src public; do
        if [ -d "$TEMPLATE_DIR/$dir" ]; then
            cp -r "$TEMPLATE_DIR/$dir" "$dest_dir/"
        fi
    done
}

customize_template() {
    local dest_dir="$1"
    local project_name="$2"
    local repo_name="$3"

    if [ -f "$dest_dir/package.json" ]; then
        sed -i.bak "s/github-pages-portfolio/$project_name/g" "$dest_dir/package.json"
        rm -f "$dest_dir/package.json.bak"
    fi

    if [ -f "$dest_dir/next.config.js" ] && [ -n "$repo_name" ]; then
        sed -i.bak "s|basePath: process.env.NODE_ENV === 'production' ? '/portfolio' : ''|basePath: process.env.NODE_ENV === 'production' ? '/$repo_name' : ''|g" "$dest_dir/next.config.js"
        sed -i.bak "s|assetPrefix: process.env.NODE_ENV === 'production' ? '/portfolio' : ''|assetPrefix: process.env.NODE_ENV === 'production' ? '/$repo_name' : ''|g" "$dest_dir/next.config.js"
        rm -f "$dest_dir/next.config.js.bak"
    fi

    find "$dest_dir" -name "*.bak" -type f -delete
}

create_github_workflow() {
    local dest_dir="$1"

    mkdir -p "$dest_dir/.github/workflows"

    cat > "$dest_dir/.github/workflows/deploy.yml" << 'EOF'
name: Deploy to GitHub Pages

on:
  push:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "18"
          cache: "npm"
      - run: npm ci
      - run: npm run build
      - run: touch ./out/.nojekyll
      - uses: actions/upload-pages-artifact@v2
        with:
          path: ./out

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - id: deployment
        uses: actions/deploy-pages@v3
EOF
}

install_dependencies() {
    local dest_dir="$1"

    cd "$dest_dir"

    echo "Installing dependencies..."
    npm install

    echo "Building project..."
    npm run build
}

main() {
    if [ $# -lt 2 ] || [ $# -gt 3 ]; then
        echo "Usage: $0 <project_name> <destination_directory> [github_repo_name]"
        echo "Example: $0 my-portfolio ~/projects/ my-portfolio"
        exit 1
    fi

    PROJECT_NAME="$1"
    local dest_base="$2"
    PROJECT_DIR="$dest_base/$PROJECT_NAME"
    REPO_NAME="${3:-}"

    validate_project_name "$PROJECT_NAME" || exit 1
    check_node

    if [ -d "$PROJECT_DIR" ]; then
        echo "Error: Directory $PROJECT_DIR already exists"
        exit 1
    fi

    copy_template "$PROJECT_DIR" "$PROJECT_NAME"
    customize_template "$PROJECT_DIR" "$PROJECT_NAME" "$REPO_NAME"
    create_github_workflow "$PROJECT_DIR"
    install_dependencies "$PROJECT_DIR"

    echo "Setup completed successfully"
    echo "Project created at: $PROJECT_DIR"
    echo ""
    echo "Next steps:"
    echo "  1. cd $PROJECT_DIR"
    echo "  2. Customize content in src/components/"
    echo "  3. npm run dev (for development)"
    echo ""
    echo "To deploy to GitHub Pages:"
    echo "  1. Create a GitHub repository"
    echo "  2. Push your code to the main branch"
    echo "  3. Enable GitHub Pages in repository settings"
    echo "  4. Select 'GitHub Actions' as the source"
    echo ""
    echo "Or deploy manually:"
    echo "  npm run deploy"
}

main "$@"