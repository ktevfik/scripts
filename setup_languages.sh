#!/bin/bash

# Bash script to install Node.js, Python, and Go on Ubuntu

# Update package lists and upgrade system packages
echo "Updating package lists and upgrading system packages..."
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Node.js
echo "Installing Node.js..."
wget https://nodejs.org/dist/v20.16.0/node-v20.16.0-linux-x64.tar.xz
sudo tar -xJvf node-v20.16.0-linux-x64.tar.xz -C /usr/local --strip-components=1
rm node-v20.16.0-linux-x64.tar.xz

# Verify Node.js installation
echo "Verifying Node.js installation..."
node -v
npm -v
if [ $? -ne 0 ]; then
    echo "Node.js installation failed. Please check the installation process and try again."
    exit 1
fi

# Install Python 3
echo "Installing Python 3..."
sudo apt-get install -y python3 python3-pip

# Verify Python installation
echo "Verifying Python installation..."
python3 --version
pip3 --version
if [ $? -ne 0 ]; then
    echo "Python installation failed. Please check the installation process and try again."
    exit 1
fi

# Install Go
echo "Installing Go..."
wget https://go.dev/dl/go1.22.6.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.22.6.linux-amd64.tar.gz
rm go1.22.6.linux-amd64.tar.gz

# Set up Go environment variables
echo "Setting up Go environment variables..."
echo "export PATH=\$PATH:/usr/local/go/bin" | sudo tee -a /etc/profile
source /etc/profile

# Verify Go installation
echo "Verifying Go installation..."
go version
if [ $? -ne 0 ]; then
    echo "Go installation failed. Please check the installation process and try again."
    exit 1
fi

# Final summary
echo "Installation of Node.js, Python, and Go is complete."
echo "Node.js version:"
node -v
echo "npm version:"
npm -v
echo "Python version:"
python3 --version
echo "pip version:"
pip3 --version
echo "Go version:"
go version
