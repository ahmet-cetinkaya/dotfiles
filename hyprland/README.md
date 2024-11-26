# 🖥️ Hyprland Custom Config

This guide will help you set up **Hyprland** workspace management and install necessary utilities.

## ⚙️ Setup

1. **Install polkit-gnome** for Authentication Agent

    Hyprland requires **polkit-gnome** to handle authentication via a graphical agent.

    Run the following command to install **polkit-gnome**:

    ```bash
    sudo pacman -S polkit-gnome
    ```

2. **Start polkit-gnome Authentication Agent**

    Once installed, you need to start the authentication agent to enable graphical authentication.

    Run this command:

    ```bash
    /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
    ```

    You can add this command to your startup scripts (e.g., `.xinitrc` or a relevant autostart file) to ensure it runs on boot.

3. **Create Symbolic Link for Hyprland Configs**

    Create a symbolic link to your custom **Hyprland** configuration folder. This will link the configuration files to the appropriate directory for Hyprland to load.

    Run the following command:

    ```bash
    ln -s ~/Configs/hyprland/ ~/Configs/hyprland
    ```

    This command links your custom **Hyprland** configuration directory (`~/Configs/hyprland/`) to its default location.
