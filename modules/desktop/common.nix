{ config, pkgs, ... }:

{
  # Keyboard layout
  services.xserver.xkb = {
    layout = "gb";
    variant = "mac";
  };
  console.keyMap = "uk";

  # Audio via Pipewire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term
  ];

  # Shared desktop utilities
  environment.systemPackages = with pkgs; [
    alacritty
    wofi
    yazi
    wl-clipboard
    cliphist
    libnotify
  ];
}
