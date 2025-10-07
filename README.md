# Fresh Mac Setup

A collection of scripts for quickly deploying a frontend environment and ZSH with Starship on macOS.


## 🚀 Contains

- **install.sh** — main script that runs all the others:
- `bootstrap.sh` — installs Xcode CLI, Homebrew, Powerline & Nerd Fonts
- `setup-zsh-env.sh` — configures ZSH, Oh-My-Zsh, plugins, Starship
- `setup-dev-env.sh` — installs utilities, casks, quicklook plugins

## ⚡ Quick Start


1. Clone the repo:

```bash
git clone <repo-url> ~/dev-setup
cd ~/dev-setup
```

2. Make the main script executable:

```bash
chmod +x *.sh
```

3. Run the main script:

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

In Terminal, select the MesloLGS NF font (or another Nerd Font) for correct icon display.
Restart the terminal to apply changes.
