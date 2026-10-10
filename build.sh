#!/bin/bash
# MrEzequielOS - Build local no Ubuntu 24.04
set -e
VERSION="1.0"
NAME="MrEzequielOS"
OUT="out"
BASE_ISO="ubuntu-24.04-desktop-amd64.iso"
BASE_URL="https://releases.ubuntu.com/24.04/${BASE_ISO}"

mkdir -p $OUT
echo "[1/5] Instalando deps..."
sudo apt update
sudo apt install -y debootstrap squashfs-tools xorriso grub-pc-bin grub-efi-amd64-bin mtools dosfstools isolinux cubic || true

echo "[2/5] Baixando ISO base se não existir..."
[ -f "$OUT/$BASE_ISO" ] || wget -O "$OUT/$BASE_ISO" "$BASE_URL"

echo "[3/5] Para build automático completo use o GitHub Actions."
echo "Para customizar agora com Cubic:"
echo "  sudo cubic"
echo "  - Escolha $OUT/$BASE_ISO como original"
echo "  - No chroot, rode:"
echo "    apt update && xargs apt install -y < packages.list"
echo "    apt purge -y snapd firefox*snap* thunderbird* 2>/dev/null || true"
echo "    systemctl enable gdm3"
echo ""
echo "Branding MrEzequielOS aplicado via config/branding/os-release"
echo "Dica leve: GNOME = gnome-core (esse projeto já usa). Não instale ubuntu-desktop."
echo ""
echo "[4/5] Aplicando branding local (opcional)..."
cat config/branding/os-release

echo "[5/5] Pronto. ISO final vai para $OUT/${NAME}-${VERSION}-amd64.iso via Cubic ou Actions."
