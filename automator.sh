#!/bin/bash
# ==============================================
# AUTOMATOR INSTALLER
# Installs Automator workflows and services
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

log_info "Installing Automator workflows..."
echo "==========================================================="

SOURCE_DIR="$SCRIPT_DIR/automator"

# For current user
SERVICES_DIR="$HOME/Library/Services"
APPS_DIR="$HOME/Applications"

# Create directories if they don't exist
mkdir -p "$SERVICES_DIR" "$APPS_DIR"
log_info "Created target directories"

if [ ! -d "$SOURCE_DIR" ]; then
  log_error "Automator folder not found: $SOURCE_DIR"
  exit 1
fi

if ! ls "$SOURCE_DIR"/*.zip >/dev/null 2>&1; then
  log_warning "No ZIP files found in $SOURCE_DIR"
  log_info "Skipping Automator installation"
  exit 0
fi

log_step "Processing Automator workflows..."

SUCCESS_COUNT=0
TOTAL_COUNT=$(ls "$SOURCE_DIR"/*.zip 2>/dev/null | wc -l | tr -d ' ')

for ZIP_FILE in "$SOURCE_DIR"/*.zip; do
  FILENAME=$(basename "$ZIP_FILE")
  log_step "Installing: $FILENAME"

  TEMP_DIR=$(mktemp -d)
  if unzip -q "$ZIP_FILE" -d "$TEMP_DIR" 2>/dev/null; then
    WORKFLOW_COUNT=$(find "$TEMP_DIR" -maxdepth 1 -type d -name "*.workflow" | wc -l | tr -d ' ')

    if [ "$WORKFLOW_COUNT" -gt 0 ]; then
      find "$TEMP_DIR" -maxdepth 1 -type d -name "*.workflow" -exec mv {} "$SERVICES_DIR" \; 2>/dev/null
      log_success "$FILENAME installed ($WORKFLOW_COUNT workflows)"
      ((SUCCESS_COUNT++))
    else
      log_warning "$FILENAME contains no workflows"
    fi
  else
    log_error "Failed to extract $FILENAME"
  fi

  rm -rf "$TEMP_DIR"
done

echo ""
if [ "$SUCCESS_COUNT" -eq "$TOTAL_COUNT" ]; then
  log_success "All Automator workflows installed successfully ($SUCCESS_COUNT/$TOTAL_COUNT)"
else
  log_warning "Automator installation completed with some issues ($SUCCESS_COUNT/$TOTAL_COUNT successful)"
fi

log_info "Workflows installed to: $SERVICES_DIR"
log_info "You can access them via right-click context menu or Services menu"
