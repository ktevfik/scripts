#!/bin/bash

# Update the package list
echo "Updating package list..."
sudo apt update

# Upgrade all packages
echo "Upgrading all packages..."
sudo apt upgrade -y

# Clean up unnecessary packages
echo "Cleaning up unnecessary packages..."
sudo apt autoremove -y

echo "System update and upgrade complete!"

