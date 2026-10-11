#!/bin/bash
# MrEzequielOS - Instala extensões estilo Zorin OS (GNOME 46 / Ubuntu 24.04)
# Dash to Panel (taskbar Windows) + ArcMenu (menu iniciar) + Blur + Icons + AppIndicator
# Roda no chroot durante o build. Falha isolada não quebra o build.
set -u
EXT_DIR="/usr/share/gnome-shell/extensions"
TMP="/tmp/mre-ext"
mkdir -p "$EXT_DIR" "$TMP"
cd "$TMP"

try_install() {
  name="$1"; shift
  echo "[ext] $name ..."
  if "$@" ; then echo "[ext] OK: $name"; else echo "[ext] AVISO: $name falhou, continuando"; fi
}

# 1) Dash to Panel - taskbar estilo Windows/Zorin
install_dashtopanel() {
  rm -rf dash-to-panel
  git clone --depth 1 https://github.com/home-sweet-gnome/dash-to-panel.git dash-to-panel \
    || git clone --depth 1 https://github.com/jderose9/dash-to-panel.git dash-to-panel
  cd dash-to-panel && make install DESTDIR="" 2>/dev/null || make install || return 1
  cd ..
}
# 2) ArcMenu - menu iniciar estilo Zorin Menu / Windows
install_arcmenu() {
  rm -rf ArcMenu && git clone --depth 1 https://github.com/arcmenu/ArcMenu.git
  cd ArcMenu && (make install || (meson setup build --prefix=/usr && ninja -C build install)) || return 1
  cd ..
}
# 3) Blur my Shell - blur do Zorin (top bar + overview)
install_blur() {
  rm -rf blur-my-shell && git clone --depth 1 https://github.com/aunetx/blur-my-shell.git
  cd blur-my-shell && meson setup build --prefix=/usr && ninja -C build install || return 1
  cd ..
}
# 4) Desktop Icons NG (DING) - ícones na área de trabalho como Zorin/Windows
install_ding() {
  rm -rf ding && git clone --depth 1 https://gitlab.com/rastersoft/desktop-icons-ng.git ding
  UUID="ding@rastersoft.com"
  mkdir -p "$EXT_DIR/$UUID"
  cp -r ding/*.js ding/metadata.json "$EXT_DIR/$UUID/" || return 1
  [ -d ding/schemas ] && mkdir -p "$EXT_DIR/$UUID/schemas" && cp -r ding/schemas/* "$EXT_DIR/$UUID/schemas/"
  [ -d ding/locale ] && cp -r ding/locale "$EXT_DIR/$UUID/"
  [ -f ding/stylesheet.css ] && cp ding/stylesheet.css "$EXT_DIR/$UUID/"
  glib-compile-schemas "$EXT_DIR/$UUID/schemas" 2>/dev/null || true
}
# 5) AppIndicator - bandeja (tray) como Windows
install_appindicator() {
  rm -rf gnome-shell-extension-appindicator && git clone --depth 1 https://github.com/ubuntu/gnome-shell-extension-appindicator.git
  cd gnome-shell-extension-appindicator && (meson setup build --prefix=/usr && ninja -C build install) || return 1
  cd ..
}

try_install "dash-to-panel" install_dashtopanel
try_install "arcmenu" install_arcmenu
try_install "blur-my-shell" install_blur
try_install "desktop-icons-ng" install_ding
try_install "appindicator" install_appindicator

echo "[ext] Extensões em $EXT_DIR:"
ls -1 "$EXT_DIR" || true
echo "[ext] pronto."
