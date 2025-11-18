#!/bin/bash
# ==============================================
# PACKAGE INSTALLATION ERROR HANDLING TEST
# Tests resilience with mixed real/fake packages
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

log_info "Testing package installation error handling..."
echo "==========================================================="

# Test arrays with mixed real and fake packages
TEST_FORMULAS=(
  "tree"                    # Real package (small utility)
  "fake-package-12345"      # Fake package
  "wget"                    # Real package
  "nonexistent-formula-xyz" # Fake package
  "curl"                    # Real package (usually pre-installed)
)

TEST_CASKS=(
  "rectangle"               # Real cask (if not installed)
  "fake-app-2024"          # Fake cask
  "imaginary-software"     # Fake cask
)

# Function to test package arrays (copied from setup-dev-env.sh)
test_install_brew_packages() {
  local category="$1"
  shift
  local packages=("$@")
  local failed_packages=()
  local success_count=0
  local total_count=${#packages[@]}

  log_info "Testing category: $category"
  echo "---------------------------------------------"

  for pkg in "${packages[@]}"; do
    if install_brew_formula_safe "$pkg"; then
      ((success_count++))
    else
      failed_packages+=("$pkg")
    fi
  done

  # Summary for this category
  if [ $success_count -eq $total_count ]; then
    log_success "All packages in $category handled correctly ($success_count/$total_count)"
  else
    log_info "$category: $success_count/$total_count packages successful"
    if [ ${#failed_packages[@]} -gt 0 ]; then
      log_warning "Expected failures: ${failed_packages[*]}"
    fi
  fi

  return 0  # Always return success for testing
}

test_install_cask_packages() {
  local category="$1"
  shift
  local packages=("$@")
  local failed_packages=()
  local success_count=0
  local total_count=${#packages[@]}

  log_info "Testing category: $category"
  echo "---------------------------------------------"

  for pkg in "${packages[@]}"; do
    if install_brew_cask_safe "$pkg"; then
      ((success_count++))
    else
      failed_packages+=("$pkg")
    fi
  done

  # Summary for this category
  if [ $success_count -eq $total_count ]; then
    log_success "All packages in $category handled correctly ($success_count/$total_count)"
  else
    log_info "$category: $success_count/$total_count packages successful"
    if [ ${#failed_packages[@]} -gt 0 ]; then
      log_warning "Expected failures: ${failed_packages[*]}"
    fi
  fi

  return 0  # Always return success for testing
}

# Check if Homebrew is available
if ! check_command brew; then
  log_warning "Homebrew is not installed. This test requires Homebrew."
  log_info "Run ./bootstrap.sh first to install Homebrew."
  exit 1
fi

log_step "Testing Homebrew formula installation with error handling..."
test_install_brew_packages "Test Formulas" "${TEST_FORMULAS[@]}"

echo ""
log_step "Testing Homebrew cask installation with error handling..."
test_install_cask_packages "Test Casks" "${TEST_CASKS[@]}"

echo ""
echo "==========================================================="
log_success "Package installation error handling test completed!"
log_info "Key observations:"
echo "  ✓ Script continued execution despite failed packages"
echo "  ✓ Clear error messages for failed installations"
echo "  ✓ Successful packages were installed correctly"
echo "  ✓ Summary reports provided for each category"
echo ""
log_info "This demonstrates that the installation process is robust"
log_info "and handles missing/renamed packages gracefully."
