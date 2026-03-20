{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
  ];

  # GNOME Desktop Environment
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.gnome.gnome-settings-daemon.enable = true;

  # GNOME clipboard manager
  programs.gpaste.enable = true;

  # GNOME packages
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnome-themes-extra
    gtk-engine-murrine
    sassc
    ocs-url
  ];
}
