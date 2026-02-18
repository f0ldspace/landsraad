{
  config,
  pkgs,
  ...
}:

{
  services.miniflux = {
    enable = true;
    config = {
      LISTEN_ADDR = "127.0.0.1:8085";
    };
    # Create this file with:
    # ADMIN_USERNAME=admin
    # ADMIN_PASSWORD=your_password (must be >= 6 chars)
    adminCredentialsFile = "/etc/miniflux/admin-credentials.env";
  };
}
