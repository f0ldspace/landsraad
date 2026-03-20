{
  config,
  pkgs,
  lib,
  username,
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
    User = lib.mkForce username;
    Group = lib.mkForce "users";
    BindPaths = [
      "/home/${username}/Podcasts"
    ];
    BindReadOnlyPaths = [
      "/home/${username}/Audiobooks"
    ];
    ProtectHome = lib.mkForce false;
  };
}
