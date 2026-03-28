{
  config,
  pkgs,
  ...
}:

{
  services.searx = {
    enable = true;
    # Create this file with: SEARX_SECRET_KEY=$(openssl rand -hex 32)
    environmentFile = "/etc/searxng/secrets.env";
    settings.server = {
      port = 8888;
      bind_address = "0.0.0.0";
      secret_key = "@SEARX_SECRET_KEY@";
    };
    settings.search.formats = [
      "html"
      "json"
    ];
  };
}
