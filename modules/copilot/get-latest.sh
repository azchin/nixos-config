#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_NIX="$SCRIPT_DIR/default.nix"

echo "Fetching latest version..."
NEW_VERSION=$(curl -s https://api.github.com/repos/github/copilot-cli/releases/latest | grep -Po '"tag_name": "v\K[^"]+')

if [ -z "$NEW_VERSION" ]; then
  echo "Failed to fetch version"
  exit 1
fi

echo "Latest version: $NEW_VERSION"

echo "Fetching hash..."
NEW_SHA256=$(nix-prefetch-url "https://github.com/github/copilot-cli/releases/download/v$NEW_VERSION/copilot-linux-x64.tar.gz" 2>/dev/null)

echo ""
echo "version = \"$NEW_VERSION\";"
echo "sha256 = \"$NEW_SHA256\";"

if [ "${1:-}" = "--apply" ]; then
  echo ""
  echo "Applying to $DEFAULT_NIX..."
  sed -i "s/version = \"[^\"]*\";/version = \"$NEW_VERSION\";/" "$DEFAULT_NIX"
  sed -i "s/sha256 = \"[^\"]*\";/sha256 = \"$NEW_SHA256\";/" "$DEFAULT_NIX"
  echo "Done."
fi
