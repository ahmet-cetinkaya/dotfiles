{
  pkgs,
  inputs,
  ...
}: {
  # Flatpak
  services.flatpak.packages = [
    # Social
    "dev.vencord.Vesktop"
    "org.mozilla.Thunderbird"
    "com.ulduzsoft.Birdtray"

    # Network
    "com.protonvpn.www"
  ];

  # System packages
  environment.systemPackages = with pkgs; [
    # Browsers
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    brave
    firefox
    chromium
  ];

  # Chrome Config
  environment = {
    sessionVariables = {
      CHROME_EXECUTABLE = "chromium";
    };
  };
}
