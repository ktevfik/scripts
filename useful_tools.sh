#!/bin/bash

# Hata durumunda çıkış yap
set -e

# Renkli çıktı için fonksiyonlar
echo_color() { echo -e "\e[1;32m$1\e[0m"; }
echo_error() { echo -e "\e[1;31m$1\e[0m"; }

# Sistem güncelleme
echo_color "Sistem güncelleniyor..."
sudo apt-get update -y || { echo_error "Güncelleme başarısız."; exit 1; }
sudo apt-get upgrade -y -qq || { echo_error "Yükseltme başarısız."; exit 1; }

# curl yükleme (ön koşul)
echo_color "curl yükleniyor..."
sudo apt-get install -y curl || { echo_error "curl kurulumu başarısız."; exit 1; }

# CMake yükleme
echo_color "CMake yükleniyor..."
sudo apt-get install -y cmake || { echo_error "CMake kurulumu başarısız."; exit 1; }
echo "CMake: $(cmake --version | head -n 1)"

# Docker yükleme
echo_color "Docker yükleniyor..."
sudo apt-get install -y docker.io || { echo_error "Docker kurulumu başarısız."; exit 1; }
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker "$USER"
echo "Docker: $(docker --version)"

# Docker Compose yükleme (en güncel sürüm)
echo_color "Docker Compose yükleniyor..."
DOCKER_COMPOSE_VERSION="2.29.2"  # Şubat 2025 itibarıyla güncel, gerekirse kontrol et
sudo curl -L "https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
echo "Docker Compose: $(docker-compose --version)"

# Snap yükleme
echo_color "Snap yükleniyor..."
sudo apt-get install -y snapd || { echo_error "Snap kurulumu başarısız."; exit 1; }
sudo systemctl start snapd
sudo systemctl enable snapd

# Vim yükleme
echo_color "Vim yükleniyor..."
sudo apt-get install -y vim || { echo_error "Vim kurulumu başarısız."; exit 1; }
echo "Vim: $(vim --version | head -n 1)"

# Neovim yükleme
echo_color "Neovim yükleniyor..."
sudo apt-get install -y neovim || { echo_error "Neovim kurulumu başarısız."; exit 1; }
echo "Neovim: $(nvim --version | head -n 1)"

# Tmux yükleme
echo_color "Tmux yükleniyor..."
sudo apt-get install -y tmux || { echo_error "Tmux kurulumu başarısız."; exit 1; }
echo "Tmux: $(tmux -V)"

# GCC (build-essential) yükleme
echo_color "GCC ve derleme araçları yükleniyor..."
sudo apt-get install -y build-essential || { echo_error "GCC kurulumu başarısız."; exit 1; }
echo "GCC: $(gcc --version | head -n 1)"

# Ek faydalı araçlar
echo_color "Ek faydalı araçlar yükleniyor..."

# htop (sistem izleme)
sudo apt-get install -y htop || echo "htop kurulumu başarısız, devam ediliyor."
echo "htop: $(htop --version 2>/dev/null || echo 'Yüklenmedi')"

# jq (JSON işleme)
sudo apt-get install -y jq || echo "jq kurulumu başarısız, devam ediliyor."
echo "jq: $(jq --version 2>/dev/null || echo 'Yüklenmedi')"

# Sonuç özeti
echo_color "CMake, Docker, Docker Compose, Snap, AWS CLI, Vim, Neovim, Tmux, GCC ve ek araçlar kurulumu tamamlandı!"
echo "CMake: $(cmake --version | head -n 1)"
echo "Docker: $(docker --version)"
echo "Docker Compose: $(docker-compose --version)"
echo "Vim: $(vim --version | head -n 1)"
echo "Neovim: $(nvim --version | head -n 1)"
echo "Tmux: $(tmux -V)"
echo "GCC: $(gcc --version | head -n 1)"
echo "htop: $(htop --version 2>/dev/null || echo 'Yüklenmedi')"
echo "jq: $(jq --version 2>/dev/null || echo 'Yüklenmedi')"
echo_color "Not: Docker’ı tam kullanmak için terminali kapatıp açmanız gerekebilir."