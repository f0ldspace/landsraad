{ config, pkgs, lib, ... }:

{
  imports = [
    # Desktop-specific home configs (both loaded)
    ./gnome.nix
    ./niri.nix
  ];

  home.username = "deviate";
  home.homeDirectory = "/home/deviate";

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  # This value determines the home-manager release that your
  # configuration is compatible with.
  home.stateVersion = "24.11";
}
