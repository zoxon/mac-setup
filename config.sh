#!/bin/bash
# ==============================================
# ENVIRONMENT CONFIGURATION
# Global variables and settings for mac-setup
# ==============================================

# Version information
export MAC_SETUP_VERSION="2.0.0"

# Paths configuration
export HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix 2>/dev/null || echo "/opt/homebrew")}"
export FONTS_DIR="$HOME/Library/Fonts"
export ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Network settings
export CURL_TIMEOUT="30"
export GIT_CLONE_TIMEOUT="60"

# Font versions (update these as needed)
export NERD_FONTS_VERSION="v3.1.1"
export POWERLINE_FONTS_REPO="https://github.com/powerline/fonts.git"

# Color codes for output
export COLOR_RED='\033[0;31m'
export COLOR_GREEN='\033[0;32m'
export COLOR_YELLOW='\033[0;33m'
export COLOR_BLUE='\033[0;34m'
export COLOR_PURPLE='\033[0;35m'
export COLOR_CYAN='\033[0;36m'
export COLOR_NC='\033[0m' # No Color

# Logging functions
log_info() {
  echo -e "${COLOR_BLUE}ℹ️  $1${COLOR_NC}"
}

log_success() {
  echo -e "${COLOR_GREEN}✅ $1${COLOR_NC}"
}

log_warning() {
  echo -e "${COLOR_YELLOW}⚠️  $1${COLOR_NC}"
}

log_error() {
  echo -e "${COLOR_RED}❌ $1${COLOR_NC}"
}

log_step() {
  echo -e "${COLOR_PURPLE}🔹 $1${COLOR_NC}"
}

# Utility functions
check_command() {
  command -v "$1" >/dev/null 2>&1
}

check_file() {
  [ -f "$1" ]
}

check_directory() {
  [ -d "$1" ]
}

# Network check
check_internet() {
  curl -s --max-time "$CURL_TIMEOUT" https://github.com >/dev/null 2>&1
}

# Package installation helpers
install_brew_formula_safe() {
  local package="$1"
  if brew list --formula | grep -q "^${package}\$" 2>/dev/null; then
    log_success "$package is already installed"
    return 0
  else
    log_step "Installing $package..."
    if brew install "$package" 2>/dev/null; then
      log_success "$package installed successfully"
      return 0
    else
      log_error "Failed to install $package"
      return 1
    fi
  fi
}

install_brew_cask_safe() {
  local package="$1"
  if brew list --cask | grep -q "^${package}\$" 2>/dev/null; then
    log_success "$package is already installed"
    return 0
  else
    log_step "Installing $package..."
    if brew install --cask "$package" 2>/dev/null; then
      log_success "$package installed successfully"
      return 0
    else
      log_error "Failed to install $package"
      return 1
    fi
  fi
}
