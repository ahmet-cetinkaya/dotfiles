#!/bin/bash

# Stop and disable libvirtd service and its associated sockets
echo "🔧 Stopping and disabling libvirtd service and its sockets..."
sudo systemctl stop libvirtd.service libvirtd-admin.socket libvirtd-ro.socket libvirtd.socket
sudo systemctl disable libvirtd.service libvirtd-admin.socket libvirtd-ro.socket libvirtd.socket

# Remove user from libvirt group
echo "🔧 Removing user from libvirt group..."
sudo gpasswd -d $(whoami) libvirt || echo "User is not a member of libvirt group"

# Restore default libvirtd configuration
echo "🔧 Restoring default libvirtd configuration..."
sudo sed -i 's/^unix_sock_group = .*/#unix_sock_group = "libvirt"/' /etc/libvirt/libvirtd.conf
sudo sed -i 's/^unix_sock_rw_perms = .*/#unix_sock_rw_perms = "0770"/' /etc/libvirt/libvirtd.conf

# Remove installed packages with a single removal message
echo "📦 Removing KVM, QEMU, Virt-Manager, and related packages..."
sudo pacman -Rns --noconfirm libguestfs || echo "libguestfs is not installed."
sudo pacman -Rns --noconfirm ebtables || echo "ebtables is not installed."
sudo pacman -Rns --noconfirm iptables || echo "iptables is not installed."
sudo pacman -Rns --noconfirm qemu || echo "qemu is not installed."
sudo pacman -Rns --noconfirm virt-manager || echo "virt-manager is not installed."
sudo pacman -Rns --noconfirm virt-viewer || echo "virt-viewer is not installed."
sudo pacman -Rns --noconfirm dnsmasq || echo "dnsmasq is not installed."
sudo pacman -Rns --noconfirm vde2 || echo "vde2 is not installed."
sudo pacman -Rns --noconfirm bridge-utils || echo "bridge-utils is not installed."
sudo pacman -Rns --noconfirm openbsd-netcat || echo "openbsd-netcat is not installed."
sudo pacman -Rns --noconfirm dmidecode || echo "dmidecode is not installed."

# Disable nested virtualization (optional)
read -p "Do you want to disable nested virtualization? (y/n): " disable_nested
if [ "$disable_nested" == "y" ]; then
    echo "🔧 Disabling nested virtualization..."

    if grep -q "Intel" /proc/cpuinfo; then
        echo "🔧 Configuring Intel processor..."
        sudo modprobe -r kvm_intel
        echo "options kvm-intel nested=0" | sudo tee /etc/modprobe.d/kvm-intel.conf
        sudo modprobe kvm_intel nested=0
    elif grep -q "AMD" /proc/cpuinfo; then
        echo "🔧 Configuring AMD processor..."
        sudo modprobe -r kvm_amd
        echo "options kvm-amd nested=0" | sudo tee /etc/modprobe.d/kvm-amd.conf
        sudo modprobe kvm_amd nested=0
    else
        echo "❌ Unsupported processor type."
    fi
fi

echo "✅ KVM, QEMU, Virt-Manager, and related packages have been removed and configurations restored."
