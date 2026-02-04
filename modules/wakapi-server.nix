{
  config,
  pkgs,
  ...
}:

{
  services.wakapi = {
    enable = true;
    # Create this file with: WAKAPI_PASSWORD_SALT=your_salt
    environmentFiles = [ "/etc/wakapi/secrets.env" ];
    settings.server = {
      listen_ipv4 = "127.0.0.1";
      port = 3040;
    };
  };
}
