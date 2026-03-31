{ config, pkgs, ... }:

{
  imports = [ ./common.nix ];

  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  security.polkit.enable = true;
  programs.dconf.enable = true;
  services.gnome.gnome-keyring.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    LD_LIBRARY_PATH = "${pkgs.libayatana-appindicator}/lib\${LD_LIBRARY_PATH:+:\${LD_LIBRARY_PATH}}";
    QSG_RHI_BACKEND = "vulkan";
  };

  environment.systemPackages = with pkgs; [
    # Screenshots
    grim
    slurp
    satty
    swappy

    # Recording
    wf-recorder

    # Wallpaper
    swww
    waypaper

    # Clipboard
    wl-clipboard
    cliphist

    # Launcher (fallback for clipboard picker)
    wofi

    # Utilities
    brightnessctl
    playerctl
    pulsemixer
    nautilus
    polkit_gnome
    wdisplays
    wlsunset
    networkmanagerapplet
    libnotify
    fish

    # GTK theming support
    gnome-themes-extra
    gtk-engine-murrine

    # Hardware control (used by caelestia for brightness/display)
    ddcutil

    # Caelestia-shell dependencies
    aubio
    lm_sensors
  ];

  systemd.user.services.polkit-gnome-agent = {
    description = "Polkit GNOME Authentication Agent";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
