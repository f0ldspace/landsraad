{
  config,
  pkgs,
  ...
}:

{
  services.cloudflared = {
    enable = true;
    tunnels = {
      "46996347-59ea-48ed-a499-8632e9097567" = {
        credentialsFile = "/etc/cloudflared/46996347-59ea-48ed-a499-8632e9097567.json";
        default = "http_status:404";
        ingress = {
          "audiobookshelf.arrakis.computer" = "http://localhost:8000";
          "wiki.arrakis.computer" = "http://localhost:8080";
          "tasks.arrakis.computer" = "http://localhost:7331";
          "paste.arrakis.computer" = "http://localhost:8443";
          "miniflux.arrakis.computer" = "http://localhost:8085";
          "chat.arrakis.computer" = "http://localhost:3050";
          "git.arrakis.computer" = "http://localhost:3300";
        };
      };
    };
  };
}
