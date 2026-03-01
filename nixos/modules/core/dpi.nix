_: {
  services.zapret = {
    enable = true;
    # Using parameters recovered from your old config
    params = [
      "--dpi-desync=fake"
      "--dpi-desync-ttl=2"
    ];
  };

  # Zapret is transparent, so we don't need system-wide proxy environment variables.
  # This avoids "proxy protocol" errors in applications.
  networking = {
    proxy = {
      default = null;
      httpProxy = null;
      httpsProxy = null;
    };

    # Force public DNS to avoid hijacking
    nameservers = ["1.1.1.1" "8.8.8.8"];
    resolvconf.extraConfig = ''
      name_servers="1.1.1.1 8.8.8.8"
    '';
    networkmanager.dns = "none";
  };

  # No need for special wrappers anymore
  environment.systemPackages = [];
}
