{
  config,
  pkgs,
  ...
}:

{
  services.wakapi = {
    enable = true;
    passwordSalt = "salty";
    settings.server = {
      listen_ipv4 = "127.0.0.1";
      port = 3040;
    };
  };
}
