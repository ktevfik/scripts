# Automation Scripts for Environment Setup

This repository contains various bash scripts to automate the setup of development environments on Ubuntu. These scripts help to streamline the installation of essential tools and configurations, making it easier to set up a new machine or ensure consistency across multiple machines.

## Available Scripts

### 1. `git_setup.sh`
This script installs and configures Git with your preferred settings:
- Sets up your Git username and email.
- Configures GPG for signing commits.
- Establishes Git aliases for common commands.
- Configures a default editor for Git.
- Sets up SSH keys for secure interactions with Git hosting services.
- Adds a global `.gitignore` file and a commit message template.

### 2. `setup_java.sh`
This script installs and sets up a Java development environment, including:
- Installing OpenJDK (Java Development Kit).
- Setting up Maven for project management and build automation.

### 3. `setup_languages.sh`
This script installs popular programming languages and their tools, including:
- Node.js
- Python
- Go

### 4. `update_and_upgrade.sh`
A basic script to update and upgrade your Ubuntu system packages:
- Runs `sudo apt-get update` and `sudo apt-get upgrade` to ensure your system is up to date.

### 5. `useful_tools.sh`
This script installs a variety of useful tools for backend development, including:
- CMake
- Docker
- Docker Compose
- AWS CLI
- Vim and Neovim
- Tmux
- GCC

### 6. `.gitignore_global`
This file contains global Git ignore rules, useful for ignoring OS-specific files, editor settings, and other unneeded files across all repositories.

### 7. `.gitmessage`
This file serves as a commit message template, helping to maintain consistent commit messages across your projects.

### 8. `order-of-run.txt`
This text file provides a suggested order for running the setup scripts to ensure everything is installed and configured in the proper sequence.

## Getting Started

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/ktevfik/scripts.git
   cd scripts
   ```

2. **Make Scripts Executable and Run Them:**
   For each script, make it executable with `chmod` and then run it. For example:
   ```bash
   chmod +wrx git_setup.sh
   ./git_setup.sh
   ```

3. **Configure Git:**
   Customize `git_setup.sh` with your details and run it to configure Git on your machine.

4. **Install Languages and Tools:**
   Use `setup_languages.sh`, `setup_java.sh`, and `useful_tools.sh` to install the programming languages and tools you need.

## Contributing

Feel free to fork this repository and submit pull requests if you have improvements or additional scripts to contribute.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
