{
  config,
  pkgs,
  ...
}:

{
  services.mediawiki = {
    enable = true;
    name = "Landsraad";
    url = "http://localhost:8080";
    # Create this file with: echo "your-secure-password" | sudo tee /etc/mediawiki/admin-password
    # Admin username is "admin"
    passwordFile = "/etc/mediawiki/admin-password";

    database = {
      type = "mysql";
      # createLocally = true is the default for mysql
      # Automatically enables MariaDB and creates the database + user
    };

    webserver = "nginx";
    nginx.hostName = "localhost";

    extensions = {
      VisualEditor = null;
      ParserFunctions = null;
      Cite = null;
      CategoryTree = null;
      InputBox = null;
    };

    extraConfig = ''
      # Enable VisualEditor by default for all users
      $wgDefaultUserOptions['visualeditor-enable'] = 1;

      # Allow file uploads
      $wgEnableUploads = true;
    '';
  };

  # Serve on port 8080
  services.nginx.virtualHosts."localhost" = {
    listen = [
      {
        addr = "127.0.0.1";
        port = 8080;
      }
    ];
  };
}
