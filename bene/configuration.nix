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
    ./modules/desktop/niri.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hardware
  # nvidia gpu
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

  hardware.keyboard.qmk.enable = true;
  services.udev.extraRules = ''
    # Via/QMK keyboard access
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';

  hardware.opentabletdriver.enable = true; # Tablet driver

  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
  boot.kernelParams = [ "btusb.enable_autosuspend=0" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  networking.hostName = "bene"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  system.nixos.label = "landsraad";

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

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
    ];
  };

  programs.nix-ld.enable = true;
  programs.firefox.enable = true;

  services.ollama = {
    enable = true;
    package = pkgs.ollama-vulkan;
    environmentVariables = {
      OLLAMA_KV_CACHE_TYPE = "q8_0";
      OLLAMA_KEEP_ALIVE = "30m";
      OLLAMA_NUM_CTX = "65536";
    };
  };

  nixpkgs.config.allowUnfree = true;
  environment.variables.EDITOR = "codium";
  services.flatpak.enable = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  programs.appimage.package = pkgs.appimage-run.override {
    extraPkgs = pkgs: [
      pkgs.icu
      pkgs.libxcrypt-legacy
    ];
  };

  # NOTE: SOFTWARE
  environment.systemPackages = with pkgs; [

    # VPN
    mullvad

    # utilities
    wget
    jq
    xclip
    btop
    fd
    gnupg
    ripgrep
    mat2

    # Keyboard
    wootility

    # Wayland tools
    waypaper
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly

    # Media
    plex-desktop
    vlc
    mpv

    libva-utils
    gparted
    satty
    signal-desktop
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  networking.firewall.enable = true;

  system.stateVersion = "25.05"; # Did you read the comment?
}
