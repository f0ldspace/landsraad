{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:
let
  # Must match your configuration.nix llama-cpp exactly so Nix reuses it (no 2nd build)
  llamaCpp = pkgs-unstable.llama-cpp.override { vulkanSupport = true; };
in
{
  environment.systemPackages = with pkgs; [
    vulkan-tools
    opencode
  ];

  services.llama-swap = {
    enable = true;
    listenAddress = "127.0.0.1"; # local only; Pi is on the same box
    port = 8080;
    settings.models."qwen3.8-27b" = {
      cmd = ''
        ${llamaCpp}/bin/llama-server
        -hf unsloth/Qwen3.8-27B-GGUF:UD-Q4_K_XL
        --port ''${PORT}
        --jinja -fa on -c 0
      '';
      ttl = 1800; # unload after 30 min idle
    };
  };

  # Let the hardened DynamicUser service actually reach the iGPU
  systemd.services.llama-swap.serviceConfig = {
    SupplementaryGroups = [
      "render"
      "video"
    ];
    MemoryDenyWriteExecute = lib.mkForce false;

    StateDirectory = "llama-swap"; # -> /var/lib/llama-swap
    Environment = [
      "HOME=/var/lib/llama-swap"
      "HF_HOME=/var/lib/llama-swap/huggingface"
      "LLAMA_CACHE=/var/lib/llama-swap/huggingface/hub"
      "XDG_CACHE_HOME=/var/lib/llama-swap/.cache"
    ];
  };
}
