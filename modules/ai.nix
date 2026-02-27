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
  ];
}
