{
  config,
  pkgs,
  inputs,
  ...
}:

{

  programs.steam.enable = true;
  environment.systemPackages = with pkgs; [
    gamescope
    prismlauncher
    osu-lazer
    openspeedrun
  ];
}
