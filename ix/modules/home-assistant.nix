{
  config,
  pkgs,
  ...
}:

{
  services.home-assistant = {
    enable = true;

    extraComponents = [
      "met"
      "radio_browser"
      "isal"
      "esphome"
      "zha"
      "aranet"
      "tplink"
      "tradfri"
      "matter"
      "tailscale"
    ];

    config = {
      default_config = {};

      homeassistant = {
        name = "Home";
        unit_system = "metric";
        time_zone = "Europe/London";
      };

      http = {
        server_host = "127.0.0.1";
        server_port = 8123;
      };
    };
  };
}
