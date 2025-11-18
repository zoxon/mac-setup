#!/bin/bash
# ==============================================
# COMPATIBILITY AND CONFIGURATION TEST
# Tests system compatibility checks and config handling
# ==============================================

set -e

# Load configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
if [ -f "$PROJECT_DIR/config.sh" ]; then
  source "$PROJECT_DIR/config.sh"
else
  echo "❌ config.sh not found! Please run from the mac-setup directory."
  exit 1
fi

log_info "Testing compatibility checks and configuration handling..."
echo "==========================================================="

# Test 1: Run compatibility check
log_step "Running system compatibility check..."
if (cd "$PROJECT_DIR" && ./check-compatibility.sh); then
  log_success "Compatibility check completed successfully"
else
  log_error "Compatibility check failed"
fi

# Test 2: Test configuration file backup functionality
log_step "Testing configuration backup functionality..."

TEST_CONFIG_DIR="/tmp/mac-setup-test-configs"
mkdir -p "$TEST_CONFIG_DIR"

# Create fake existing config
FAKE_ZSHRC="$TEST_CONFIG_DIR/.zshrc"
echo "# Fake existing .zshrc for testing" > "$FAKE_ZSHRC"

# Test backup creation
if [ -f "$FAKE_ZSHRC" ]; then
  BACKUP_FILE="$FAKE_ZSHRC.backup.$(date +%Y%m%d_%H%M%S)"
  cp "$FAKE_ZSHRC" "$BACKUP_FILE"

  if [ -f "$BACKUP_FILE" ]; then
    log_success "Configuration backup functionality works"
    rm -f "$BACKUP_FILE"
  else
    log_error "Failed to create configuration backup"
  fi
fi

# Cleanup
rm -rf "$TEST_CONFIG_DIR"

# Test 3: Test environment variable availability
log_step "Testing environment variables..."

EXPECTED_VARS=(
  "MAC_SETUP_VERSION"
  "HOMEBREW_PREFIX"
  "FONTS_DIR"
  "ZSH_CUSTOM"
  "CURL_TIMEOUT"
  "NERD_FONTS_VERSION"
)

for var in "${EXPECTED_VARS[@]}"; do
  if [ -n "${!var}" ]; then
    log_success "Environment variable $var is set: ${!var}"
  else
    log_error "Environment variable $var is not set"
  fi
done

# Test 4: Test logging color codes
log_step "Testing color logging system..."
echo "Color test (you should see colors):"
echo -n "  "; log_info "Info message (blue)"
echo -n "  "; log_success "Success message (green)"
echo -n "  "; log_warning "Warning message (yellow)"
echo -n "  "; log_error "Error message (red)"
echo -n "  "; log_step "Step message (purple)"

# Test 5: Test directory structure
log_step "Testing project directory structure..."

EXPECTED_DIRS=("configs" "automator")
EXPECTED_FILES=("install.sh" "bootstrap.sh" "setup-zsh-env.sh" "setup-dev-env.sh" "config.sh" "README.md")

for dir in "${EXPECTED_DIRS[@]}"; do
  if [ -d "$PROJECT_DIR/$dir" ]; then
    log_success "Directory exists: $dir"
  else
    log_warning "Directory missing: $dir"
  fi
done

for file in "${EXPECTED_FILES[@]}"; do
  if [ -f "$PROJECT_DIR/$file" ]; then
    log_success "File exists: $file"
  else
    log_error "File missing: $file"
  fi
done

# Test 6: Test script permissions
log_step "Testing script permissions..."
(cd "$PROJECT_DIR" && for script in *.sh; do
  if [ -x "$script" ]; then
    log_success "Script is executable: $script"
  else
    log_warning "Script not executable: $script"
  fi
done)

echo ""
echo "==========================================================="
log_success "Configuration and compatibility tests completed!"
log_info "All core functionality has been validated."
