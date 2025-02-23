#!/bin/bash

# Renkli çıktı için fonksiyon
echo_color() { echo -e "\e[1;32m$1\e[0m"; }

# Sistem güncelleme ve bağımlılıklar
echo_color "Sistem güncelleniyor ve bağımlılıklar yükleniyor..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git zsh nano kitty

# Kitty tema ve ayar dosyası oluşturma
echo_color "Kitty için Dracula teması ve temel ayarlar yapılandırılıyor..."
mkdir -p ~/.config/kitty
cat << EOF > ~/.config/kitty/kitty.conf
# Tema
include /usr/share/kitty-themes/themes/Dracula.conf

# Font ve boyut
font_family      Fira Code
font_size        12

# Temel özelleştirmeler
background_opacity 0.95
cursor_shape       beam
scrollback_lines   10000
EOF

# Kitty temalarının kontrolü (eksikse indirme)
if [ ! -d "/usr/share/kitty-themes" ]; then
    echo_color "Kitty temaları indiriliyor..."
    git clone https://github.com/dexpota/kitty-themes.git /tmp/kitty-themes
    sudo mkdir -p /usr/share/kitty-themes
    sudo cp -r /tmp/kitty-themes/themes /usr/share/kitty-themes/
    rm -rf /tmp/kitty-themes
fi

# Zsh varsayılan shell yapma
echo_color "Zsh kuruluyor ve varsayılan shell yapılıyor..."
chsh -s $(which zsh)

# Oh My Zsh kurulumu
echo_color "Oh My Zsh kuruluyor..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Powerlevel10k tema kurulumu
echo_color "Powerlevel10k teması kuruluyor..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# Zsh eklentileri
echo_color "Zsh eklentileri kuruluyor (autosuggestions, syntax-highlighting, you-should-use)..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/you-should-use

# Zshrc'ye eklentileri ekleme
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting you-should-use)/' ~/.zshrc

# Bat kurulumu ve yapılandırma
echo_color "Bat kuruluyor ve yapılandırılıyor..."
sudo apt install -y bat
echo "alias cat='bat --paging=never --style=plain'" >> ~/.zshrc
echo "alias preview='bat --style=numbers,changes,grid'" >> ~/.zshrc
echo "export BAT_THEME='Dracula'" >> ~/.zshrc

# Değişiklikleri uygula
echo_color "Yapılandırmalar uygulanıyor..."
source ~/.zshrc

echo_color "Kurulum tamamlandı! Terminali kapatıp açarak yeni ayarları kullanabilirsin."
echo_color "Powerlevel10k yapılandırmasını tamamlamak için terminali açtığında sihirbazı takip et."
