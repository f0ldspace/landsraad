{
  config,
  pkgs,
  lib,
  ...
}:

{
  services.navidrome = {
    enable = true;
    openFirewall = true;
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
}
