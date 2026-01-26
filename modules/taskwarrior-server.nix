{
  config,
  pkgs,
  ...
}:

{
  services.taskchampion-sync-server = {
    enable = true;
    port = 7331;
  };
}
