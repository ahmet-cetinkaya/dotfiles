{ lib, ... }:

{
  services.ollama.enable = true;

  environment.sessionVariables = {
    OLLAMA_HOST = "127.0.0.1:11434";
  };
}
