#!/bin/bash

SOURCE_DIR="$(dirname "$0")/../automator"

# For current user
SERVICES_DIR="$HOME/Library/Services"
APPS_DIR="$HOME/Applications"

# Create directories if they don't exist
mkdir -p "$SERVICES_DIR"
mkdir -p "$APPS_DIR"

if [ ! -d "$SOURCE_DIR" ]; then
  echo "Folder $SOURCE_DIR not found."
  exit 1
fi

if ! ls "$SOURCE_DIR"/*.zip >/dev/null 2>&1; then
  echo "Can't find ZIP files in $SOURCE_DIR."
  exit 1
fi

echo "Installing Automator scripts"

for ZIP_FILE in "$SOURCE_DIR"/*.zip; do
  echo "Installing: $ZIP_FILE"

  TEMP_DIR=$(mktemp -d)
  unzip -q "$ZIP_FILE" -d "$TEMP_DIR"

  find "$TEMP_DIR" -maxdepth 1 -type d -name "*.workflow" -exec mv {} "$SERVICES_DIR" \;

  rm -rf "$TEMP_DIR"
done

echo "✔ Installation complete!"
