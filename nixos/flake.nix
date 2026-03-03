{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nur.url = "github:nix-community/NUR";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # pkgs
    zen-browser.url = "github:youwen5/zen-browser-flake";
    whph.url = "github:ahmet-cetinkaya/whph?dir=packaging/nix";
  };

  outputs = {
    nixpkgs,
    home-manager,
    nix-flatpak,
    ...
  } @ inputs: let
    system = "x86_64-linux";
  in {
    nixosConfigurations.karakiz = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        {
          nixpkgs.hostPlatform = system;
          nixpkgs.overlays = [
            (import ./pkgs)
          ];
        }
        nix-flatpak.nixosModules.nix-flatpak
        ./hosts/karakiz/default.nix

        # Home Manager
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.ac = import ./home/ac/default.nix;
            extraSpecialArgs = {inherit inputs;};
            backupFileExtension = "hm-backup";
          };
        }
      ];
    };
  };
}
