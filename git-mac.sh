#!/bin/bash
set -euo pipefail

########################
# 1) Kişisel Bilgiler  #
########################
GIT_USER_NAME="Mustafa Tevfik Kadan"
GIT_USER_EMAIL="mtevfik41@gmail.com"
GIT_EDITOR="code --wait"        # nano, vim, subl vb.
SHELL_RC="$HOME/.zshrc"         # Bash kullanıyorsan ~/.bashrc

########################
# 2) Homebrew & Git    #
########################
echo "🔧 Homebrew kontrol ediliyor..."
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "⬇️  Git kuruluyor..."
brew install git

########################
# 3) Git Ayarları      #
########################
git config --global user.name  "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"
git config --global core.editor "$GIT_EDITOR"
git config --global core.autocrlf input
git config --global color.ui auto
git config --global init.defaultBranch main
git config --global credential.helper osxkeychain

git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.a  add
git config --global alias.ci commit
git config --global alias.df diff
git config --global alias.lg "log --oneline --graph --all --decorate"

touch ~/.gitmessage ~/.gitignore_global
git config --global commit.template ~/.gitmessage
git config --global core.excludesfile ~/.gitignore_global

########################
# 4) SSH Anahtarı      #
########################
if [[ ! -f ~/.ssh/id_ed25519 ]]; then
  echo "🔑 ed25519 SSH anahtarı oluşturuluyor..."
  ssh-keygen -t ed25519 -C "$GIT_USER_EMAIL" -N "" -f ~/.ssh/id_ed25519
fi

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

########################
# 5) Özet              #
########################
echo -e "\n▶️  SSH public key:"
cat ~/.ssh/id_ed25519.pub
echo -e "\n🎉 Kurulum tamamlandı. Mevcut Git ayarlarınız:"
git config --global --list