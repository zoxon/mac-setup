#!/bin/bash
# ==============================================
# TEST LAUNCHER
# Convenient wrapper to run tests from project root
# ==============================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🧪 Mac-Setup Test Launcher"
echo "==========================================================="

# Check if tests directory exists
if [ ! -d "$SCRIPT_DIR/tests" ]; then
  echo "❌ Tests directory not found!"
  exit 1
fi

# Make test scripts executable
chmod +x "$SCRIPT_DIR/tests"/*.sh 2>/dev/null || true

# Run the main test suite
echo "📂 Running tests from: $SCRIPT_DIR/tests/"
echo ""

cd "$SCRIPT_DIR/tests" && ./run-tests.sh
