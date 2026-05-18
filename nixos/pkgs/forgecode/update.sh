#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

CURRENT_VERSION=$(grep 'version = "' default.nix | sed 's/.*version = "\(.*\)".*/\1/')
echo "📌 Current version: $CURRENT_VERSION"

VERSIONS_JSON=$(curl -sSL "https://api.github.com/repos/tailcallhq/forgecode/releases")
LATEST_VERSION=$(echo "$VERSIONS_JSON" | jq -r '.[0].tag_name' | sed 's/^v//')
echo "🏷️  Latest version: $LATEST_VERSION"

if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
	echo "✅ Already up to date"
	exit 0
fi

echo "🔐 Fetching SHA256 for x86_64..."
TMPFILE_X86=$(mktemp)
trap 'rm -f "$TMPFILE_X86"' EXIT
curl -SLf "https://github.com/tailcallhq/forgecode/releases/download/v${LATEST_VERSION}/forge-x86_64-unknown-linux-gnu" -o "$TMPFILE_X86"
SHA256_X86=$(sha256sum "$TMPFILE_X86" | cut -d' ' -f1)
echo "🔐 SHA256 (x86_64): $SHA256_X86"

echo "🔐 Fetching SHA256 for aarch64..."
TMPFILE_AARCH64=$(mktemp)
trap 'rm -f "$TMPFILE_AARCH64"' EXIT
curl -SLf "https://github.com/tailcallhq/forgecode/releases/download/v${LATEST_VERSION}/forge-aarch64-unknown-linux-gnu" -o "$TMPFILE_AARCH64"
SHA256_AARCH64=$(sha256sum "$TMPFILE_AARCH64" | cut -d' ' -f1)
echo "🔐 SHA256 (aarch64): $SHA256_AARCH64"

sed -i "s|version = \".*\"|version = \"$LATEST_VERSION\"|" default.nix

# Replace sha256 within the x86_64 block (between "x86_64-linux" and "aarch64-linux")
sed -i "/x86_64-linux/,/aarch64-linux/{
  s|sha256 = \".*\"|sha256 = \"$SHA256_X86\"|
}" default.nix

# Replace sha256 within the aarch64 block (between "aarch64-linux" and "else")
sed -i "/aarch64-linux/,/else/{
  s|sha256 = \".*\"|sha256 = \"$SHA256_AARCH64\"|
}" default.nix

echo "✅ Updated default.nix"