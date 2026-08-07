{
  config,
  pkgs,
  ...
}:

{
  services.owncast = {
    enable = true;
    # Web UI bound to localhost; expose via cloudflared tunnel.
    listen = "127.0.0.1";
    port = 7311;
    # RTMP ingest port must be reachable from the streaming client (e.g. OBS).
    rtmp-port = 1935;
    openFirewall = true;
  };
}
