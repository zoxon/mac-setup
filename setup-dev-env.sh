#!/bin/bash

# ==============================================
# FRONTEND DEV ENV INSTALLER FOR macOS
# Includes: Homebrew, NVM, utils, casks, quicklook plugins
# ==============================================

set -e

# Load configuration and utility functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/config.sh" ]; then
  source "$SCRIPT_DIR/config.sh"
else
  echo "❌ config.sh not found! Please run from the project directory."
  exit 1
fi

log_info "Installing frontend development environment..."
echo "==========================================================="

# Check OS
if [[ "$OSTYPE" != "darwin"* ]]; then
  echo "❌ This script is only for macOS."
  exit 1
fi

# Installing NVM
if ! command -v nvm &>/dev/null && [ ! -s "$HOME/.nvm/nvm.sh" ]; then
  log_step "Installing NVM (Node Version Manager)..."
  if brew install nvm 2>/dev/null; then
    mkdir -p ~/.nvm 2>/dev/null || true
    log_success "NVM installed successfully via Homebrew"
  else
    log_warning "Failed to install NVM via Homebrew, trying alternative method..."
    # Fallback to curl installation
    if curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash 2>/dev/null; then
      log_success "NVM installed via curl method"
    else
      log_error "Failed to install NVM. You may need to install it manually."
      log_info "Visit: https://github.com/nvm-sh/nvm for manual installation instructions"
    fi
  fi
else
  log_success "NVM is already installed"
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

# Functions to install packages with improved error handling
install_brew_packages() {
  local category="$1"
  shift
  local packages=("$@")
  local failed_packages=()
  local success_count=0
  local total_count=${#packages[@]}

  echo ""
  log_info "Installing: $category"
  echo "-----------------------------------------"

  for pkg in "${packages[@]}"; do
    if install_brew_formula_safe "$pkg"; then
      ((success_count++))
    else
      failed_packages+=("$pkg")
    fi
  done

  # Summary for this category
  if [ $success_count -eq $total_count ]; then
    log_success "All packages in $category installed successfully ($success_count/$total_count)"
  else
    log_warning "$category: $success_count/$total_count packages successful"
    if [ ${#failed_packages[@]} -gt 0 ]; then
      log_error "Failed packages: ${failed_packages[*]}"
    fi
  fi
}

install_cask_packages() {
  local category="$1"
  shift
  local packages=("$@")
  local failed_packages=()
  local success_count=0
  local total_count=${#packages[@]}

  echo ""
  log_info "Installing: $category"
  echo "---------------------------------------------"

  for pkg in "${packages[@]}"; do
    if install_brew_cask_safe "$pkg"; then
      ((success_count++))
    else
      failed_packages+=("$pkg")
    fi
  done

  # Summary for this category
  if [ $success_count -eq $total_count ]; then
    log_success "All packages in $category installed successfully ($success_count/$total_count)"
  else
    log_warning "$category: $success_count/$total_count packages successful"
    if [ ${#failed_packages[@]} -gt 0 ]; then
      log_error "Failed packages: ${failed_packages[*]}"
    fi
  fi
}# Installing packages
echo "🚀 Starting package installation process..."
echo "==========================================================="

install_brew_packages "UTILS" "${UTILS[@]}"
install_cask_packages "QuickLook Plugins" "${QUICKLOOK_PLUGINS[@]}"
install_cask_packages "Utilities" "${CASKS_UTILS[@]}"
install_cask_packages "Development Tools" "${CASKS_DEV[@]}"
install_cask_packages "Media" "${CASKS_MEDIA[@]}"
install_cask_packages "Internet" "${CASKS_INTERNET[@]}"
install_cask_packages "Messengers" "${CASKS_MESSENGERS[@]}"
install_cask_packages "Other" "${CASKS_OTHER[@]}"
install_cask_packages "Screensavers" "${CASKS_SCREENSAVER[@]}"

echo ""
echo "==========================================================="
log_success "Development environment setup completed!"
echo ""
log_info "Note: Some packages might have failed to install if they are:"
echo "   - No longer available in Homebrew"
echo "   - Renamed or moved to different taps"
echo "   - Require additional system permissions"
echo "   - Already installed via different methods"
echo ""
log_info "You can manually install failed packages later using:"
echo "   brew install <package-name>"
echo "   brew install --cask <cask-name>"
echo ""
log_info "To search for alternative package names:"
echo "   brew search <partial-name>"
echo "   brew search --cask <partial-name>"
