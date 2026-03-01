{pkgs, ...}: {
  users.users.ac.shell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    kitty
    fastfetch
    eza
  ];

  environment.sessionVariables = {
    TERMINAL = "kitty";
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      ohMyZsh = {
        enable = true;
        plugins = ["git" "sudo" "docker" "kubectl"];
        theme = "robbyrussell";
      };

      shellAliases = {
        ll = "ls -l";
        ls = "eza --icons=auto";
        update = "sudo nixos-rebuild switch";
      };
    };
    starship = {
      enable = true;
    };
    zoxide = {
      enable = true;
    };
  };

  system.activationScripts.terminalConfig.text = ''
    mkdir -p /home/ac/.config
    ln -sfn /home/ac/Configs/kitty /home/ac/.config/kitty
    ln -sfn /home/ac/Configs/zsh/.zshrc /home/ac/.zshrc
    ln -sfn /home/ac/Configs/starship/starship.toml /home/ac/.config/starship.toml
    chown -R ac:users /home/ac/.config/kitty /home/ac/.config/starship.toml /home/ac/.zshrc
  '';
}
