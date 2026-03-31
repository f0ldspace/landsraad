{ config, pkgs, lib, inputs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  imports = [
    # Desktop-specific home configs (both loaded)
    ./gnome.nix
    ./hyprland.nix
  ];

  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";
  };

  home.username = "deviate";
  home.homeDirectory = "/home/deviate";

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  # This value determines the home-manager release that your
  # configuration is compatible with.
  home.stateVersion = "24.11";
}
