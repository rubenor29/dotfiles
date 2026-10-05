#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEBS_PATH="$HOME/packages/debs"

echo "============================================================"
echo "[Script] Configurando Repositorios y Arquitectura"
echo "============================================================"
# 1. Habilitar soporte para paquetes de 32 bits (Requerido para Steam y WINE)
sudo dpkg --add-architecture i386

# 2. Inyectar componentes contrib, non-free y non-free-firmware
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget git build-essential apt
# sudo apt-add-repository -y contrib
# sudo apt-add-repository -y non-free
# sudo apt-add-repository -y non-free-firmware

echo "============================================================"
echo "[Script] Configurando Flatpak y GNOME Software"
echo "============================================================"
# Instalar el daemon de flatpak y la abstracción (plugin) para que GNOME Software lo administre
sudo apt install -y flatpak gnome-software gnome-software-plugin-flatpak
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "============================================================"
echo "[Script] Instalando paquetes nativos (APT)"
echo "============================================================"
sudo apt update
sudo apt install -y \
    git \
    git-delta \
    gnome-shell-extension-manager \
    papirus-icon-theme \
    wl-clipboard \
    fish \
    kitty \
    bat \
    zoxide \
    tmux \
    fzf \
    syncthing \
    neovim \
    openjdk-25-jdk \
    maven \
    mariadb-server \
    mariadb-client \
    postgresql \
    podman \
    podman-compose \
    podman-docker \
    dia \
    filezilla \
    cmake \
    steam-installer \
    adb \
    fastboot \
    pipewire-pulse \
    python3 \
    python3-pip \
    thunderbird \
    eza \
    npm \
    python3-venv

echo "============================================================"
echo "[Script] Instalando herramientas modernas (Rust / Scripts)"
echo "============================================================"
# Debian estable con frecuencia empaqueta versiones anticuadas o no incluye herramientas de ecosistemas de iteración rápida.

# Despliegue de Rustup y Cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

# Herramientas CLI (Starship, FNM, UV) aisladas de apt
curl -sS https://starship.rs/install.sh | sh -s -- -y
curl -LsSf https://astral.sh/uv/install.sh | sh
curl -fsSL https://raw.githubusercontent.com/MordechaiHadad/bob/master/scripts/install.sh | bash
source "$HOME/.local/bin/env"
source "$HOME/.local/bin/env.fish"
bob install stable
bob use stable

wget https://packages.microsoft.com/config/debian/13/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

sudo apt update && sudo apt install -y dotnet-sdk-10.0

sudo wget https://prism-launcher-for-debian.github.io/repo/prismlauncher.gpg -O /usr/share/keyrings/prismlauncher-archive-keyring.gpg \
 && echo "Types: deb
URIs: https://prism-launcher-for-debian.github.io/repo
Suites: $(. /etc/os-release; echo "${UBUNTU_CODENAME:-${DEBIAN_CODENAME:-${VERSION_CODENAME}}}")
Components: main
Signed-By: /usr/share/keyrings/prismlauncher-archive-keyring.gpg" | sudo tee /etc/apt/sources.list.d/prismlauncher.sources \
 && sudo apt update \
 && sudo apt install prismlauncher

echo "============================================================"
echo "[Script] Instalando binarios externos (.deb)"
echo "============================================================"
mkdir -p "$DEBS_PATH"

wget "https://dbeaver.io/files/dbeaver-ce-latest-linux-x86_64.deb" -O "$DEBS_PATH/dbeaver-ce.deb"
wget "https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/releases/download/v2.22.3/Heroic-2.22.3-linux-amd64.deb" -O "$DEBS_PATH/heroic.deb"
wget "https://github.com/ONLYOFFICE/DesktopEditors/releases/latest/download/onlyoffice-desktopeditors_amd64.deb" -O "$DEBS_PATH/onlyoffice.deb"
wget "https://files.stirlingpdf.com/linux-installer.deb" -O "$DEBS_PATH/stirlingpdf.deb"

sudo apt install "$DEBS_PATH/"*.deb -y

echo "============================================================"
echo "[Script] Instalando aplicaciones Flatpak"
echo "============================================================"
flatpak install -y flathub md.obsidian.Obsidian
flatpak install -y flathub io.missioncenter.MissionCenter

echo "============================================================"
echo "[Script] Configuración del Entorno de Usuario"
echo "============================================================"
chsh -s /usr/bin/fish

FISH_CFG_DIR="$SCRIPT_DIR/.config/fish"
rm -rf "$HOME/.config/fish"
cp -r "$FISH_CFG_DIR" "$HOME/.config/"

rm -rf "$HOME/.config/starship.toml"
STARSHIP_CFG="$SCRIPT_DIR/.config/starship.toml"
cp -r "$STARSHIP_CFG" "$HOME/.config/"

sudo npm i -g pnpm
sudo npm i -g tree-sitter-cli

# Syncthing a nivel de sesión local
sudo systemctl enable --now syncthing@$USER

