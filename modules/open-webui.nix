{
  config,
  pkgs,
  ...
}:

{
  services.open-webui = {
    enable = true;
    host = "127.0.0.1";
    port = 3050;
    environment = {
      ANONYMIZED_TELEMETRY = "False";
      OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
    };
  };
}
