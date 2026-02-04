{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.audiobookshelf = {
    enable = true;
    port = 8000;
    host = "0.0.0.0";
    openFirewall = true;
  };

  systemd.services.audiobookshelf.serviceConfig = {
    User = lib.mkForce "f0ld";
    Group = lib.mkForce "users";
    BindPaths = [
      "/home/f0ld/Podcasts"
    ];
    BindReadOnlyPaths = [
      "/home/f0ld/Audiobooks"
    ];
    ProtectHome = lib.mkForce false;
  };
}
