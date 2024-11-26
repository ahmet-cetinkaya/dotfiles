#!/bin/bash

echo "Cloning the nvidia-all repository..."
rm -rf ~/Downloads/nvidia-all
git clone https://github.com/Frogging-Family/nvidia-all.git ~/Downloads/nvidia-all --depth 1
cd ~/Downloads/nvidia-all || exit
echo "Run nvidia-all package..."
makepkg -si

echo "Cleaning up nvidia-all directory..."
cd ~
rm -rf ~/Downloads/nvidia-all
