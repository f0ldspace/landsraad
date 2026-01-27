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
    trinity.url = "path:/home/f0ld/trinity";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      # inputs.nixpkgs.follows = "nixpkgs";  # optional but recommended
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
        ix = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.hostPlatform = "x86_64-linux"; }
            ./hosts/ix/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.f0ld = import ./home/f0ld.nix;
              home-manager.extraSpecialArgs = { inherit inputs; };
            }
            {
              nixpkgs.overlays = [
                (import ./overlays/railway-wallet.nix)
              ];
            }
          ];
        };

        caladan = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.hostPlatform = "x86_64-linux"; }
            ./hosts/caladan/configuration.nix
          ];
        };
      };
    };
}
