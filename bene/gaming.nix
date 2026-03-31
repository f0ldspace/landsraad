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
    osu-lazer-bin
  ];
}
