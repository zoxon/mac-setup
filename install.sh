#!/bin/bash
# ==============================================
# FULL MACOS SETUP SCRIPT
# Bootstrap, ZSH, Starship, Dev Environment
# ==============================================

set -e

# Load configuration and utility functions
if [ -f "./config.sh" ]; then
  source ./config.sh
else
  echo "❌ config.sh not found! Please run from the project directory."
  exit 1
fi

log_info "Starting full macOS setup v${MAC_SETUP_VERSION}..."
echo "==========================================================="

# Check system compatibility first
if check_file "./check-compatibility.sh"; then
  log_step "Running system compatibility check..."
  bash ./check-compatibility.sh
else
  log_warning "Compatibility check script not found, proceeding anyway..."
fi

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
