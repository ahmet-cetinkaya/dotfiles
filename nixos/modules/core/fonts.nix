{pkgs, ...}: {
  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-cove # Cascadia Code Nerd Font Version
    nerd-fonts.zed-mono # Iosevka Nerd Font Version
  ];
}
