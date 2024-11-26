# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ./nix-flatpak/modules/nixos.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # NTFS Support
  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/windisk" = {
    device = "/dev/sda2";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=1000" ];
  };

  networking.hostName = "ac"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain,0.0.0.0";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Istanbul";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "tr_TR.UTF-8";
    LC_IDENTIFICATION = "tr_TR.UTF-8";
    LC_MEASUREMENT = "tr_TR.UTF-8";
    LC_MONETARY = "tr_TR.UTF-8";
    LC_NAME = "tr_TR.UTF-8";
    LC_NUMERIC = "tr_TR.UTF-8";
    LC_PAPER = "tr_TR.UTF-8";
    LC_TELEPHONE = "tr_TR.UTF-8";
    LC_TIME = "tr_TR.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us";
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.acnix = {
    isNormalUser = true;
    description = "Ahmet";
    extraGroups = [ "networkmanager" "wheel"
#     "libvirtd"
      "docker"
    ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  # Nvidia
  # Enable OpenGL
  hardware.graphics.enable = true;

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  # Bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  # ZSH
  programs.zsh = {
    enable = true;
    shellAliases = {
      update = "echo \"sudo nixos-rebuild switch\" && sudo nixos-rebuild switch";
      code = "codium";
    };
  };

  # Flatpak
  services.flatpak = {
    enable = true;
    remotes = [
      {
        name = "flathub"; location = "https://flathub.org/repo/flathub.flatpakrepo";
      }
      {
        name = "flathub-beta"; location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
      }
    ];
    packages = [
      "org.kde.kalk"

      "com.github.tchx84.Flatseal"
      "io.github.dvlv.boxbuddyrs"

      "com.github.wwmm.easyeffects"

      "one.ablaze.floorp"

      "org.mozilla.Thunderbird"
      "com.ulduzsoft.Birdtray"
      "com.tutanota.Tutanota"

      "com.brave.Browser"

      "org.libreoffice.LibreOffice"

      "dev.vencord.Vesktop"

      "com.github.KRTirtho.Spotube"

      "com.github.finefindus.eyedropper"
      { appId = "org.openrgb.OpenRGB"; origin = "flathub-beta";  }

      "com.obsproject.Studio"
      "io.mpv.Mpv"
      "fr.handbrake.ghb"
      "org.audacityteam.Audacity"
      "com.stremio.Stremio"
      "org.kde.kdenlive"
      "org.audacityteam.Audacity"

      "org.qbittorrent.qBittorrent"

      "org.blender.Blender"

      "rest.insomnia.Insomnia"
      "org.godotengine.GodotSharp"
      "io.podman_desktop.PodmanDesktop"
      # Install Manually "flatpak install https://gitlab.com/projects261/firefox-dev-flatpak/-/raw/main/firefox-dev.flatpakref"
      "org.filezillaproject.Filezilla"
      "org.apache.directory.studio"

      "com.ultimaker.cura"

      "org.bleachbit.BleachBit"
      "org.gnome.baobab"
      "com.anydesk.Anydesk"
      "com.prusa3d.PrusaSlicer"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # VM
  #   virtualisation.libvirtd = {
  #   enable = true;
  #   qemu = {
  #     package = pkgs.qemu_kvm;
  #     runAsRoot = true;
  #     swtpm.enable = true;
  #     ovmf = {
  #       enable = true;
  #       packages = [(pkgs.OVMF.override {
  #         secureBoot = true;
  #         tpmSupport = true;
  #         }).fd];
  #       };
  #     };
  #   };
  #   programs.virt-manager.enable = true;

  users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];
  virtualisation.virtualbox = {
    host = {
      enable = true;
      enableExtensionPack = true;
    };
    guest = {
    enable = true;
    dragAndDrop = true;
    };
  };

#   nixpkgs.overlays = [
#     (final: prev: {
#       vscodium = prev.vscodium.overrideAttrs (_: rec {
#         pname = "vscodium";
#         version = "1.92.2.24228";
#
#         src = pkgs.fetchFromGitHub {
#           owner = "VSCodium";
#           repo = "vscodium";
#           rev = ${version};
#           sha256 = "U0uuUmPXzXUZ7AMWLMSfWRBcvK/WGLDloSLoPcJgPGg=";
#         };
#       });
#     })
#   ];
  environment.systemPackages = with pkgs; [
    nixpkgs-fmt

    neovim
    fastfetch
    unzip

    starship
    eza
    inshellisense
    zoxide
    
    distrobox

    pkgs.firefoxpwa

    git
    gitui
    dotnetCorePackages.dotnet_8.sdk
    nodejs_20
    vscodium
    vscode libstdcxx5
    fzf ripgrep bat
    yarn
    bun
    typescript
    nodePackages."\@angular/cli"
    jdk22
    flutter323
    android-tools
    android-studio
    android-studio-tools
    python3
    tcpdump
    docker-compose
    openfortivpn
    openldap
 
    anytype
    gparted
    orca-slicer
  ];

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.package = pkgs.nix-ld-rs;

  # Docker
  virtualisation.docker.enable = true;

  # OpenLDAP
  services.openldap.enable = true;

  # OpenRGB
  services.hardware.openrgb.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  #  networking.firewall.extraCommands = ''
  #iptables -A nixos-fw -p tcp --source 192.0.2.0/24 --dport 4000:6000 -j nixos-fw-accept
  #iptables -A nixos-fw -p udp --source 192.0.2.0/24 --dport 4000:6000 -j nixos-fw-accept
  #'';
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
