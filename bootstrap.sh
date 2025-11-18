#!/bin/bash
# ==============================================
# BOOTSTRAP SCRIPT
# Installs Xcode CLI, Homebrew, Powerline & Nerd Fonts
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

log_info "Running bootstrap for macOS v${MAC_SETUP_VERSION}..."
echo "==========================================================="

# --- Check OS ---
if [[ "$OSTYPE" != "darwin"* ]]; then
  log_error "This script is only for macOS"
  exit 1
fi

# --- Xcode Command Line Tools ---
log_step "Installing Xcode Command Line Tools..."
if ! xcode-select -p &>/dev/null; then
  xcode-select --install || true
  log_warning "Waiting for Xcode CLI installation..."
  until xcode-select -p &>/dev/null; do
    sleep 10
  done
  log_success "Xcode CLI installed"
else
  log_success "Xcode CLI already installed"
fi

# --- Homebrew ---
if ! check_command brew; then
  log_step "Installing Homebrew..."
  # Verify script integrity before execution
  HOMEBREW_SCRIPT="/tmp/homebrew_install.sh"
  if curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o "$HOMEBREW_SCRIPT" 2>/dev/null; then
    # Basic verification that it's the correct script
    if grep -q "Homebrew" "$HOMEBREW_SCRIPT"; then
      if /bin/bash "$HOMEBREW_SCRIPT"; then
        rm "$HOMEBREW_SCRIPT"
        log_success "Homebrew installed successfully"
      else
        log_error "Failed to install Homebrew"
        exit 1
      fi
    else
      log_error "Downloaded script doesn't appear to be legitimate Homebrew installer"
      rm "$HOMEBREW_SCRIPT"
      exit 1
    fi
  else
    log_error "Failed to download Homebrew installer"
    exit 1
  fi

  # Add to shell profile if not already present
  if ! grep -q "${HOMEBREW_PREFIX}/bin/brew" ~/.zprofile 2>/dev/null; then
    echo "eval \"\$(${HOMEBREW_PREFIX}/bin/brew shellenv)\"" >> ~/.zprofile
    log_info "Added Homebrew to shell profile"
  fi
  eval "$(${HOMEBREW_PREFIX}/bin/brew shellenv)"
else
  log_success "Homebrew already installed"
fi

log_step "Updating Homebrew..."
if brew update --quiet && brew upgrade --quiet && brew cleanup --quiet; then
  log_success "Homebrew updated successfully"
else
  log_warning "Some Homebrew updates may have failed"
fi

# --- Fonts (Powerline + Nerd) ---
FONTS_DIR="$HOME/Library/Fonts"

# Powerline
POWERLINE_FONT="Meslo LG S DZ Regular for Powerline.ttf"
if [ ! -f "${FONTS_DIR}/$POWERLINE_FONT" ]; then
  log_step "Installing Powerline Fonts..."
  if git clone --depth=1 "${POWERLINE_FONTS_REPO}" /tmp/powerline-fonts 2>/dev/null; then
    if (cd /tmp/powerline-fonts && ./install.sh); then
      rm -rf /tmp/powerline-fonts
      log_success "Powerline Fonts installed"
    else
      log_error "Failed to install Powerline Fonts"
      rm -rf /tmp/powerline-fonts
    fi
  else
    log_error "Failed to download Powerline Fonts repository"
  fi
else
  log_success "Powerline Fonts already installed"
fi

# Nerd Fonts (MesloLGS NF)
NERD_FONT_PATTERN="MesloLGS NF"
if ! ls "${FONTS_DIR}" | grep -q "$NERD_FONT_PATTERN" 2>/dev/null; then
  log_step "Installing Nerd Font (MesloLGS NF)..."
  FONT_TMP="/tmp/MesloLGS-NF.zip"
  NERD_FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONTS_VERSION}/Meslo.zip"

  if curl --max-time "${CURL_TIMEOUT}" -Lo "$FONT_TMP" "$NERD_FONT_URL" 2>/dev/null; then
    if unzip -o "$FONT_TMP" -d "${FONTS_DIR}" >/dev/null 2>&1; then
      rm "$FONT_TMP"
      log_success "Nerd Font installed"
    else
      log_error "Failed to extract Nerd Font"
      rm -f "$FONT_TMP"
    fi
  else
    log_error "Failed to download Nerd Font from GitHub"
  fi
else
  log_success "Nerd Font already installed"
fi

echo ""
log_success "Bootstrap completed!"
