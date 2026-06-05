{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    hermes-agent.url = "github:NousResearch/hermes-agent";
    #sops-nix.url = "github:Mic92/sops-nix";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mistral-vibe = {
      url = "github:mistralai/mistral-vibe";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    trinity.url = "path:/home/f0ld/trinity";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-pinned.url = "github:NixOS/nixpkgs/fe416aaedd397cacb33a610b33d60ff2b431b127";
    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      # inputs.nixpkgs.follows = "nixpkgs";  # optional but recommended
    };
  };
  outputs =
    {
      self,
      hermes-agent,
      nixpkgs,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        ix = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            username = "f0ld";
            pkgs-pinned = import inputs.nixpkgs-pinned {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
          };
          modules = [
            { nixpkgs.hostPlatform = "x86_64-linux"; }
            inputs.nixos-hardware.nixosModules.framework-desktop-amd-ai-max-300-series
            inputs.dms-plugin-registry.modules.default
            hermes-agent.nixosModules.default
            #inputs.sops-nix.nixosModules.sops
            ./configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.f0ld = import ./home/f0ld.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                username = "f0ld";
              };
            }
            {
              nixpkgs.overlays = [
                #(import ./overlays/railway-wallet.nix)
                (import ./overlays/fix-typeguard-sphinx.nix)
              ];
            }
          ];
        };
      };
    };
}
