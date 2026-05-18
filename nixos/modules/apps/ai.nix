{ lib, pkgs, ... }:

{
  services.ollama.enable = true;
  environment.sessionVariables = {
    OLLAMA_HOST = "127.0.0.1:11434";
  };

  environment.systemPackages = [
    pkgs.llmfit
    pkgs.rtk
    
    # Alternative AI model runner
    pkgs.lmstudio
  ];
}
