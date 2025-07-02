#!/bin/bash
# PisoWiFi Automated Installer Script
# For Ubuntu 22.04+ Only
set -e

# Helper for colored output
green() { echo -e "\033[32m$1\033[0m"; }
red() { echo -e "\033[31m$1\033[0m"; }

clear
green "==== PisoWiFi System Automated Installer ===="

# 1. Update & Install dependencies
green "[1/6] Updating and installing dependencies..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl nginx mysql-server nodejs npm

# 2. Install n for Node.js LTS
green "[2/6] Installing Node.js LTS..."
sudo npm install -g n || true
sudo n lts || true

# 3. Prepare folder structure
green "[3/6] Creating folders..."
sudo mkdir -p /opt/pisowifi/{backend,frontend,router}
sudo chown -R $USER:$USER /opt/pisowifi

# 4. (Reminder) Copy your code
green "[4/6] Please copy your backend, frontend, and router code into /opt/pisowifi folders."
green "   backend/  --> /opt/pisowifi/backend"
green "   frontend/ --> /opt/pisowifi/frontend"
green "   router/   --> /opt/pisowifi/router"

green "After copying code, continue with install steps:"
echo "-------------------------------------"
echo "1. Configure .env in backend folder."
echo "2. Install backend dependencies:"
echo "   cd /opt/pisowifi/backend && npm install"
echo "3. Import database schema:"
echo "   mysql -u root -p < /opt/pisowifi/backend/init.sql"
echo "4. Build frontend:"
echo "   cd /opt/pisowifi/frontend && npm install && npm run build"
echo "5. Start backend:"
echo "   cd /opt/pisowifi/backend && npm start"
echo "-------------------------------------"

green "[5/6] PisoWiFi initial setup is ready."
green "[6/6] Please finish manual steps above to complete installation."
green "==== INSTALLER FINISHED ===="
