#!/bin/bash
# ==============================================
# BOOTSTRAP SCRIPT
# Installs Xcode CLI, Homebrew, Powerline & Nerd Fonts
# ==============================================

set -e

echo "🚀 Running bootstrap for macOS..."
echo "==========================================================="

# --- Check OS ---
if [[ "$OSTYPE" != "darwin"* ]]; then
  echo "❌ This script is only for macOS."
  exit 1
fi

# --- Xcode Command Line Tools ---
echo "🛠 Installing Xcode Command Line Tools..."
if ! xcode-select -p &>/dev/null; then
  xcode-select --install || true
  echo "⚠️ Waiting for Xcode CLI installation..."
  until xcode-select -p &>/dev/null; do
    sleep 10
  done
  echo "✅ Xcode CLI installed."
else
  echo "✅ Xcode CLI already installed."
fi

# --- Homebrew ---
if ! command -v brew &>/dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "✅ Homebrew already installed."
fi

echo "🔄 Updating Homebrew..."
brew update --quiet && brew upgrade --quiet && brew cleanup

# --- Fonts (Powerline + Nerd) ---
FONTS_DIR="$HOME/Library/Fonts"

# Powerline
POWERLINE_FONT="Meslo LG S DZ Regular for Powerline.ttf"
if [ ! -f "$FONTS_DIR/$POWERLINE_FONT" ]; then
  echo "⬇️ Installing Powerline Fonts..."
  git clone --depth=1 https://github.com/powerline/fonts.git /tmp/powerline-fonts
  cd /tmp/powerline-fonts && ./install.sh && cd -
  rm -rf /tmp/powerline-fonts
  echo "✅ Powerline Fonts installed."
else
  echo "✅ Powerline Fonts already installed."
fi

# Nerd Fonts (MesloLGS NF)
NERD_FONT_PATTERN="MesloLGS NF"
if ! ls "$FONTS_DIR" | grep -q "$NERD_FONT_PATTERN"; then
  echo "⬇️ Installing Nerd Font (MesloLGS NF)..."
  FONT_TMP="/tmp/MesloLGS-NF.zip"
  curl -Lo "$FONT_TMP" "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Meslo.zip"
  unzip -o "$FONT_TMP" -d "$FONTS_DIR"
  rm "$FONT_TMP"
  echo "✅ Nerd Font installed."
else
  echo "✅ Nerd Font already installed."
fi

echo ""
echo "✅ Bootstrap completed!"
