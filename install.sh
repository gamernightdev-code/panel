#!/bin/bash

# ==========================================
# Windows 10 Docker Control Script by Deepak
# ==========================================

DIR="dockercomp"
YAML_FILE="windows10.yml"

menu() {
  echo "============================"
  echo "  WINDOWS 10 DOCKER MANAGER "
  echo "============================"
  echo "1) Install & Start Windows 10"
  echo "2) Restart Windows Container"
  echo "3) Stop Windows Container"
  echo "4) Reboot VPS"
  echo "============================"
  read -p "Choose an option [1-4]: " choice
  case $choice in
    1) install_and_start ;;
    2) restart_container ;;
    3) stop_container ;;
    4) reboot_vps ;;
    *) echo "Invalid choice, exiting..." ;;
  esac
}

install_and_start() {
  echo "[1/5] Updating system packages..."
  sudo apt update -y

  echo "[2/5] Installing Docker & Docker Compose..."
  sudo apt install -y docker.io docker-compose

  echo "[3/5] Enabling Docker service..."
  sudo systemctl enable docker
  sudo systemctl start docker

  echo "[4/5] Preparing directory..."
  mkdir -p "$DIR"
  cd "$DIR" || exit

  echo "[5/5] Creating docker-compose file..."
  cat > $YAML_FILE <<EOL
services:
  windows:
    image: dockurr/windows
    container_name: windows
    environment:
      VERSION: "10"
      USERNAME: "MASTER"
      PASSWORD: "admin@123"
      RAM_SIZE: "4G"
      CPU_CORES: "4"
      DISK_SIZE: "100G"
      DISK2_SIZE: "50G"
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

  echo "Launching Windows 10 container..."
  sudo docker-compose -f $YAML_FILE up -d
  echo "✅ Windows 10 container started successfully!"
}

restart_container() {
  echo "Restarting Windows 10 container..."
  cd "$DIR" || exit
  sudo docker-compose -f $YAML_FILE restart
  echo "✅ Windows 10 container restarted!"
}

stop_container() {
  echo "Stopping Windows 10 container..."
  cd "$DIR" || exit
  sudo docker-compose -f $YAML_FILE down
  echo "🛑 Windows 10 container stopped!"
}

reboot_vps() {
  echo "♻️ Rebooting VPS..."
  sudo reboot
}

menu
