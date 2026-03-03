{
  pkgs,
  inputs,
  ...
}: {
  # Flatpak
  services.flatpak.packages = [
    # Social
    "dev.vencord.Vesktop"
  ];

  # System packages
  environment.systemPackages = with pkgs; [
    # Browsers
    firefox
    chromium
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # Chrome Config
  environment = {
    sessionVariables = {
      CHROME_EXECUTABLE = "chromium";
    };
  };
}
