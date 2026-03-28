{
  config,
  pkgs,
  ...
}:

{
  services.forgejo = {
    enable = true;
    settings = {
      server = {
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 3300;
        ROOT_URL = "https://git.arrakis.computer";
        DOMAIN = "git.arrakis.computer";
      };
    };
  };
}
