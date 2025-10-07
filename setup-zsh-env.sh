#!/bin/bash
# ==============================================
# ZSH ENVIRONMENT SETUP
# Powerline fonts,  Oh-My-Zsh, plugins, theme, .zshrc
# ==============================================

set -e

echo "🐚 Setup ZSH Environment"
echo "==========================================================="

# Installing Oh-My-Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "💀 Installing Oh-My-Zsh..."
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "✅ Oh-My-Zsh is already installed."
fi

# Copy .zshrc
echo "📝 Configuring .zshrc..."
cp -f ./configs/zshrc.dotfile ~/.zshrc

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# Plugins
echo "🔌 Installing plugins..."
brew install --quiet zsh-autosuggestions zsh-syntax-highlighting

# Dracula theme
if [ ! -d "$ZSH_CUSTOM/themes/dracula" ]; then
  echo "🧛 Installing Dracula theme..."
  git clone --depth=1 https://github.com/dracula/zsh.git "$ZSH_CUSTOM/themes/dracula"
fi

echo "🚀 Installing Starship..."
brew install --quiet starship
if ! grep -q 'starship init zsh' ~/.zshrc; then
  echo 'eval "$(starship init zsh)"' >> ~/.zshrc
fi

echo "🚀 Setting up Starship prompt..."
# Check if ~/.config exists
if [ ! -d "$HOME/.config" ]; then
  echo "📂 Creating ~/.config directory..."
  mkdir -p "$HOME/.config"
else
  echo "✅ ~/.config directory already exists."
fi

# Copy Starship config from repo
cp -f ./configs/starship.toml ~/.config/starship.toml
echo "✅ Starship configuration applied!"

# Ensure Starship is initialized in .zshrc
if ! grep -q 'starship init zsh' ~/.zshrc; then
  echo 'eval "$(starship init zsh)"' >> ~/.zshrc
  echo "✅ Added Starship init to .zshrc"
else
  echo "✅ Starship init already present in .zshrc"
fi

echo "🔍 Installing FZF..."
brew install fzf
"$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish

# Set ZSH the default shell
echo "⚙️ Changing default shell to ZSH..."
if ! grep -q "$(which zsh)" /etc/shells; then
  echo "$(which zsh)" | sudo tee -a /etc/shells >/dev/null
fi
chsh -s "$(which zsh)"

echo "🔁 Applying settings..."
if source ~/.zshrc 2>/dev/null; then
  echo "✅ ZSH configuration reloaded."
else
  echo "⚠️ Could not source .zshrc automatically. Please restart your terminal."
fi

echo ""
echo "✅ ZSH is fully configured!"
