{
  config,
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    claude-code
    claude-monitor
    vulkan-tools
    opencode
    inputs.claude-desktop.packages.${pkgs.stdenv.hostPlatform.system}.claude-desktop
    inputs.mistral-vibe.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
