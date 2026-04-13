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
    #inputs.claude-desktop.packages.${pkgs.stdenv.hostPlatform.system}.claude-desktop # broken: uses nodePackages.asar which was removed from nixpkgs
    inputs.mistral-vibe.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
