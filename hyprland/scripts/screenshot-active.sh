#!/bin/bash

# Screenshot directory
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"

# Output file name
FILENAME="$DIR/$(date +%Y-%m-%d_%H-%M-%S).png"

# Let user select a region with slurp
GEO=$(slurp)

# If no selection was made, exit
if [ -z "$GEO" ]; then
  notify-send "Screenshot" "No region selected." -u normal
  exit 1
fi

# Capture selected region with grim
grim -g "$GEO" "$FILENAME"

# Copy to clipboard
wl-copy < "$FILENAME"

# Open with swappy for editing
swappy -f "$FILENAME" --output-file "$FILENAME"
