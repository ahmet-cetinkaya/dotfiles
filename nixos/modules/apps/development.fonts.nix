{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    # Development
    nerd-fonts.caskaydia-cove
    nerd-fonts.fira-code
    nerd-fonts.sauce-code-pro
    nerd-fonts.zed-mono
  ];
}
