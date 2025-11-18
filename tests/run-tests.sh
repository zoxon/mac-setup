#!/bin/bash
# ==============================================
# MAIN TEST RUNNER
# Runs all available tests for mac-setup
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

# Test suites
TEST_SUITES=(
  "test-core-functionality.sh:Core functionality and error handling"
  "test-compatibility-config.sh:System compatibility and configuration"
  "test-package-resilience.sh:Package installation resilience (requires Homebrew)"
)

TOTAL_SUITES=${#TEST_SUITES[@]}
PASSED_SUITES=0
FAILED_SUITES=0

echo "🧪 Mac-Setup Test Runner v${MAC_SETUP_VERSION}"
echo "==========================================================="
log_info "Running $TOTAL_SUITES test suites..."
echo ""

# Make all test scripts executable
chmod +x test-*.sh 2>/dev/null || true

for suite_info in "${TEST_SUITES[@]}"; do
  IFS=':' read -r suite_script suite_description <<< "$suite_info"

  echo ""
  log_step "Running: $suite_description"
  echo "Script: $suite_script"
  echo "───────────────────────────────────────────────────────────"

  if [ -f "$suite_script" ]; then
    if ./"$suite_script"; then
      log_success "✅ PASSED: $suite_description"
      ((PASSED_SUITES++))
    else
      log_error "❌ FAILED: $suite_description"
      ((FAILED_SUITES++))
    fi
  else
    log_error "❌ NOT FOUND: $suite_script"
    ((FAILED_SUITES++))
  fi
done

echo ""
echo "==========================================================="
log_info "🏁 Test Runner Summary"
echo "───────────────────────────────────────────────────────────"
log_info "Total test suites: $TOTAL_SUITES"
log_success "Passed: $PASSED_SUITES"

if [ $FAILED_SUITES -gt 0 ]; then
  log_error "Failed: $FAILED_SUITES"
  echo ""
  log_error "❌ Some test suites failed. Please review the output above."
  echo ""
  log_info "💡 Troubleshooting tips:"
  echo "  - Ensure you have internet connectivity"
  echo "  - Run 'chmod +x *.sh' to make scripts executable"
  echo "  - Install Homebrew if package tests are failing"
  echo "  - Check system requirements with './check-compatibility.sh'"
  exit 1
else
  log_success "Failed: $FAILED_SUITES"
  echo ""
  log_success "🎉 All test suites passed successfully!"
  echo ""
  log_info "✨ Your mac-setup installation is working perfectly!"
  echo "   You can now run './install.sh' to set up your macOS environment."
  exit 0
fi
