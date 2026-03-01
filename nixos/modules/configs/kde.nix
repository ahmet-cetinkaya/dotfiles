{...}: {
  # Configure Kitty as the default terminal for Dolphin "Open Terminal Here" action
  xdg.configFile = {
    "kdeglobals".text = ''
      [General]
      TerminalApplication=kitty
    '';
    "dolphinrc".text = ''
      [General]
      ShellExecuter=kitty
    '';
    "kservices6/OpenTerminalHere.desktop".text = ''
      [Desktop Entry]
      Type=Service
      ServiceTypes=KonqPopupMenu/Plugin,inode/directory,inode/directory/desktop
      Actions=openTerminalHere

      [Desktop Action openTerminalHere]
      Name=Open Terminal Here
      Icon=utilities-terminal
      Exec=kitty --directory="%f"
    '';
  };
}
