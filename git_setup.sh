#!/bin/bash

# Bash script to install Git and configure it on a new Ubuntu machine

# Update and install Git
echo "Updating package lists and installing Git..."
sudo apt-get update -y
sudo apt-get install git -y

# Verify Git installation
echo "Verifying Git installation..."
git --version
if [ $? -ne 0 ]; then
    echo "Git installation failed. Please check the installation process and try again."
    exit 1
fi

# Set global user information
GIT_USER_NAME="Mustafa Tevfik Kadan (SSH User)"
GIT_USER_EMAIL="mtevfik41@gmail.com"

echo "Configuring Git user name and email..."
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"

# Set default text editor
GIT_EDITOR="vim"  # Change to "nano", "code --wait", etc. if preferred

echo "Setting default Git editor to $GIT_EDITOR..."
git config --global core.editor "$GIT_EDITOR"

# Configure line endings for Linux/MacOS
echo "Configuring line endings for Linux/MacOS..."
git config --global core.autocrlf input

# Enable colored output
echo "Enabling colored output for Git..."
git config --global color.ui auto

# Set default branch name to 'main'
echo "Setting default branch name to 'main'..."
git config --global init.defaultBranch main

# Configure SSH keys (Optional)
# This section generates an SSH key and adds it to the ssh-agent
# You can comment this section out if you don't want to automate SSH key setup

echo "Generating SSH key..."
ssh-keygen -t rsa -b 4096 -C "$GIT_USER_EMAIL" -N "" -f ~/.ssh/id_rsa

echo "Starting the SSH agent..."
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

echo "Your SSH public key is:"
cat ~/.ssh/id_rsa.pub
echo "Copy the above SSH key and add it to your Git hosting service (GitHub, GitLab, etc.)."

# Caching credentials for HTTPS connections
echo "Enabling Git credential caching..."
git config --global credential.helper 'cache --timeout=3600'

# Configure Git aliases
echo "Setting up Git aliases..."
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.df diff
git config --global alias.lg "log --oneline --graph --all --decorate"

# Final configuration summary
echo "Your Git configuration is complete. Here is a summary of the settings:"
git config --global --list

echo "Git setup script completed successfully."
