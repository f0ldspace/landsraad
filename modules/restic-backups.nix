{
  config,
  pkgs,
  username,
  ...
}:

{
  services.restic.backups.trinity = {
    repository = "b2:Trinity-Snapshots";
    paths = [ "/home/${username}" ];
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
