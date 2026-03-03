{ pkgs, ... }: {
  services.zapret = {
    enable = true;
    params = [
      # Connbytes limiter: only desync first N packets, then normal (preserves E2EE)
      "--dpi-desync=fake"
      "--dpi-desync-ttl=2"
      # Apply desync only to first 9 packets out, 3 packets in
      "--dpi-desync-cutoff=n9"
    ];
  };

  # Zapret is transparent, so we don't need system-wide proxy environment variables.
  # This avoids "proxy protocol" errors in applications.
  networking.proxy = {
    default = null;
    httpProxy = null;
    httpsProxy = null;
  };

  # Force public DNS to avoid hijacking
  networking.nameservers = [
    "1.1.1.1"
    "8.8.8.8"
  ];
  networking.resolvconf.extraConfig = ''
    name_servers="1.1.1.1 8.8.8.8"
  '';
  networking.networkmanager.dns = "none";
}
