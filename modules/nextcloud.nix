{
  config,
  pkgs,
  ...
}:

{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud32;
    hostName = "nextcloud";

    config = {
      # Create this file with: echo "your-secure-password" | sudo tee /etc/nextcloud/admin-pass
      adminpassFile = "/etc/nextcloud/admin-pass";
      adminuser = "admin";
      dbtype = "sqlite";
    };

    maxUploadSize = "1G";
  };

  # Access at localhost:8090
  services.nginx.virtualHosts."nextcloud" = {
    listen = [
      {
        addr = "127.0.0.1";
        port = 8090;
      }
    ];
  };
}
