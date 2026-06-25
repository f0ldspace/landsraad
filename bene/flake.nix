{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-desktop = {
      url = "github:k3d3/claude-desktop-linux-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-pinned.url = "github:NixOS/nixpkgs/fe416aaedd397cacb33a610b33d60ff2b431b127";
    nixvim = {
      url = "github:nix-community/nixvim";
      # inputs.nixpkgs.follows = "nixpkgs";  # optional but recommended
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
            ./configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.deviate = import ./home/deviate.nix;
              home-manager.sharedModules = [
                inputs.spicetify-nix.homeManagerModules.default
              ];
              home-manager.extraSpecialArgs = {
                inherit inputs;
                username = "deviate";
              };
            }
            {
              nixpkgs.overlays = [
                (import ./overlays/railway-wallet.nix)
                (import ./overlays/fix-typeguard-sphinx.nix)
                (import ./overlays/rusty-path-of-building.nix)
              ];
            }
          ];
        };
      };
    };
}
