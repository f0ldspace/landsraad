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
  ];
}
