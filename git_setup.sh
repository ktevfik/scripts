#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Bash script to install Git, configure it, and set up GPG signing on a new Ubuntu machine.

# Update package lists and install Git and GPG
echo "Updating package lists and installing Git and GPG..."
sudo apt-get update -y
sudo apt-get install git gnupg -y

# Verify Git installation
echo "Verifying Git installation..."
if git --version > /dev/null 2>&1; then
    echo "Git installed successfully: $(git --version)"
else
    echo "Git installation failed. Please check the installation process and try again."
    exit 1
fi

# Set global user information
GIT_USER_NAME="Mustafa Tevfik Kadan"
GIT_USER_EMAIL="mtevfik41@gmail.com"

echo "Configuring Git user name and email..."
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"
echo "Git user name and email configured: $GIT_USER_NAME <$GIT_USER_EMAIL>"

# Set default text editor
GIT_EDITOR="code --wait"  # Change to "nano", "vim", etc. if preferred

echo "Setting default Git editor to $GIT_EDITOR..."
git config --global core.editor "$GIT_EDITOR"
echo "Default Git editor set to $GIT_EDITOR"

# Configure line endings for Linux/MacOS
echo "Configuring line endings for Linux/MacOS..."
git config --global core.autocrlf input
echo "Line endings configured for Linux/MacOS"

# Enable colored output
echo "Enabling colored output for Git..."
git config --global color.ui auto
echo "Colored output enabled for Git"

# Set default branch name to 'main'
echo "Setting default branch name to 'main'..."
git config --global init.defaultBranch main
echo "Default branch name set to 'main'"

# Generate or use existing GPG key
#echo "Checking for existing GPG keys..."
#GPG_KEY_ID=$(gpg --list-secret-keys --keyid-format LONG | grep 'sec ' | awk '{print $2}' | cut -d '/' -f 2 | head -n 1)
#
#if [[ -z "$GPG_KEY_ID" ]]; then
#    echo "No existing GPG key found. Generating a new GPG key..."
#    gpg --full-generate-key
#    GPG_KEY_ID=$(gpg --list-secret-keys --keyid-format LONG | grep 'sec ' | awk '{print $2}' | cut -d '/' -f 2 | head -n 1)
#    echo "GPG key generated successfully: $GPG_KEY_ID"
#else
#    echo "Using existing GPG key: $GPG_KEY_ID"
#fi
#
## Configure Git to use the GPG key for signing commits
#echo "Configuring Git to use GPG key for signing commits..."
#git config --global user.signingkey "$GPG_KEY_ID"
#git config --global commit.gpgsign true
#git config --global gpg.program "gpg"
#echo "Git is configured to use GPG key $GPG_KEY_ID for signing commits."
#
## Export GPG public key (optional)
#echo "Exporting your GPG public key..."
#gpg --armor --export "$GPG_KEY_ID" > ~/gpg_public_key.asc
#echo "Your GPG public key has been exported to ~/gpg_public_key.asc."

# Configure SSH keys (Optional)
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
echo "Git credential caching enabled"

# Configure Git aliases
echo "Setting up Git aliases..."
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.a add
git config --global alias.ci commit
git config --global alias.df diff
git config --global alias.lg "log --oneline --graph --all --decorate"
echo "Git aliases configured"

# Configure commit message template and global gitignore
echo "Setting up commit message template and global gitignore..."
git config --global commit.template ~/.gitmessage
git config --global core.excludesfile ~/.gitignore_global
echo "Commit template and global gitignore configured"

# Add GPG_TTY to .bashrc
echo "Adding GPG_TTY to .bashrc..."
echo "export GPG_TTY=\$(tty)" >> ~/.bashrc
source ~/.bashrc
echo "GPG_TTY configured in .bashrc"

# Add GPG_TTY to .bashrc
echo "Adding GPG_TTY to .zshrc..."
echo "export GPG_TTY=\$(tty)" >> ~/.zshrc
source ~/.zshrc
echo "GPG_TTY configured in .zshrc"

# Final configuration summary
echo "Your Git configuration is complete. Here is a summary of the settings:"
git config --global --list

echo "Git setup script with GPG signing completed successfully."
