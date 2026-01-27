{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./finance.nix
    ./productivity.nix
    ./websites.nix
    # Shared modules
    ../../modules/programming.nix
    ../../modules/taskwarrior-server.nix
    # Desktop environments (both available, choose at login)
    ../../modules/desktop/gnome.nix
    ../../modules/desktop/niri.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  hardware.keyboard.qmk.enable = true;
  services.udev.extraRules = ''
    # Via/QMK keyboard access
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';

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
  # Wiki.js
  #  services.postgresql = {
  #  enable = true;
  # ensureDatabases = [ "wiki-js" ];
  # ensureUsers = [
  #   {
  #     name = "wiki-js";
  #     ensureDBOwnership = true;
  #   }
  # ];
  #};

  #services.wiki-js = {
  # enable = true;
  # settings.db = {
  #   type = "postgres";
  #   host = "/run/postgresql";
  #   db = "wiki-js";
  #   user = "wiki-js";
  # };
  #};

  #systemd.services.wiki-js = {
  # requires = [ "postgresql.service" ];
  # after = [ "postgresql.service" ];
  #};

  services.wakapi = {
    enable = true;
    passwordSalt = "salty";
    settings.server = {
      listen_ipv4 = "127.0.0.1";
      port = 3040;
    };
  };

  services.mpd = {
    enable = true;
    musicDirectory = "/home/f0ld/Music";
    user = "f0ld";
    playlistDirectory = "/home/f0ld/Music";
    settings.audio_output = [
      {
        type = "pipewire";
        name = "PipeWire Output";
      }
    ];
  };

  services.navidrome = {
    enable = true;
    settings = {
      Address = "0.0.0.0";
      Port = 4533;
      MusicFolder = "/home/f0ld/Music";
    };
  };

  systemd.services.navidrome.serviceConfig = {
    User = lib.mkForce "f0ld";
    Group = lib.mkForce "users";
    BindReadOnlyPaths = [ "/home/f0ld/Music" ];
    ProtectHome = lib.mkForce false;
  };

  services.audiobookshelf = {
    enable = true;
    port = 8000; # default is 8000, change if needed
    host = "0.0.0.0"; # or "0.0.0.0" if you want LAN access
  };

  systemd.services.audiobookshelf.serviceConfig = {
    User = lib.mkForce "f0ld";
    Group = lib.mkForce "users";
    BindReadOnlyPaths = [ "/home/f0ld/Audiobooks" ]; # adjust path
    ProtectHome = lib.mkForce false;
  };

  networking.firewall.allowedTCPPorts = [
    4533
    8000
  ];
  systemd.services.mpd.environment = {
    XDG_RUNTIME_DIR = "/run/user/1000";
  };

  services.restic.backups.trinity = {
    repository = "b2:Trinity-Snapshots";
    paths = [ "/home/f0ld" ];
    environmentFile = "/etc/restic/b2-env";
    passwordFile = "/etc/restic/password";

    timerConfig = {
      OnCalendar = "daily";
      Persistent = true; # runs missed backups after sleep/shutdown
    };

    exclude = [
      ".cache"
      "node_modules"
      ".local/share/Trash"
      "Downloads"
      "Audiobooks"
    ];

    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 6"
    ];
  };
  # services.xserver.libinput.enable = true;

  users.users.f0ld = {
    isNormalUser = true;
    description = "f0ldspace";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
    ];
  };
  programs.firefox.enable = true;
  programs.steam.enable = true;
  nixpkgs.config.allowUnfree = true;
  environment.variables.EDITOR = "trinity";
  services.flatpak.enable = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # NOTE: SOFTWARE
  environment.systemPackages = with pkgs; [
    protonmail-desktop
    wget
    openspeedrun
    jq
    mat2
    ungoogled-chromium
    fd
    ripgrep
    bitwarden-desktop
    localsend
    libation
    exiftool
    lunar-client
    prismlauncher
    wakatime-cli
    obs-studio
    mpd-mpris
    zellij
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
    inputs.claude-desktop.packages.${system}.claude-desktop
    cryptomator
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    (pkgs.writeShellScriptBin "trinity" ''
      exec ${inputs.trinity.packages.${pkgs.system}.default}/bin/nvim "$@"
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
