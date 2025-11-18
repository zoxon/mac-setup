#!/bin/bash
# ==============================================
# COMPATIBILITY CHECKER
# Checks macOS version and system requirements
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

log_info "Checking system compatibility for mac-setup v${MAC_SETUP_VERSION}..."
echo "==========================================================="

# Check macOS version
MACOS_VERSION=$(sw_vers -productVersion)
MACOS_MAJOR=$(echo "$MACOS_VERSION" | cut -d. -f1)
MACOS_MINOR=$(echo "$MACOS_VERSION" | cut -d. -f2)

log_info "macOS Version: $MACOS_VERSION"

# Check if macOS version is supported (10.15+ recommended for modern Homebrew)
if [ "$MACOS_MAJOR" -lt 10 ] || ([ "$MACOS_MAJOR" -eq 10 ] && [ "$MACOS_MINOR" -lt 15 ]); then
  log_warning "macOS $MACOS_VERSION may not be fully supported"
  log_info "Recommended: macOS 10.15 (Catalina) or later"
else
  log_success "macOS version is compatible"
fi

# Check architecture
ARCH=$(uname -m)
log_info "Architecture: $ARCH"

if [ "$ARCH" = "arm64" ]; then
  log_success "Apple Silicon (M1/M2/M3) detected - using ${HOMEBREW_PREFIX}"
elif [ "$ARCH" = "x86_64" ]; then
  log_success "Intel Mac detected - using /usr/local"
else
  log_warning "Unknown architecture: $ARCH"
fi

# Check available disk space (need at least 5GB for full installation)
AVAILABLE_SPACE=$(df -h / | awk 'NR==2 {print $4}' | sed 's/G.*//')
if [ "$AVAILABLE_SPACE" -lt 5 ]; then
  log_warning "Low disk space. Available: ${AVAILABLE_SPACE}GB"
  log_info "Recommended: At least 5GB free space"
else
  log_success "Sufficient disk space available: ${AVAILABLE_SPACE}GB"
fi

# Check internet connection
log_step "Testing internet connectivity..."
if check_internet; then
  log_success "Internet connection OK"
else
  log_error "No internet connection detected"
  log_info "Internet access is required for downloading packages"
  exit 1
fi

echo ""
log_success "System compatibility check completed!"
log_info "You can proceed with the installation"
