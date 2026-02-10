{
  config,
  pkgs,
  inputs,
  lib,
  username,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./finance.nix
    ./productivity.nix
    ./websites.nix
    ../../modules/gaming.nix
    # Shared modules
    ../../modules/programming.nix
    ../../modules/ai.nix
    # Servers
    ../../modules/wakapi-server.nix
    ../../modules/taskwarrior-server.nix
    ../../modules/audiobookshelf-server.nix
    ../../modules/navidrone.nix
    ../../modules/restic-backups.nix
    ../../modules/searxng.nix
    ../../modules/mediawiki.nix
    # Desktop environments (both available, choose at login)
    ../../modules/desktop/gnome.nix
    ../../modules/desktop/niri.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" ];
  hardware.keyboard.qmk.enable = true;
  services.udev.extraRules = ''
    # Via/QMK keyboard access
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true; # pulls in Solaar

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  networking.hostName = "ix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  system.nixos.label = "landsraad";

  networking.networkmanager.enable = true;
  services.tailscale.enable = true;
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

  # NOTE: SERVERS

  services.mpd = {
    enable = true;
    user = username;
    settings = {
      music_directory = "/home/${username}/Music";
      playlist_directory = "/home/${username}/Music";
      audio_output = [
        {
          type = "pipewire";
          name = "PipeWire Output";
        }
      ];
    };
  };

  systemd.services.mpd.environment = {
    XDG_RUNTIME_DIR = "/run/user/1000";
  };

  # services.xserver.libinput.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
    packages = with pkgs; [
    ];
  };
  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;
  environment.variables.EDITOR = "trinity";
  services.flatpak.enable = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # NOTE: Virtual
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # NOTE: SOFTWARE
  environment.systemPackages = with pkgs; [
    protonmail-desktop
    wget
    jq
    mat2
    ungoogled-chromium
    fd
    ripgrep
    bitwarden-desktop
    qemu_full
    localsend
    libation
    exiftool
    (wrapOBS {
      plugins = with obs-studio-plugins; [
        obs-retro-effects
        obs-composite-blur
        advanced-scene-switcher
      ];
    })
    mpd-mpris
    bleachbit
    protonvpn-gui
    ffmpegthumbnailer
    satty
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    waypaper
    via
    ffmpeg
    joplin-desktop
    runelite
    xclip
    plex-desktop
    yt-dlp
    freetube
    mpv
    signal-desktop
    btop
    cryptomator
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    (pkgs.writeShellScriptBin "trinity" ''
      exec ${inputs.trinity.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/nvim "$@"
    '')
    wike
    vlc
    gnupg
    bolt-launcher
    rclone-ui
    restic
    rmpc
    mpc
    restic-browser
  ];

  systemd.user.services.mpd-mpris = {
    description = "MPD MPRIS bridge";
    after = [ "mpd.service" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.mpd-mpris}/bin/mpd-mpris";
      Restart = "on-failure";
    };
  };

  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # services.openssh.enable = true;

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.enable = true;
  programs.localsend = {
    enable = true;
    openFirewall = true; # Automatically opens port 53317 (TCP/UDP)
  };
  system.stateVersion = "25.05"; # Did you read the comment?
}
