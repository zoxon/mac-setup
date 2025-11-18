#!/bin/bash
# ==============================================
# ZSH ENVIRONMENT SETUP
# Powerline fonts,  Oh-My-Zsh, plugins, theme, .zshrc
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

log_info "Setup ZSH Environment v${MAC_SETUP_VERSION}"
echo "==========================================================="

# Installing Oh-My-Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  log_step "Installing Oh-My-Zsh..."
  if RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 2>/dev/null; then
    log_success "Oh-My-Zsh installed successfully"
  else
    log_error "Failed to install Oh-My-Zsh"
    exit 1
  fi
else
  log_success "Oh-My-Zsh is already installed"
fi

# Copy .zshrc
log_step "Configuring .zshrc..."
if [ -f "./configs/zshrc.dotfile" ]; then
  # Backup existing .zshrc if it exists
  if [ -f "$HOME/.zshrc" ]; then
    cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
    log_info "Backed up existing .zshrc"
  fi
  cp -f "./configs/zshrc.dotfile" "$HOME/.zshrc"
  log_success ".zshrc configured successfully"
else
  log_error "zshrc.dotfile not found in configs directory"
  exit 1
fi

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# Plugins
log_step "Installing ZSH plugins..."

# Install via Homebrew first (system-wide)
if brew install --quiet zsh-autosuggestions zsh-syntax-highlighting 2>/dev/null; then
  log_success "ZSH plugins installed via Homebrew"
else
  log_warning "Failed to install some plugins via Homebrew, installing manually"
fi

# Install plugins to Oh-My-Zsh custom directory as well
ZSH_PLUGINS_DIR="${ZSH_CUSTOM}/plugins"

# Install zsh-autosuggestions plugin
if [ ! -d "$ZSH_PLUGINS_DIR/zsh-autosuggestions" ]; then
  log_step "Installing zsh-autosuggestions plugin..."
  if git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGINS_DIR/zsh-autosuggestions" 2>/dev/null; then
    log_success "zsh-autosuggestions plugin installed"
  else
    log_error "Failed to install zsh-autosuggestions plugin"
  fi
else
  log_success "zsh-autosuggestions plugin already installed"
fi

# Install zsh-syntax-highlighting plugin
if [ ! -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]; then
  log_step "Installing zsh-syntax-highlighting plugin..."
  if git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" 2>/dev/null; then
    log_success "zsh-syntax-highlighting plugin installed"
  else
    log_error "Failed to install zsh-syntax-highlighting plugin"
  fi
else
  log_success "zsh-syntax-highlighting plugin already installed"
fi

# Dracula theme
if [ ! -d "${ZSH_CUSTOM}/themes/dracula" ]; then
  log_step "Installing Dracula theme..."
  if git clone --depth=1 https://github.com/dracula/zsh.git "${ZSH_CUSTOM}/themes/dracula" 2>/dev/null; then
    log_success "Dracula theme installed"
  else
    log_error "Failed to install Dracula theme"
  fi
else
  log_success "Dracula theme already installed"
fi

# Install Starship
log_step "Installing Starship prompt..."
if install_brew_formula_safe starship; then
  # Ensure Starship is initialized in .zshrc
  if ! grep -q 'starship init zsh' ~/.zshrc 2>/dev/null; then
    echo 'eval "$(starship init zsh)"' >> ~/.zshrc
    log_info "Added Starship init to .zshrc"
  fi
else
  log_warning "Failed to install Starship via Homebrew"
fi

log_step "Setting up Starship prompt configuration..."
# Check if ~/.config exists
if [ ! -d "$HOME/.config" ]; then
  log_info "Creating ~/.config directory..."
  mkdir -p "$HOME/.config"
fi

# Copy Starship config from repo
if [ -f "./configs/starship.toml" ]; then
  # Backup existing config if it exists
  if [ -f "$HOME/.config/starship.toml" ]; then
    cp "$HOME/.config/starship.toml" "$HOME/.config/starship.toml.backup.$(date +%Y%m%d_%H%M%S)"
    log_info "Backed up existing Starship config"
  fi
  cp -f "./configs/starship.toml" "$HOME/.config/starship.toml"
  log_success "Starship configuration applied"
else
  log_error "starship.toml not found in configs directory"
fi

# Install FZF
log_step "Installing FZF (fuzzy finder)..."
if install_brew_formula_safe fzf; then
  FZF_INSTALL_SCRIPT="${HOMEBREW_PREFIX}/opt/fzf/install"
  if [ -f "$FZF_INSTALL_SCRIPT" ]; then
    "$FZF_INSTALL_SCRIPT" --key-bindings --completion --no-update-rc --no-bash --no-fish 2>/dev/null
    log_success "FZF configured with key bindings"
  else
    log_warning "FZF install script not found"
  fi
else
  log_warning "Failed to install FZF"
fi

# Set ZSH as the default shell
log_step "Changing default shell to ZSH..."
ZSH_PATH="$(which zsh)"
if ! grep -q "$ZSH_PATH" /etc/shells 2>/dev/null; then
  if echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null; then
    log_info "Added ZSH to /etc/shells"
  else
    log_warning "Failed to add ZSH to /etc/shells"
  fi
fi

if chsh -s "$ZSH_PATH" 2>/dev/null; then
  log_success "Default shell changed to ZSH"
else
  log_warning "Failed to change default shell (you may need to run 'chsh -s $ZSH_PATH' manually)"
fi

log_step "Applying settings..."
if source ~/.zshrc 2>/dev/null; then
  log_success "ZSH configuration reloaded"
else
  log_warning "Could not source .zshrc automatically. Please restart your terminal"
fi

echo ""
log_success "ZSH environment setup completed!"
