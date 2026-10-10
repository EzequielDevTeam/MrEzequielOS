#!/bin/bash
# Aplica visual MrEzequielOS estilo Zorin no chroot / sistema instalado
set -e
BASE="$(dirname "$0")"
echo "[visual] Temas..."
apt update
apt install -y yaru-theme-gtk yaru-theme-icon yaru-theme-gnome-shell papirus-icon-theme gnome-tweaks gnome-shell-extension-manager zenity dconf-editor fonts-inter 2>/dev/null || true
# Extensões extras do arquivo (podem não existir no 24.04; falha aqui não quebra nada)
apt install -y gnome-shell-extension-gsconnect gnome-shell-extension-user-theme 2>/dev/null || true

echo "[visual] Firefox deb real (via Mozilla Team PPA, sem snap)..."
( add-apt-repository -y ppa:mozillateam/ppa 2>/dev/null || true
  cat > /etc/apt/preferences.d/mozilla-firefox <<'EOF'
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
EOF
  apt update || true
  apt install -y firefox 2>/dev/null || true
  apt install -y firefox-locale-pt 2>/dev/null || true ) || echo "AVISO Firefox PPA falhou, usando Epiphany"
echo "[visual] Wallpaper + logo..."
mkdir -p /usr/share/backgrounds /usr/share/pixmaps /usr/local/bin /usr/share/applications
cp "$BASE/branding/wallpaper.svg" /usr/share/backgrounds/mrezequielos-wallpaper.svg 2>/dev/null || true
cp "$BASE/branding/logo.svg" /usr/share/pixmaps/mrezequielos-logo.svg 2>/dev/null || true
cp "$BASE/branding/logo.svg" /usr/share/pixmaps/mrezequielos.svg 2>/dev/null || true

echo "[visual] Extensões estilo Zorin..."
chmod +x "$BASE/gnome/install-extensions.sh" "$BASE/gnome/mrezequielos-appearance" || true
"$BASE/gnome/install-extensions.sh" || echo "AVISO extensões falharam, seguindo"

echo "[visual] App Appearance (trocar layout Windows/macOS)..."
cp "$BASE/gnome/mrezequielos-appearance" /usr/local/bin/mrezequielos-appearance
chmod +x /usr/local/bin/mrezequielos-appearance
cat > /usr/share/applications/mrezequielos-appearance.desktop <<'EOF'
[Desktop Entry]
Name=MrEzequielOS Appearance
Comment=Trocar layout Windows / macOS / Ubuntu (estilo Zorin)
Exec=mrezequielos-appearance
Icon=mrezequielos
Terminal=false
Type=Application
Categories=Settings;DesktopSettings;
EOF

echo "[visual] Defaults GNOME para novos usuários..."
mkdir -p /etc/dconf/db/gdm.d
cat > /etc/dconf/db/gdm.d/95-mrezequielos <<'EOF'
[org/gnome/desktop/interface]
gtk-theme='Yaru-dark'
icon-theme='Papirus-Dark'
cursor-theme='Yaru'
font-name='Inter 11'

[org/gnome/desktop/background]
picture-uri='file:///usr/share/backgrounds/mrezequielos-wallpaper.svg'
picture-uri-dark='file:///usr/share/backgrounds/mrezequielos-wallpaper.svg'

[org/gnome/shell]
favorite-apps=['firefox.desktop', 'org.gnome.Nautilus.desktop', 'libreoffice-writer.desktop', 'org.gnome.Terminal.desktop', 'gnome-software.desktop']
enabled-extensions=['dash-to-panel@jderose9.github.com', 'arcmenu@arcmenu.com', 'blur-my-shell@aunetx', 'ding@rastersoft.com', 'appindicatorsupport@rgcjonas.gmail.com', 'user-theme@gnome-shell-extensions.gcampax.github.com', 'gsconnect@andyholmes.github.io']
EOF
dconf update || true

echo "[visual] Zorin Connect (GSConnect) ativado por padrão."
echo "[visual] GRUB + hostname..."
sed -i 's/^GRUB_DISTRIBUTOR=.*/GRUB_DISTRIBUTOR="MrEzequielOS"/' /etc/default/grub 2>/dev/null || echo 'GRUB_DISTRIBUTOR="MrEzequielOS"' >> /etc/default/grub
echo "MrEzequielOS" > /etc/hostname 2>/dev/null || true
update-grub 2>/dev/null || true
echo "OK - visual estilo Zorin aplicado. Layout padrão: Windows (taskbar embaixo + menu iniciar)."
