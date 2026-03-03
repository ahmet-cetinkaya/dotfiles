{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
    initrd.kernelModules = [];
    kernelModules = ["kvm-amd"];
    extraModulePackages = [];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/ca26f48f-62a5-41ca-a450-dec7f601ea9d";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/8FF4-C3C7";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };
    "/run/media/ac/hdd" = {
      device = "/dev/disk/by-uuid/68004D20004CF69A";
      fsType = "ntfs-3g";
      options = ["auto" "nofail" "user" "exec" "uid=1000" "gid=100" "umask=022" "utf8"];
    };
  };

  swapDevices = [];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
