# 🍎 Fresh Mac Setup

A comprehensive collection of scripts for quickly deploying a complete development environment with ZSH and Starship prompt on macOS.

[![macOS](https://img.shields.io/badge/macOS-10.15+-blue.svg)](https://www.apple.com/macos/)
[![Shell](https://img.shields.io/badge/shell-zsh-green.svg)](https://zsh.sourceforge.io/)
[![License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE.md)

## 🚀 What's Included

- **install.sh** — Main orchestrator script that runs all components
- **check-compatibility.sh** — System requirements and compatibility checker
- **bootstrap.sh** — Installs Xcode CLI, Homebrew, Powerline & Nerd Fonts
- **setup-zsh-env.sh** — Configures ZSH, Oh-My-Zsh, plugins, and Starship prompt
- **setup-dev-env.sh** — Installs development tools, applications, and QuickLook plugins
- **automator.sh** — Installs custom Automator workflows

## ⚡ Quick Start

### Prerequisites

- macOS 10.15 (Catalina) or later
- At least 5GB of free disk space
- Active internet connection

### Installation

1. **Clone the repository:**

```bash
git clone https://github.com/zoxon/mac-setup.git ~/mac-setup
cd ~/mac-setup
```

1. **Check system compatibility (recommended):**

```bash
chmod +x check-compatibility.sh
./check-compatibility.sh
```

1. **Make scripts executable:**

```bash
chmod +x *.sh
```

1. **Run the main installation:**

```bash
./install.sh
```

## Whats installed?

- Development environment: Node.js (via NVM), Git, Vim, Watchman, p7zip, tldr, etc.
- Applications (casks): VSCode, Docker, Figma, VLC, Spotify, Chrome, Slack, etc.
- ZSH environment:
  - Oh-My-Zsh
  - Plugins: zsh-autosuggestions, zsh-syntax-highlighting
  - Theme: Dracula
  - Prompt: Starship with Nerd Fonts
- Fonts:
  - Powerline Fonts
  - Nerd Fonts (MesloLGS NF)

## After installation

1. **Font Configuration**: In Terminal, select the MesloLGS NF font (or another Nerd Font) for correct icon display
1. **Restart Terminal**: Close and reopen your terminal to apply all changes
1. **Review Installation**: Check the installation summary for any failed packages

## 🧪 Testing

Comprehensive test suite to validate functionality and error handling:

```bash
# Run all tests
./test.sh

# Or run tests directly
cd tests && ./run-tests.sh
```

**Test Categories:**
- ✅ Core functionality (17 tests)
- ✅ System compatibility checks
- ✅ Package installation resilience
- ✅ Configuration handling

See [tests/README.md](tests/README.md) for detailed testing documentation.
