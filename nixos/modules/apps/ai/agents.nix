{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    opencode
    claude-code
  ];

  # LITE MODE: managed settings disabled entirely while sandbox hardening is rolled back.
  # Restore from .local/backups/pre-sandbox-removal-20261005/agents.nix when ready.

  home-manager.sharedModules = [
    ({config, ...}: {
      home.file.".agent-ctrl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Configs/agent-ctrl";
    })
  ];
}
