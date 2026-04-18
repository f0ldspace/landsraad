{
  config,
  pkgs,
  inputs,
  lib,
  username,
  pkgs-pinned,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./finance.nix
    ./productivity.nix
    ./gaming.nix
    # Shared modules
    ./programming.nix
    ./ai.nix
    # Desktop environments (both available, choose at login)
    ./modules/desktop/gnome.nix
    ./modules/desktop/hyprland.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # NVIDIA GPU configuration
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false; # Use proprietary driver
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Hybrid graphics - both AMD iGPU and NVIDIA dGPU
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # For Steam/gaming
  };

  #  nix.gc = {
  #  automatic = true;
  #  dates = "weekly";
  #  options = "--delete-older-than 14d";
  #};

  networking.hostName = "bene"; # Define your hostname.
  system.nixos.label = "bene";

  networking.networkmanager.enable = true;
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  services.printing.enable = true;

  hardware.opentabletdriver.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "libvirtd"
    ];
    packages = with pkgs; [
    ];
  };
  programs.firefox.enable = true;
  #services.ollama = {
  #  enable = true;
  #  package = pkgs.ollama-vulkan;
  #  environmentVariables = {
  #    OLLAMA_KV_CACHE_TYPE = "q8_0";
  #    OLLAMA_KEEP_ALIVE = "30m";
  #    OLLAMA_NUM_CTX = "65536";
  #  };
  #};

  nixpkgs.config.allowUnfree = true;
  environment.variables.EDITOR = "codium";
  services.flatpak.enable = true;
  #services.mullvad-vpn.enable = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Mandarin support
  #fonts.packages = with pkgs; [
  #  noto-fonts-cjk-sans
  #  noto-fonts-cjk-serif

  #];

  # Minimal package set
  environment.systemPackages = with pkgs; [
    # Browsers
    firefox
    ungoogled-chromium
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

    # Media players
    mpv
    vlc
    plex-desktop

    # VPN
<<<<<<< HEAD
    # mullvad-vpn
=======
    mullvad-vpn
    
    # VM
    qemu
    virt-manager
>>>>>>> d10eabb (claude slop)

    # Basic utilities
    wget
    jq
    fd
    ripgrep
    btop
    xclip
    gnupg

    # Keyboard utility
    wootility
    
    # Wayland tools
    waypaper
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
  ];

  virtualisation.libvirtd.enable = true;

  services.udev.extraRules = ''
    SUBSYSTEM=="input", ATTRS{idVendor}=="056a", ATTRS{idProduct}=="037a", MODE="0000"
  '';

  networking.firewall.enable = true;
  system.stateVersion = "25.05";
}
