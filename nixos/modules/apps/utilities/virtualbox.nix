{ config, pkgs, ... }:
{
  # VirtualBox virtualization
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "ac" ];

  # VirtualBox kernel modules
  boot.extraModulePackages = [ config.boot.kernelPackages.virtualbox ];
  boot.kernelModules = [ "vboxdrv" "vboxnetflt" "vboxnetadp" ];
}
