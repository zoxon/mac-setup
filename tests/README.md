# 🧪 Mac-Setup Test Suite

Comprehensive testing framework for the mac-setup project that validates functionality, error handling, and system compatibility.

## 📁 Test Structure

```
tests/
├── run-tests.sh                    # Main test runner
├── test-core-functionality.sh      # Core functions and utilities
├── test-compatibility-config.sh    # System compatibility checks
├── test-package-resilience.sh      # Package installation error handling
└── README.md                       # This documentation
```

## 🚀 Quick Start

### Run All Tests
```bash
cd tests
./run-tests.sh
```

### Run Individual Tests
```bash
# Core functionality (17 tests)
./test-core-functionality.sh

# System compatibility and configuration
./test-compatibility-config.sh

# Package installation resilience (requires Homebrew)
./test-package-resilience.sh
```

## 📊 Test Categories

### 🔧 Core Functionality (`test-core-functionality.sh`)
- ✅ Configuration file loading
- ✅ Logging system functions
- ✅ Utility functions (check_command, check_file, etc.)
- ✅ Internet connectivity
- ✅ Script executability
- ✅ Configuration file presence

**Tests:** 17 | **Duration:** ~5 seconds

### 🖥️ Compatibility & Configuration (`test-compatibility-config.sh`)
- ✅ macOS version compatibility
- ✅ Architecture detection (Intel/Apple Silicon)
- ✅ Disk space verification
- ✅ Environment variables
- ✅ Color logging display
- ✅ Project structure validation

**Tests:** Multiple checks | **Duration:** ~10 seconds

### 📦 Package Resilience (`test-package-resilience.sh`)
- ✅ Error handling with fake packages
- ✅ Successful installation of real packages
- ✅ Continuation after failed installations
- ✅ Proper error reporting and summaries

**Tests:** Mixed real/fake packages | **Duration:** ~30 seconds | **Requires:** Homebrew

## 🎯 Test Results Interpretation

### ✅ Success Indicators
- All tests show `✅ PASS`
- Green success messages
- Zero failed tests in summary
- Exit code 0

### ❌ Failure Indicators
- Tests show `❌ FAIL`
- Red error messages
- Non-zero failed test count
- Exit code 1

### ⚠️ Warning Indicators
- Yellow warning messages
- Expected failures (e.g., fake packages)
- Skipped tests (missing dependencies)

## 🛠️ Prerequisites

### Required
- macOS (any supported version)
- Internet connectivity
- Execute permissions on test scripts

### Optional
- Homebrew (for package resilience tests)
- ZSH shell (recommended)

## 📝 Adding New Tests

### Test Function Template
```bash
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
```

### Adding to Test Suite
1. Create test script in `tests/` directory
2. Make it executable: `chmod +x test-new-feature.sh`
3. Add to `TEST_SUITES` array in `run-tests.sh`
4. Follow existing naming convention: `test-[feature].sh`

## 🐛 Troubleshooting

### Common Issues

**Tests fail with "config.sh not found"**
```bash
# Ensure you're running from the project root or tests directory
cd /path/to/mac-setup/tests
./run-tests.sh
```

**Package tests fail**
```bash
# Install Homebrew first
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**Permission denied errors**
```bash
# Make scripts executable
chmod +x tests/*.sh
```

**Internet connectivity tests fail**
```bash
# Check your internet connection
curl -s https://github.com >/dev/null && echo "OK" || echo "No connection"
```

## 📈 Performance Benchmarks

| Test Suite | Duration | Tests | Dependencies |
|------------|----------|-------|--------------|
| Core Functionality | ~5s | 17 | None |
| Compatibility | ~10s | Multiple | None |
| Package Resilience | ~30s | Variable | Homebrew |
| **Total** | **~45s** | **25+** | **Internet** |

## 🔄 CI/CD Integration

### GitHub Actions Example
```yaml
name: Test mac-setup
on: [push, pull_request]
jobs:
  test:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run tests
        run: |
          chmod +x tests/*.sh
          cd tests && ./run-tests.sh
```

## 📚 Related Documentation

- [Main README](../README.md) - Project overview and installation
- [CHANGELOG](../CHANGELOG.md) - Version history and improvements
- [Configuration Guide](../configs/README.md) - Config customization

## 🤝 Contributing

When contributing new features:

1. Add corresponding tests
2. Ensure all existing tests pass
3. Update test documentation
4. Follow existing test patterns and naming conventions

---

**💡 Pro Tip:** Run tests before and after making changes to ensure nothing breaks!
