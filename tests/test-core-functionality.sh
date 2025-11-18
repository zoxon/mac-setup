#!/bin/bash
# ==============================================
# TEST SUITE FOR MAC-SETUP
# Tests core functionality and error handling
# ==============================================

# Note: not using "set -e" to allow tests to continue after failures

# Load configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
if [ -f "$PROJECT_DIR/config.sh" ]; then
  source "$PROJECT_DIR/config.sh"
else
  echo "❌ config.sh not found! Please run from the mac-setup directory."
  exit 1
fi

# Test counter
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test function
run_test() {
  local test_name="$1"
  local test_command="$2"

  ((TESTS_RUN++))
  echo "🔹 Running test: $test_name"

  if eval "$test_command" >/dev/null 2>&1; then
    echo "✅ PASS: $test_name"
    ((TESTS_PASSED++))
  else
    echo "❌ FAIL: $test_name"
    ((TESTS_FAILED++))
  fi
}

echo "🧪 Starting mac-setup test suite..."
echo "==========================================================="

# Test 1: Configuration file loading
run_test "Config file loading" "[ -n \"$MAC_SETUP_VERSION\" ]"

# Test 2: Logging functions
run_test "Logging functions" "type log_info && type log_success && type log_warning && type log_error"

# Test 3: Utility functions
run_test "check_command function" "check_command bash"
run_test "check_file function" "check_file \"$PROJECT_DIR/config.sh\""
run_test "check_directory function" "check_directory \"$PROJECT_DIR\""

# Test 4: Internet connectivity
run_test "Internet connectivity" "check_internet"

# Test 5: Homebrew detection
if check_command brew; then
  run_test "Homebrew detection" "check_command brew"
else
  echo "⚠️  SKIP: Homebrew not installed (expected on fresh systems)"
fi

# Test 6: Safe package installation functions
run_test "Brew formula function exists" "type install_brew_formula_safe"
run_test "Brew cask function exists" "type install_brew_cask_safe"

# Test 7: Script files exist and are executable
SCRIPTS=("bootstrap.sh" "setup-zsh-env.sh" "setup-dev-env.sh" "check-compatibility.sh" "automator.sh" "install.sh")

for script in "${SCRIPTS[@]}"; do
  run_test "Script $script is executable" "[ -x \"$PROJECT_DIR/$script\" ]"
done

# Test 8: Configuration files exist
CONFIG_FILES=("configs/zshrc.dotfile" "configs/starship.toml")

for config in "${CONFIG_FILES[@]}"; do
  run_test "Config file $config exists" "[ -f \"$PROJECT_DIR/$config\" ]"
done

echo ""
echo "==========================================================="
log_info "Test Results:"
log_success "Tests passed: $TESTS_PASSED"
if [ $TESTS_FAILED -gt 0 ]; then
  log_error "Tests failed: $TESTS_FAILED"
else
  log_success "Tests failed: $TESTS_FAILED"
fi
log_info "Total tests: $TESTS_RUN"

if [ $TESTS_FAILED -eq 0 ]; then
  echo ""
  log_success "🎉 All tests passed! The mac-setup system is working correctly."
  exit 0
else
  echo ""
  log_error "❌ Some tests failed. Please check the output above."
  exit 1
fi
