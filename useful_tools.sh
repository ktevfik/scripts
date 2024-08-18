#!/bin/bash

# Bash script to install CMake, Docker, Docker Compose, Snap, AWS CLI (via Snap), Vim, Neovim, Tmux, and GCC on Ubuntu

# Update package lists and upgrade system packages
echo "Updating package lists and upgrading system packages..."
sudo apt-get update -y
sudo apt-get upgrade -y

# Install curl
echo "Installing curl..."
sudo apt-get install -y curl

# Install CMake
echo "Installing CMake..."
sudo apt-get install -y cmake

# Verify CMake installation
echo "Verifying CMake installation..."
cmake --version
if [ $? -ne 0 ]; then
    echo "CMake installation failed. Please check the installation process and try again."
    exit 1
fi

# Install Docker
echo "Installing Docker..."
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

# Verify Docker installation
echo "Verifying Docker installation..."
docker --version
if [ $? -ne 0 ]; then
    echo "Docker installation failed. Please check the installation process and try again."
    exit 1
fi

# Add current user to the Docker group
echo "Adding current user to the Docker group..."
sudo usermod -aG docker $USER

# Install Docker Compose
echo "Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/v2.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify Docker Compose installation
echo "Verifying Docker Compose installation..."
docker-compose --version
if [ $? -ne 0 ]; then
    echo "Docker Compose installation failed. Please check the installation process and try again."
    exit 1
fi

# Install Snap
echo "Installing Snap..."
sudo apt-get install -y snapd
sudo systemctl start snapd
sudo systemctl enable snapd

# Install AWS CLI via Snap
echo "Installing AWS CLI via Snap..."
sudo snap install aws-cli --classic

# Verify AWS CLI installation
echo "Verifying AWS CLI installation..."
aws --version
if [ $? -ne 0 ]; then
    echo "AWS CLI installation failed. Please check the installation process and try again."
    exit 1
fi

# Install Vim
echo "Installing Vim..."
sudo apt-get install -y vim

# Verify Vim installation
echo "Verifying Vim installation..."
vim --version
if [ $? -ne 0 ]; then
    echo "Vim installation failed. Please check the installation process and try again."
    exit 1
fi

# Install Neovim
echo "Installing Neovim..."
sudo apt-get install -y neovim

# Verify Neovim installation
echo "Verifying Neovim installation..."
nvim --version
if [ $? -ne 0 ]; then
    echo "Neovim installation failed. Please check the installation process and try again."
    exit 1
fi

# Install Tmux
echo "Installing Tmux..."
sudo apt-get install -y tmux

# Verify Tmux installation
echo "Verifying Tmux installation..."
tmux -V
if [ $? -ne 0 ]; then
    echo "Tmux installation failed. Please check the installation process and try again."
    exit 1
fi

# Install GCC
echo "Installing GCC..."
sudo apt-get install -y build-essential

# Verify GCC installation
echo "Verifying GCC installation..."
gcc --version
if [ $? -ne 0 ]; then
    echo "GCC installation failed. Please check the installation process and try again."
    exit 1
fi

# Final summary
echo "Installation of CMake, Docker, Docker Compose, Snap, AWS CLI, Vim, Neovim, Tmux, and GCC is complete."
echo "CMake version:"
cmake --version
echo "Docker version:"
docker --version
echo "Docker Compose version:"
docker-compose --version
echo "AWS CLI version:"
aws --version
echo "Vim version:"
vim --version
echo "Neovim version:"
nvim --version
echo "Tmux version:"
tmux -V
echo "GCC version:"
gcc --version
