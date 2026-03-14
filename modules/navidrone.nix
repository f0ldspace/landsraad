{
  config,
  pkgs,
  lib,
  username,
  ...
}:

{
  services.navidrome = {
    enable = true;
    openFirewall = true;
    settings = {
      Address = "0.0.0.0";
      Port = 4533;
      MusicFolder = "/home/${username}/Music";
      DataFolder = "/var/lib/navidrome";
      CacheFolder = "/var/lib/navidrome/cache";
    };
  };

  systemd.services.navidrome.serviceConfig = {
    User = lib.mkForce username;
    Group = lib.mkForce "users";
    BindReadOnlyPaths = [ "/home/${username}/Music" ];
    ProtectHome = lib.mkForce false;
  };
}
