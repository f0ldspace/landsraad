{
  config,
  pkgs,
  ...
}:

{
  services.privatebin = {
    enable = true;
    enableNginx = true;
    virtualHost = "paste.local";
    settings = {
      main = {
        name = "paste";
        discussion = true;
        opendiscussion = false;
        burnafterreading = true;
        defaultformatter = "syntaxhighlighting";
      };
      expire = {
        default = "1week";
      };
      expire_options = {
        "5min" = 300;
        "10min" = 600;
        "1hour" = 3600;
        "1day" = 86400;
        "1week" = 604800;
        "1month" = 2592000;
        "1year" = 31536000;
        "never" = 0;
      };
    };
  };

  services.nginx.virtualHosts."paste.local" = {
    listen = [
      {
        addr = "127.0.0.1";
        port = 8443;
      }
    ];
  };
}
