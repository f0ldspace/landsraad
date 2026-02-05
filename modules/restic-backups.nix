{
  config,
  pkgs,
  ...
}:

{
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
}
