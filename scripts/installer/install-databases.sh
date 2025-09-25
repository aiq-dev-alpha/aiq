#!/bin/bash
set -euo pipefail

echo "Installing database clients and tools..."

# Update packages
sudo apt-get update -qq

# PostgreSQL client
sudo apt-get install -y -qq postgresql-client

# MySQL client
sudo apt-get install -y -qq mysql-client

# Redis tools
sudo apt-get install -y -qq redis-tools

# SQLite
sudo apt-get install -y -qq sqlite3

# MongoDB shell
if command -v lsb_release &> /dev/null; then
    UBUNTU_CODENAME=$(lsb_release -cs)
else
    UBUNTU_CODENAME="jammy"
fi
wget -qO - https://www.mongodb.org/static/pgp/server-7.0.asc | sudo apt-key add - 2>/dev/null || true
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu ${UBUNTU_CODENAME}/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list > /dev/null 2>/dev/null || true
sudo apt-get update -qq
sudo apt-get install -y -qq mongodb-mongosh 2>/dev/null || echo "MongoDB shell not available for this distribution"

# Database migration tools
if command -v npm &> /dev/null; then
    npm install -g knex prisma typeorm
fi

# Python database tools
if command -v pip3 &> /dev/null; then
    pip3 install --user sqlalchemy psycopg2-binary pymongo redis
fi

echo "Database tools setup complete."