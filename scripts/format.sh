#!/bin/bash

# Format shell scripts using shfmt

# Check if shfmt is installed
if ! command -v shfmt &> /dev/null; then
    echo "shfmt not found. Installing via go install..."
    go install mvdan.cc/shfmt/v3/cmd/shfmt@latest
    if [ $? -ne 0 ]; then
        echo "Failed to install shfmt. Please ensure Go is installed and GOPATH/bin is in PATH."
        exit 1
    fi
fi

# Find all .sh files and format them
find . -name "*.sh" -type f -exec shfmt -w {} \;

echo "Shell scripts formatted successfully."