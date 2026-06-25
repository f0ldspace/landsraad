{
  config,
  pkgs,
  inputs,
  ...
}:

{

  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    prismlauncher
    bolt-launcher
    osu-lazer-bin
    rusty-path-of-building
  ];
}
