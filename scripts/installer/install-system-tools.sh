#!/bin/bash
set -euo pipefail

# System Development Tools
echo "Installing system development tools..."

# Source config if it exists
if [ -f "./config.sh" ]; then
    source ./config.sh
fi

# Update packages
sudo apt-get update -qq

# Build Tools
[ "${INSTALL_CMAKE:-false}" = "true" ] && sudo apt-get install -y -qq cmake
[ "${INSTALL_SHELLCHECK:-false}" = "true" ] && sudo apt-get install -y -qq shellcheck

# CLI Tools
[ "${INSTALL_JQ:-false}" = "true" ] && sudo apt-get install -y -qq jq
[ "${INSTALL_YQ:-false}" = "true" ] && sudo apt-get install -y -qq yq
[ "${INSTALL_HTOP:-false}" = "true" ] && sudo apt-get install -y -qq htop
[ "${INSTALL_TMUX:-false}" = "true" ] && sudo apt-get install -y -qq tmux
[ "${INSTALL_SCREEN:-false}" = "true" ] && sudo apt-get install -y -qq screen
[ "${INSTALL_TREE:-false}" = "true" ] && sudo apt-get install -y -qq tree
[ "${INSTALL_RIPGREP:-false}" = "true" ] && sudo apt-get install -y -qq ripgrep
[ "${INSTALL_FZF:-false}" = "true" ] && sudo apt-get install -y -qq fzf
[ "${INSTALL_BAT:-false}" = "true" ] && sudo apt-get install -y -qq bat
[ "${INSTALL_FD:-false}" = "true" ] && sudo apt-get install -y -qq fd-find
[ "${INSTALL_NCDU:-false}" = "true" ] && sudo apt-get install -y -qq ncdu
[ "${INSTALL_HTTPIE:-false}" = "true" ] && sudo apt-get install -y -qq httpie

# Editors
[ "${INSTALL_VIM:-false}" = "true" ] && sudo apt-get install -y -qq vim
[ "${INSTALL_NEOVIM:-false}" = "true" ] && sudo apt-get install -y -qq neovim
[ "${INSTALL_EMACS:-false}" = "true" ] && sudo apt-get install -y -qq emacs

# Version Control
[ "${INSTALL_GIT_LFS:-false}" = "true" ] && sudo apt-get install -y -qq git-lfs

# Database Clients
[ "${INSTALL_POSTGRESQL_CLIENT:-false}" = "true" ] && sudo apt-get install -y -qq postgresql-client
[ "${INSTALL_MYSQL_CLIENT:-false}" = "true" ] && sudo apt-get install -y -qq mysql-client
[ "${INSTALL_REDIS_CLIENT:-false}" = "true" ] && sudo apt-get install -y -qq redis-tools
[ "${INSTALL_SQLITE:-false}" = "true" ] && sudo apt-get install -y -qq sqlite3

echo "System tools installation complete."