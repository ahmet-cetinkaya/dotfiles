#!/usr/bin/env bash

echo "Starting Nix cleanup..."

echo "1. Collecting user garbage..."
nix-collect-garbage -d

echo "2. Collecting system garbage..."
sudo nix-collect-garbage -d

echo "3. Optimising the Nix store (this may take a while)..."
nix-store --optimise

echo "Cleanup complete!"
