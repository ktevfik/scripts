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

# OpenJDK sürümlerini yükleme (11, 17, 21)
echo_color "OpenJDK 11, 17 ve 21 yükleniyor..."
for version in 11 17 21; do
    sudo apt-get install -y "openjdk-${version}-jdk" || { echo_error "OpenJDK $version kurulumu başarısız."; exit 1; }
done

# Java ve javac için alternatifleri ayarlama
echo_color "Java ve javac alternatifleri yapılandırılıyor..."
for version in 11 17 21; do
    sudo update-alternatives --install /usr/bin/java java "/usr/lib/jvm/java-${version}-openjdk-amd64/bin/java" $((version+1))
    sudo update-alternatives --install /usr/bin/javac javac "/usr/lib/jvm/java-${version}-openjdk-amd64/bin/javac" $((version+1))
done

# Varsayılan Java ve javac seçimi
echo_color "Varsayılan Java sürümü seçiliyor..."
sudo update-alternatives --config java
echo_color "Varsayılan javac sürümü seçiliyor..."
sudo update-alternatives --config javac

# Java doğrulama
echo_color "Java kurulumu doğrulanıyor..."
if java -version >/dev/null 2>&1; then
    echo "Java sürümü: $(java -version 2>&1 | head -n 1)"
else
    echo_error "Java kurulumu başarısız. Lütfen kontrol edin."
    exit 1
fi

# JAVA_HOME ve PATH ayarlama
echo_color "JAVA_HOME ve PATH çevre değişkenleri ayarlanıyor..."
JAVA_HOME=$(dirname "$(dirname "$(readlink -f "$(which java)")")")
echo "export JAVA_HOME=$JAVA_HOME" | sudo tee -a /etc/profile.d/java.sh
echo "export PATH=\$JAVA_HOME/bin:\$PATH" | sudo tee -a /etc/profile.d/java.sh
chmod +x /etc/profile.d/java.sh
source /etc/profile.d/java.sh
echo "JAVA_HOME: $JAVA_HOME"

# Maven yükleme ve doğrulama
echo_color "Maven yükleniyor..."
sudo apt-get install -y maven || { echo_error "Maven kurulumu başarısız."; exit 1; }
if mvn -version >/dev/null 2>&1; then
    echo "Maven sürümü: $(mvn -version | head -n 1)"
else
    echo_error "Maven kurulumu başarısız."
    exit 1
fi

# Gradle yükleme (en son sürüm için manuel indirme)
echo_color "Gradle yükleniyor (en son sürüm)..."
GRADLE_VERSION="8.6"  # Şubat 2025 itibarıyla en güncel sürüm, gerekirse güncelle
if ! command -v gradle >/dev/null 2>&1 || [[ $(gradle -v | grep "Gradle" | awk '{print $2}') != "$GRADLE_VERSION" ]]; then
    wget -q "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" -O /tmp/gradle.zip
    sudo mkdir -p /opt/gradle
    sudo unzip -q /tmp/gradle.zip -d /opt/gradle
    sudo ln -sf /opt/gradle/gradle-${GRADLE_VERSION}/bin/gradle /usr/bin/gradle
    rm /tmp/gradle.zip
fi
if gradle -v >/dev/null 2>&1; then
    echo "Gradle sürümü: $(gradle -v | grep 'Gradle' | awk '{print $2}')"
else
    echo_error "Gradle kurulumu başarısız."
    exit 1
fi

# Ekstra Java araçları
echo_color "Ekstra Java araçları yükleniyor..."

# IntelliJ IDEA Community (IDE)
echo_color "IntelliJ IDEA Community yükleniyor..."
sudo snap install intellij-idea-community --classic || echo "IntelliJ IDEA zaten kurulu veya snap desteklenmiyor."

# Jenv (Java sürüm yönetimi)
echo_color "Jenv yükleniyor (Java sürüm yönetimi)..."
git clone https://github.com/jenv/jenv.git ~/.jenv
echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(jenv init -)"' >> ~/.bashrc
echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(jenv init -)"' >> ~/.zshrc
source ~/.bashrc 2>/dev/null || source ~/.zshrc 2>/dev/null
for version in 11 17 21; do
    jenv add "/usr/lib/jvm/java-${version}-openjdk-amd64" 2>/dev/null
done
jenv enable-plugin export >/dev/null 2>&1
echo "Jenv ile kullanılabilir Java sürümleri: $(jenv versions)"

# Sonuç özeti
echo_color "Java geliştirme ortamı kurulumu tamamlandı!"
echo "Java sürümü:"
java -version
echo "JAVA_HOME: $JAVA_HOME"
echo "Maven sürümü:"
mvn -version
echo "Gradle sürümü:"
gradle -v