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
    ./websites.nix
    ./gaming.nix
    # Shared modules
    ./programming.nix
    ./ai.nix
    # Servers
    ./servers/wakapi-server.nix
    #./modules/taskwarrior-server.nix
    ./servers/audiobookshelf-server.nix
    #./servers/navidrone.nix
    ./restic-backups.nix
    #./modules/miniflux.nix
    ./servers/searxng.nix
    ./servers/immich.nix
    #./servers/open-webui.nix
    #./modules/mediawiki.nix
    #./servers/privatebin.nix
    #./modules/forgejo.nix
    ./ix-cloudflared.nix
    # Desktop environments (both available, choose at login)
    ./modules/desktop/gnome.nix
    ./modules/desktop/niri.nix
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
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
  boot.kernelParams = [ "btusb.enable_autosuspend=0" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  networking.hostName = "ix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  system.nixos.label = "landsraad";
  programs.dms-shell = {
    enable = true;
  };
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

  # NOTE: SERVICES

  services.hermes-agent = {
    enable = true;
    settings.model.default = "anthropic/claude-sonnet-4";
    #environmentFiles = [ config.sops.secrets."hermes-env".path ];
    addToSystemPackages = true;
  };
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
  environment.variables.EDITOR = "trinity";
  services.flatpak.enable = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # NOTE: Virtual
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # NOTE: Mandarin support
  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif

  ];

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  programs.appimage.package = pkgs.appimage-run.override {
    extraPkgs = pkgs: [
      pkgs.icu
      pkgs.libxcrypt-legacy
      pkgs.python312
      pkgs.python312Packages.torch
    ];
  };

  services.mpdscribble = {
    enable = true;
    endpoints = {
      "last.fm" = {
        url = "https://post.audioscrobbler.com/";
        username = "f0ldspace";
        passwordFile = "/home/f0ld/.lastfm-password";
      };
    };
  };

  # NOTE: SOFTWARE
  environment.systemPackages = with pkgs; [
    (pkgs.symlinkJoin {
      name = "protonmail-desktop";
      paths = [ pkgs.protonmail-desktop ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/proton-mail \
          --add-flags "--ozone-platform=x11"
      '';
    })
    wget
    jq
    rockbox-utility
    mat2
    # bambu-studio
    qemu
    tor-browser
    libva-utils
    gparted
    ungoogled-chromium
    fd
    ripgrep
    pkgs-pinned.bitwarden-desktop
    # qemu_full
    localsend
    libation
    kdePackages.kdenlive
    exiftool
    (wrapOBS {
      plugins = with obs-studio-plugins; [
        obs-retro-effects
        obs-composite-blur
        advanced-scene-switcher
      ];
    })
    mpd-mpris
    picard
    bleachbit
    protonvpn-gui
    ffmpegthumbnailer
    satty
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    waypaper
    ffmpeg
    joplin-desktop
    runelite
    xclip
    plex-desktop
    yt-dlp
    freetube
    calibre
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
    #TODO: uncomment rclone-ui
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
  networking.firewall.allowedTCPPorts = [ 4096 ];
  networking.firewall.allowedUDPPorts = [ 4096 ];
  networking.firewall.enable = true;
  programs.localsend = {
    enable = true;
    openFirewall = true; # Automatically opens port 53317 (TCP/UDP)
  };
  system.stateVersion = "25.05"; # Did you read the comment?
}
