{
  config,
  pkgs,
  ...
}:

{
  services.mediawiki = {
    enable = true;
    name = "wiki";
    url = "https://wiki.arrakis.computer";
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
      SyntaxHighlight_GeSHi = null;
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

      # Allow anonymous reading, require login to edit
      $wgGroupPermissions['*']['read'] = true;
      $wgGroupPermissions['*']['edit'] = false;
      $wgGroupPermissions['*']['createaccount'] = false;
      $wgGroupPermissions['user']['edit'] = true;
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
