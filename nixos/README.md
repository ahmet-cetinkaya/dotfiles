# 🐧 NixOS Custom Config

This guide will show you how to set up **NixOS** with symbolic links directly to your custom configuration directory. This method is helpful for managing your configuration files in a centralized location.

## ⚙️ Setup

### 1. **Create Symbolic Links for NixOS Configuration Directory**

Instead of linking individual files, you can link an entire directory to the NixOS configuration directory. This approach is more flexible if you have a collection of configuration files and directories.

#### 1.1 **Create Symbolic Link for NixOS Configuration Folder**

In this step, we will link your custom **NixOS configuration** directory to `/etc/nixos/`. This will allow you to manage all your configuration files from a central location.

Run the following command in **bash** or **zsh** (replace `username` with your actual username):

```bash
ln -s ~/Configs/nixos/ /etc/nixos/
```

This creates a symbolic link that points the `/etc/nixos/` directory to your custom configuration directory located at `~/Configs/nixos/`.

### 2. **Rebuild the System Configuration**

After linking the configuration directory, you can apply the changes by running the following command to rebuild your system:

```bash
sudo nixos-rebuild switch
```

This will apply the configuration from your custom folder, and NixOS will rebuild and update the system based on the files in `~/Configs/nixos/`.


## 🧰 Common NixOS Configuration Tasks

### 1. **Installing Packages**

To install packages, add them to your `configuration.nix` under `environment.systemPackages` in your custom config directory:

```nix
environment.systemPackages = with pkgs; [
  vim
  git
  htop
];
```

After modifying the configuration, run:

```bash
sudo nixos-rebuild switch
```

### 2. **Managing Users**

You can add user accounts by editing the `users.users` section of your `configuration.nix`:

```nix
users.users.myuser = {
  isNormalUser = true;
  shell = pkgs.zsh;
  extraGroups = [ "wheel" ]; # Allow user to sudo
};
```

After updating, rebuild the system:

```bash
sudo nixos-rebuild switch
```

### 3. **Enabling Services**

To enable services like **SSH** or **NetworkManager**, modify the appropriate sections in your `configuration.nix`. For example, to enable SSH:

```nix
services.openssh.enable = true;
```

Rebuild the system to apply:

```bash
sudo nixos-rebuild switch
```

## 🛠️ Troubleshooting

If something goes wrong, you can rollback to the previous configuration:

```bash
sudo nixos-rebuild switch --rollback
```

This will restore the last working configuration from the NixOS store.
