_: {
  services.zapret = {
    enable = true;
    params = [
      # Connbytes limiter: only desync first N packets, then normal (preserves E2EE)
      "--dpi-desync=fake"
      "--dpi-desync-ttl=2"
      # Apply desync only to first 9 packets out, 3 packets in
      "--dpi-desync-cutoff=n9"
      # Exclude local network traffic from DPI bypass
      # This fixes MIME type issues with local web services (e.g., Klipper at 192.168.1.5)
      "--ipset-exclude-ip=10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,127.0.0.0/8,169.254.0.0/16"
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
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    resolvconf.extraConfig = ''
      name_servers="1.1.1.1 8.8.8.8"
    '';
    networkmanager.dns = "none";
  };
}
