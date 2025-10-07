#!/bin/bash
# ==============================================
# FULL MACOS SETUP SCRIPT
# Bootstrap, ZSH, Starship, Dev Environment
# ==============================================

set -e

echo "🚀 Starting full macOS setup..."
echo "==========================================================="

# --- Step 1: Bootstrap ---
if [ -f "./bootstrap.sh" ]; then
  echo "📦 Running bootstrap..."
  # source используется, чтобы окружение сразу подхватилось
  source ./bootstrap.sh
else
  echo "❌ bootstrap.sh not found!"
  exit 1
fi

# --- Step 2: ZSH environment ---
if [ -f "./setup-zsh-env.sh" ]; then
  echo "🐚 Setting up ZSH environment..."
  bash ./setup-zsh-env.sh
else
  echo "❌ setup-zsh-env.sh not found!"
  exit 1
fi

# --- Step 3: Development environment ---
if [ -f "./setup-dev-env.sh" ]; then
  echo "💻 Setting up development environment..."
  bash ./setup-dev-env.sh
else
  echo "❌ setup-dev-env.sh not found!"
  exit 1
fi

echo ""
echo "✅ Full macOS setup completed!"
echo "🔁 Please restart your terminal to ensure all environment variables are loaded."
