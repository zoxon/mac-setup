# macOS Setup Configuration Examples

This directory contains configuration files that will be applied during setup.

## Files Overview

### `zshrc.dotfile`
- ZSH configuration file that will be copied to `~/.zshrc`
- Includes Oh-My-Zsh setup, plugins configuration, and aliases
- Pre-configured with useful development aliases and NVM setup

### `starship.toml`
- Starship prompt configuration
- Will be copied to `~/.config/starship.toml`
- Includes custom prompt layout with Git status, Node.js version, and more

## Customization

You can modify these files before running the setup to customize:

1. **ZSH Aliases**: Add your preferred aliases to `zshrc.dotfile`
2. **Starship Prompt**: Modify colors, symbols, and layout in `starship.toml`
3. **Oh-My-Zsh Plugins**: Update the plugins array in `zshrc.dotfile`

## Backup

The setup scripts will automatically backup existing configuration files by renaming them with a `.backup` suffix before applying new configurations.

## Manual Application

If you want to apply configurations manually:

```bash
# Apply ZSH configuration
cp configs/zshrc.dotfile ~/.zshrc

# Apply Starship configuration  
mkdir -p ~/.config
cp configs/starship.toml ~/.config/starship.toml

# Reload shell
source ~/.zshrc
```