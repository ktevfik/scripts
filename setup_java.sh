#!/bin/bash

# Bash script to set up a Java development environment on Ubuntu

# Update package lists and upgrade system packages
echo "Updating package lists and upgrading system packages..."
sudo apt-get update -y
sudo apt-get upgrade -y

# Install OpenJDK 8, 11, 17, and 21 (Java Development Kit)
echo "Installing OpenJDK 8, 11, 17, and 21..."
sudo apt-get install openjdk-8-jdk -y
sudo apt-get install openjdk-11-jdk -y
sudo apt-get install openjdk-17-jdk -y
sudo apt-get install openjdk-21-jdk -y

# Set up alternatives for Java
echo "Setting up alternatives for Java..."
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-8-openjdk-amd64/bin/java 1
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-11-openjdk-amd64/bin/java 2
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-17-openjdk-amd64/bin/java 3
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-21-openjdk-amd64/bin/java 4

# Set up alternatives for javac (Java Compiler)
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/java-8-openjdk-amd64/bin/javac 1
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/java-11-openjdk-amd64/bin/javac 2
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/java-17-openjdk-amd64/bin/javac 3
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/java-21-openjdk-amd64/bin/javac 4

# Prompt the user to select the default Java version
echo "Selecting the default Java version..."
sudo update-alternatives --config java

# Prompt the user to select the default javac version
echo "Selecting the default javac version..."
sudo update-alternatives --config javac

# Verify Java installation
echo "Verifying Java installation..."
java -version
if [ $? -ne 0 ]; then
    echo "Java installation failed. Please check the installation process and try again."
    exit 1
fi

# Set JAVA_HOME environment variable for the selected Java version
echo "Setting JAVA_HOME environment variable..."
echo "export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))" | sudo tee -a /etc/profile
echo "export PATH=\$JAVA_HOME/bin:\$PATH" | sudo tee -a /etc/profile
source /etc/profile

# Install Maven
echo "Installing Maven..."
sudo apt-get install maven -y

# Verify Maven installation
echo "Verifying Maven installation..."
mvn -version
if [ $? -ne 0 ]; then
    echo "Maven installation failed. Please check the installation process and try again."
    exit 1
fi

# Install Gradle
echo "Installing Gradle..."
sudo apt-get install gradle -y

# Verify Gradle installation
echo "Verifying Gradle installation..."
gradle -v
if [ $? -ne 0 ]; then
    echo "Gradle installation failed. Please check the installation process and try again."
    exit 1
fi

# Final summary
echo "Java development environment setup is complete."
echo "Java version:"
java -version
echo "Maven version:"
mvn -version
echo "Gradle version:"
gradle -v
