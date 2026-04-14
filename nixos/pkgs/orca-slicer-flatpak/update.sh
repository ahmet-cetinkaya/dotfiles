#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

TEMPLATE_URL="https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v2.3.1/OrcaSlicer-Linux-flatpak_V2.3.1_x86_64.flatpak"

VERSIONS_JSON=$(curl -sSL "https://api.github.com/repos/OrcaSlicer/OrcaSlicer/releases/latest")
VERSION=$(echo "$VERSIONS_JSON" | jq -r '.tag_name' | sed 's/^v//')
echo "🏷️  Latest version: $VERSION"

ASSET_URL="https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v${VERSION}/OrcaSlicer-Linux-flatpak_V${VERSION}_x86_64.flatpak"
echo "📥 Fetching $ASSET_URL..."

TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE"' EXIT

curl -SLf "$ASSET_URL" -o "$TMPFILE"

SHA256=$(sha256sum "$TMPFILE" | cut -d' ' -f1)
echo "🔐 SHA256: $SHA256"

sed -i "s|https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v[^/]*|https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v${VERSION}|" default.nix
sed -i "s|OrcaSlicer-Linux-flatpak_V[^.]*\.flatpak|OrcaSlicer-Linux-flatpak_V${VERSION}.flatpak|" default.nix
sed -i "s|v[^\"]*\"$|v${VERSION}\"|" default.nix
sed -i "0,/sha256 = \".*\"/s|sha256 = \".*\"|sha256 = \"$SHA256\"|" default.nix
echo "✅ Updated default.nix"
