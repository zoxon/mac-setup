#!/bin/bash

# ==============================================
# FRONTEND DEV ENV INSTALLER FOR macOS
# Includes: Homebrew, NVM, utils, casks, quicklook plugins
# ==============================================

set -e

echo "🚀 Installing frontend development environment..."
echo "==========================================================="

# Check OS
if [[ "$OSTYPE" != "darwin"* ]]; then
  echo "❌ This script is only for macOS."
  exit 1
fi

# Installing NVM
if ! command -v nvm &>/dev/null; then
  echo "🟢 Installing NVM (Node Version Manager)..."
  brew install nvm
  mkdir -p ~/.nvm
else
  echo "✅ NVM is already installed."
fi

#  Groups of packages to install
UTILS=(
  coreutils
  binutils
  tree
  git
  git-flow-avh
  wget
  vim
  ctags
  watchman
  p7zip
  trash
  yt-dlp
  tldr
  ncdu
)

QUICKLOOK_PLUGINS=(
  qlstephen
  qlvideo
  quicklook-csv
  quicklook-json
  quicklookase
  webpquicklook
  qlcolorcode
  qlprettypatch
  qlmarkdown
  syntax-highlight
  suspicious-package
  qlimagesize
  quicklook-pat
  epubquicklook
)

CASKS_UTILS=(
  michaelvillar-timer
  cheatsheet
  ilya-birman-typography-layout
  cakebrew
  spectacle
  itsycal
  android-file-transfer
  appcleaner
  lulu
  the-unarchiver
  betterzip
  mist
  onlyoffice
  onyx
  paparazzi
)

CASKS_DEV=(
  visual-studio-code
  docker
  docker-desktop
  figma
  imageoptim
  zed
)

CASKS_MEDIA=(
  vlc
  vox
  iina
  spotify
)

CASKS_INTERNET=(
  firefox
  google-chrome
  qbittorrent
  tunnelbear
)

CASKS_MESSENGERS=(
  slack
  telegram
)

CASKS_OTHER=(
  steam
  yandex-disk
)

CASKS_SCREENSAVER=(
  aerial
  padbury-clock
)

# Functions to install packages
install_brew_packages() {
  local category="$1"
  shift
  local packages=("$@")

  echo ""
  echo "📦 Installing: $category"
  echo "-----------------------------------------"
  for pkg in "${packages[@]}"; do
    if brew list --formula | grep -q "^${pkg}\$"; then
      echo "✅ $pkg is already installed."
    else
      echo "⬇️  Installing $pkg..."
      brew install "$pkg"
    fi
  done
}

install_cask_packages() {
  local category="$1"
  shift
  local packages=("$@")

  echo ""
  echo "🧩 Installing: $category"
  echo "---------------------------------------------"
  for pkg in "${packages[@]}"; do
    if brew list --cask | grep -q "^${pkg}\$"; then
      echo "✅ $pkg is already installed."
    else
      echo "⬇️  Installing $pkg..."
      brew install --cask "$pkg"
    fi
  done
}

# Installing packages
install_brew_packages "UTILS" "${UTILS[@]}"
install_cask_packages "QuickLook Plugins" "${QUICKLOOK_PLUGINS[@]}"
install_cask_packages "Utilities" "${CASKS_UTILS[@]}"
install_cask_packages "Development Tools" "${CASKS_DEV[@]}"
install_cask_packages "Media" "${CASKS_MEDIA[@]}"
install_cask_packages "Internet" "${CASKS_INTERNET[@]}"
install_cask_packages "Messengers" "${CASKS_MESSENGERS[@]}"
install_cask_packages "Other" "${CASKS_OTHER[@]}"
install_cask_packages "Screensavers" "${CASKS_SCREENSAVER[@]}"

echo -e "\n✅ All done!"
