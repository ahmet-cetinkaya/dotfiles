{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    claude-code # General-purpose agent CLIs, not tied to JavaScript development.
    gemini-cli
    kilo
    codex
    qwen-code
    opencode
  ];
}
