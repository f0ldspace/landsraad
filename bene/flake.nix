{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-pinned.url = "github:NixOS/nixpkgs/fe416aaedd397cacb33a610b33d60ff2b431b127";
  };
  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        bene = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            username = "deviate";
            pkgs-pinned = import inputs.nixpkgs-pinned {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
          };
          modules = [
            { nixpkgs.hostPlatform = "x86_64-linux"; }
            inputs.nixos-hardware.nixosModules.framework-desktop-amd-ai-max-300-series
            inputs.dms-plugin-registry.nixosModules.default
            ./configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.deviate = import ./home/deviate.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                username = "deviate";
              };
            }
            {
              nixpkgs.overlays = [
                (import ./overlays/fix-typeguard-sphinx.nix)
              ];
            }
          ];
        };
      };
    };
}