echo "============================================================"
echo "[Script] Inyectando Dotfiles y Clonando TPM"
echo "============================================================"
rm -rf "$HOME/.config/nvim" "$HOME/.config/kitty" "$HOME/.config/tmux" "$HOME/.tmux.conf"
cp -r "$SCRIPT_DIR/.config/nvim" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/kitty" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/tmux" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.gitconfig" "$HOME/"
mkdir -p "$HOME/Pictures"
cp -r "$SCRIPT_DIR/wallpaper.jpeg" "$HOME/Pictures/" 2>/dev/null || true
cp -r "$SCRIPT_DIR/wallpaper2.jpeg" "$HOME/Pictures/" 2>/dev/null || true

rm -rf "$HOME/.tmux/plugins/tpm"
git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

echo "============================================================"
echo "[Script] Configurando git"
echo "============================================================"
if [ -t 0 ]; then
    read -rp "¿Deseas configurar la identidad global de Git ahora? [s/N]: " prompt_git
    git_email=""
    
    case "${prompt_git}" in
        [sS]|[sS][iI]|[yY]|[yY][eE][sS])
            git_name=""
            while [[ -z "${git_name}" ]]; do
                read -rp "Ingresa tu nombre (user.name): " git_name
            done

            while [[ -z "${git_email}" ]]; do
                read -rp "Ingresa tu correo (user.email): " git_email
            done

            git config --global user.name "${git_name}"
            git config --global user.email "${git_email}"
            echo "[OK] Identidad de Git configurada."
            ;;
        *)
            echo "[INFO] Omitiendo configuración de identidad de Git."
            ;;
    esac

    read -rp "¿Deseas generar una nueva clave SSH (Ed25519)? [s/N]: " prompt_ssh
    case "${prompt_ssh}" in
        [sS]|[sS][iI]|[yY]|[yY][eE][sS])
            SSH_FILE="$HOME/.ssh/id_ed25519"
            
            if [ -f "$SSH_FILE" ]; then
                echo "[WARN] La clave $SSH_FILE ya existe. Omitiendo para evitar pérdida de datos."
            else
                ssh_email="${git_email:-}"
                while [[ -z "${ssh_email}" ]]; do
                    read -rp "Ingresa el correo para asociar a la clave SSH: " ssh_email
                done
                
                echo "[INFO] Generando clave SSH Ed25519."
                ssh-keygen -t ed25519 -C "$ssh_email" -f "$SSH_FILE"
                
                echo -e "\n[OK] Clave pública generada. Lista para añadir a GitHub/GitLab:"
                cat "${SSH_FILE}.pub"
                echo ""
            fi
            ;;
        *)
            echo "[INFO] Omitiendo generación de clave SSH."
            ;;
    esac
else
    echo "[WARN] Ejecución no interactiva. Omitiendo prompts de Git/SSH."
fi

echo "============================================================"
echo "[Script] Configurando GNOME y D-Bus"
echo "============================================================"
# Manejo del daemon D-Bus para habilitar gsettings desde scripts
if [ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
    _USER_ID=$(id -u)
    _BUS_PATH="/run/user/${_USER_ID}/bus"

    if [ -S "$_BUS_PATH" ]; then
        export DBUS_SESSION_BUS_ADDRESS="unix:path=${_BUS_PATH}"
    else
        if command -v dbus-run-session >/dev/null 2>&1; then
            exec dbus-run-session -- "$0" "$@"
        else
            echo "[ERROR] Fallo crítico: Bus de sesión D-Bus no encontrado." >&2
            exit 1
        fi
    fi
fi

gsettings set org.gnome.shell always-show-log-out true
gsettings set org.gnome.desktop.peripherals.mouse accel-profile 'flat'
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 4
gsettings set org.gnome.mutter edge-tiling false
gsettings set org.gnome.mutter workspaces-only-on-primary false
gsettings set org.gnome.shell.app-switcher current-workspace-only true
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface accent-color 'red'

gsettings set org.gnome.desktop.background picture-uri "file://$HOME/Pictures/wallpaper2.jpeg"
gsettings set org.gnome.desktop.background picture-uri-dark "file://$HOME/Pictures/wallpaper2.jpeg"

DOTFILES_DIR="$SCRIPT_DIR/gnome-config"
declare -A KEYBINDS=(
  ["/org/gnome/desktop/wm/keybindings/"]="wm.dconf"
  ["/org/gnome/shell/keybindings/"]="shell.dconf"
  ["/org/gnome/mutter/keybindings/"]="mutter.dconf"
  ["/org/gnome/settings-daemon/plugins/media-keys/"]="media.dconf"
)

echo "[INFO] Restaurando keybinds de GNOME..."
for path in "${!KEYBINDS[@]}"; do
  file="${DOTFILES_DIR}/${KEYBINDS[$path]}"
  if [[ -f "$file" ]]; then
    dconf load "$path" < "$file"
  fi
done

CONFIG_FILE="$SCRIPT_DIR/gnome-config/app-folders.dconf"
if [ -f "$CONFIG_FILE" ]; then
    echo "[INFO] Restaurando estructura de carpetas..."
    dconf load /org/gnome/desktop/app-folders/ < "$CONFIG_FILE"
fi

echo "============================================================"
echo "[Script] Completado. Reiniciando sistema..."
echo "============================================================"
