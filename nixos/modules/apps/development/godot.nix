{
  pkgs,
  lib,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    godot-mono
  ];
}
