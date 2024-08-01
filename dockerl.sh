#!/bin/bash
echo "Installing Docker"

# Detect the operating system
if [ -f /etc/redhat-release ]; then
    OS="rhel"
elif [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    OS=$DISTRIB_ID
else
    echo "Unsupported operating system"
    exit 1
fi

# Install Docker for RHEL
if [ "$OS" == "rhel" ]; then
    sudo dnf --refresh update
    sudo dnf upgrade
    sudo dnf install yum-utils
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    sudo dnf install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
    sudo systemctl start docker
    sudo systemctl enable docker

# Install Docker for Ubuntu
elif [ "$OS" == "Ubuntu" ]; then
    sudo apt-get update
    sudo apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose docker-compose-plugin
else
    echo "Unsupported operating system"
    exit 1
fi

echo "Docker installation completed."
