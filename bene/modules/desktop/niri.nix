{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
  ];

  # Use GDM as display manager (shows Niri as a session option)
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;

  # Enable Niri compositor
  programs.niri.enable = true;

  # Enable XWayland for X11 apps (Steam, games, etc.)
  programs.xwayland.enable = true;

  # XDG portal for screen sharing, file dialogs, etc.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Polkit for privilege escalation dialogs
  security.polkit.enable = true;

  # PAM configuration for dms lock screen
  security.pam.services.dms-greeter = { };

  # Enable dconf for GTK settings to work in niri session
  programs.dconf.enable = true;

  # GNOME Keyring for secrets (used by both GNOME and niri)
  services.gnome.gnome-keyring.enable = true;

  # Environment variables for Wayland compatibility
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    # Don't force SDL to wayland - breaks Steam and many games
    # SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  # Niri packages
  environment.systemPackages = with pkgs; [
    # XWayland for X11 apps
    xwayland-satellite

    # Launcher
    wofi

    # Screenshots
    grim
    slurp
    satty

    # Recording
    wf-recorder

    # Wallpaper
    awww
    waypaper

    # Utilities
    brightnessctl
    playerctl
    pulsemixer
    nautilus
    polkit_gnome
    wdisplays
    wlsunset
    networkmanagerapplet

    # GTK theming support
    gnome-themes-extra
  ];

  # Start polkit agent for privilege escalation
  #systemd.user.services.polkit-gnome-agent = {
    #description = "Polkit GNOME Authentication Agent";
    #wantedBy = [ "graphical-session.target" ];
    #wants = [ "graphical-session.target" ];
    #after = [ "graphical-session.target" ];
    #serviceConfig = {
      #Type = "simple";
      #ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      #Restart = "on-failure";
      #RestartSec = 1;
      #TimeoutStopSec = 10;
    #};
  #};
}
