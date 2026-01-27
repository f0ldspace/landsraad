{
  config,
  pkgs,
  ...
}:

{
  services.taskchampion-sync-server = {
    enable = true;
    port = 7331;
    host = "0.0.0.0";
    openFirewall = true;
  };
}
