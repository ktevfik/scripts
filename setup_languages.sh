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

# Node.js kurulumu (en güncel LTS sürüm)
echo_color "Node.js (LTS) yükleniyor..."
NODE_VERSION="20.16.0"  # Şubat 2025 itibarıyla LTS, gerekirse güncelle
wget -q "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz" -O /tmp/node.tar.xz
sudo tar -xJvf /tmp/node.tar.xz -C /usr/local --strip-components=1
rm /tmp/node.tar.xz
if node -v >/dev/null 2>&1 && npm -v >/dev/null 2>&1; then
    echo "Node.js: $(node -v)"
    echo "npm: $(npm -v)"
else
    echo_error "Node.js kurulumu başarısız."
    exit 1
fi

# npm ile ek araçlar
echo_color "npm ile faydalı araçlar yükleniyor..."
sudo npm install -g yarn pnpm n

# Python 3 ve pipx kurulumu
echo_color "Python 3, pip ve pipx yükleniyor..."
sudo apt-get install -y python3 python3-pip python3-venv pipx || { echo_error "Python veya pipx kurulumu başarısız."; exit 1; }
if python3 --version >/dev/null 2>&1 && pip3 --version >/dev/null 2>&1; then
    echo "Python: $(python3 --version)"
    echo "pip: $(pip3 --version)"
else
    echo_error "Python kurulumu başarısız."
    exit 1
fi

# Go kurulumu
echo_color "Go yükleniyor..."
GO_VERSION="1.22.6"  # Şubat 2025 itibarıyla güncel, gerekirse güncelle
wget -q "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -O /tmp/go.tar.gz
sudo tar -C /usr/local -xzf /tmp/go.tar.gz
rm /tmp/go.tar.gz
echo "export PATH=\$PATH:/usr/local/go/bin" | sudo tee -a /etc/profile.d/go.sh
chmod +x /etc/profile.d/go.sh
source /etc/profile.d/go.sh
if go version >/dev/null 2>&1; then
    echo "Go: $(go version)"
else
    echo_error "Go kurulumu başarısız."
    exit 1
fi

# Go için ek araçlar
echo_color "Go için ek araçlar yükleniyor..."
echo "export GOPATH=\$HOME/go" >> ~/.bashrc
echo "export PATH=\$PATH:\$GOPATH/bin" >> ~/.bashrc
echo "export GOPATH=\$HOME/go" >> ~/.zshrc
echo "export PATH=\$PATH:\$GOPATH/bin" >> ~/.zshrc
source ~/.bashrc 2>/dev/null || source ~/.zshrc 2>/dev/null
go install golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest

# Rust kurulumu
echo_color "Rust yükleniyor..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
source "$HOME/.cargo/env"
if rustc --version >/dev/null 2>&1; then
    echo "Rust: $(rustc --version)"
else
    echo_error "Rust kurulumu başarısız."
    exit 1
fi

# Rust için ek araçlar
echo_color "Rust için faydalı araçlar yükleniyor..."
cargo install cargo-watch
cargo install cargo-edit

# Ortak geliştirme araçları
echo_color "Ortak geliştirme araçları yükleniyor..."
sudo apt-get install -y build-essential curl

# Sonuç özeti
echo_color "Node.js, Python, Go ve Rust kurulumları tamamlandı!"
echo "Node.js: $(node -v)"
echo "npm: $(npm -v)"
echo "Yarn: $(yarn --version 2>/dev/null || echo 'Yüklenmedi')"
echo "pnpm: $(pnpm --version 2>/dev/null || echo 'Yüklenmedi')"
echo "Python: $(python3 --version)"
echo "pip: $(pip3 --version)"
echo "Go: $(go version)"
echo "GOPATH: $HOME/go"
echo "Rust: $(rustc --version)"
echo "Cargo: $(cargo --version)"