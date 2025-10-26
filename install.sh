#!/bin/bash

# This script sets up Docker, creates a Windows 11 container using dockurr/windows

# Update and install Docker & Docker Compose
echo "Updating system and installing Docker..."
sudo apt update -y
sudo apt install -y docker.io docker-compose

# Create project directory
PROJECT_DIR="$HOME/dockercom"
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR" || exit

# Create docker-compose file
echo "Creating windows11.yml..."
cat <<EOL > windows11.yml
version: '3.8'

services:
  windows:
    image: dockurr/windows
    container_name: windows
    environment:
      VERSION: "11"
      USERNAME: "SOURAV SEC"
      PASSWORD: "admin@123"
      RAM_SIZE: "2G"
      CPU_CORES: "4"
      DISK_SIZE: "400G"
      DISK2_SIZE: "100G"
    devices:
      - /dev/kvm
      - /dev/net/tun
    cap_add:
      - NET_ADMIN
    ports:
      - "8006:8006"
      - "3389:3389/tcp"
      - "3389:3389/udp"
    stop_grace_period: 2m
EOL

# Run docker-compose
echo "Starting Windows 11 container..."
sudo docker-compose -f windows11.yml up -d

echo "Setup complete! Access your container via RDP on port 3389 or web UI on port 8006."
