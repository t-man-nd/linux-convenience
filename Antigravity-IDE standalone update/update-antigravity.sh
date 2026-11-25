#!/bin/bash

APP_DIR="$HOME/apps/AntigravityIDE"
BACKUP_DIR="$HOME/apps/AntigravityIDE.bak"
DOWNLOAD_DIR="$HOME/Downloads"

# 1. Find the latest Antigravity archive in the Downloads folder
ARCHIVE=$(ls -t "$DOWNLOAD_DIR"/*Antigravity*.tar.gz "$DOWNLOAD_DIR"/*antigravity*.tar.gz 2>/dev/null | head -n 1)

if [ -z "$ARCHIVE" ]; then
    echo "❌ No Antigravity installer (.tar.gz) found in $DOWNLOAD_DIR."
    echo "👉 Download the latest release to your Downloads folder first, then run this script again."
    exit 1
fi

echo "📦 Found installer: $ARCHIVE"

# 2. Check if the application is currently running
if pgrep -f "antigravity-ide" > /dev/null; then
    echo "⚠️  Antigravity IDE is currently running. Please close it before updating!"
    exit 1
fi

# 3. Back up the existing installation
if [ -d "$APP_DIR" ]; then
    echo "🔄 Backing up current version to $BACKUP_DIR..."
    rm -rf "$BACKUP_DIR"
    mv "$APP_DIR" "$BACKUP_DIR"
fi

# 4. Create the app directory and extract the new version
echo "🚀 Extracting new version to $APP_DIR..."
mkdir -p "$APP_DIR"
tar -xzf "$ARCHIVE" -C "$APP_DIR" --strip-components=1

# 5. Verify the extraction result
if [ -f "$APP_DIR/antigravity-ide" ]; then
    echo "✅ Update successful!"
    rm -rf "$BACKUP_DIR"
    
    # Offer to clean up the downloaded archive
    read -p "🗑️  Do you want to delete the installer '$ARCHIVE' from Downloads? (y/n): " choice
    if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
        rm -f "$ARCHIVE"
        echo "🧹 Downloaded archive cleaned up."
    fi
else
    echo "❌ Extraction failed (antigravity-ide binary not found)."
    echo "🔙 Rolling back to the previous version..."
    rm -rf "$APP_DIR"
    mv "$BACKUP_DIR" "$APP_DIR"
    exit 1
fi
