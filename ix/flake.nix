{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    #hermes-agent.url = "github:NousResearch/hermes-agent";
    rust-overlay.url = "github:oxalica/rust-overlay";
    omp.url = "github:can1357/oh-my-pi";
    railoxide = {
      url = "github:triamazikamno/railoxide";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    handy.url = "github:cjpais/Handy";
    handy.inputs.nixpkgs.follows = "nixpkgs";
    #sops-nix.url = "github:Mic92/sops-nix";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
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
    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs = {
        # Our Doom configuration lives in this repo.
        # ("path:" prefix avoids the git-subdirectory input quirk, NixOS/nix#16388)
        doomdir.url = "path:./doom.d";
        # Prune the unused nixpkgs input so we don't pull nixpkgs-unstable.
        # (Neither the home-manager module nor the overlay uses it.)
        nixpkgs.follows = "";
      };
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      # inputs.nixpkgs.follows = "nixpkgs";  # optional but recommended
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      handy,
      nixpkgs-unstable,
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
            pkgs-unstable = import nixpkgs-unstable {
              system = "x86_64-linux";
              config.allowUnfree = true; # if you need CUDA/unfree stuff
            };
          };
          modules = [
            { nixpkgs.hostPlatform = "x86_64-linux"; }
            inputs.nixos-hardware.nixosModules.framework-desktop-amd-ai-max-300-series
            inputs.dms-plugin-registry.nixosModules.default
            #inputs.sops-nix.nixosModules.sops
            handy.nixosModules.default
            {
              programs.handy.enable = true;
              # Optional: configure typing tool
            }
            ./configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.f0ld = {
                imports = [
                  # Exposes programs.doom-emacs (nix-doom-emacs-unstraightened)
                  inputs.nix-doom-emacs-unstraightened.homeModule
                  ./home/f0ld.nix
                ];
              };
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
