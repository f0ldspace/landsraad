{
  config,
  pkgs,
  username,
  ...
}:

{
  services.restic.backups.trinity = {
    repository = "b2:Trinity-Snapshots";
    paths = [
      "/home/${username}"
      # Databases
      "/var/lib/mysql"
      "/var/lib/postgresql"
      # Self-hosted service state
      "/var/lib/audiobookshelf"
      "/var/lib/navidrome"
      "/var/lib/wakapi"
      "/var/lib/private/wakapi"
      "/var/lib/privatebin"
      # Secrets not in home
      "/etc/cloudflared"
      "/etc/restic"
      "/etc/wakapi"
      "/etc/ntfy"
      "/etc/mediawiki/admin-password"
      # Flatpak apps
      "/var/lib/flatpak"
    ];
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
    ];

    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 6"
    ];

    backupCleanupCommand = ''
      NTFY_TOPIC=$(cat /etc/ntfy/topic)
      ${pkgs.curl}/bin/curl \
        -H "Tags: white_check_mark" \
        -H "Title: Backup complete on $(cat /etc/hostname)" \
        -d "Restic backup finished successfully on $(cat /etc/hostname)." \
        "https://ntfy.sh/$NTFY_TOPIC"
    '';
  };
}
