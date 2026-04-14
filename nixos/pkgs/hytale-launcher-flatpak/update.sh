#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

URL="https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-latest.flatpak"
echo "📥 Fetching $URL..."

TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE"' EXIT

curl -SLf "$URL" -o "$TMPFILE"

SHA256=$(sha256sum "$TMPFILE" | cut -d' ' -f1)
echo "🔐 SHA256: $SHA256"

sed -i "s|sha256 = \".*\"|sha256 = \"$SHA256\"|" default.nix
echo "✅ Updated default.nix"
