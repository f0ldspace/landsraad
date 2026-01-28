{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.audiobookshelf = {
    enable = true;
    port = 8000; # default is 8000, change if needed
    host = "0.0.0.0"; # or "0.0.0.0" if you want LAN access
    openFirewall = true;
  };

  systemd.services.audiobookshelf.serviceConfig = {
    User = lib.mkForce "f0ld";
    Group = lib.mkForce "users";
    BindReadOnlyPaths = [ "/home/f0ld/Audiobooks" ]; # adjust path
    ProtectHome = lib.mkForce false;
  };
}
