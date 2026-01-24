# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').
{
  config,
  pkgs,
  ...
}:
let
  mkWebApp =
    {
      name,
      url,
      icon,
    }:
    pkgs.makeDesktopItem {
      name = "${name}-app";
      desktopName = name;
      exec = "${pkgs.chromium}/bin/chromium --app=${url}";
      icon = "/home/f0ld/.icons/${icon}";
      categories = [ "Network" ];
    };

  webApps = [
    {
      name = "Lesswrong";
      url = "https://lesswrong.com";
      icon = "lesswrong.png";
    }
    {
      name = "Nix-Search";
      url = "https://search.nixos.org";
      icon = "nix.png";
    }
    {
      name = "godel";
      url = "https://app.godelterminal.com";
      icon = "openrouter.png";
    }
    {
      name = "openrouter";
      url = "https://openrouter.ai/chat";
      icon = "openrouter.png";
    }
    {
      name = "audiobookshelf";
      url = "http://localhost:8000";
      icon = "audiobookshelf.png";
    }
    {
      name = "Fast";
      url = "https://fast.com";
      icon = "fast.png";
    }
    {
      name = "EA Forum";
      url = "https://forum.effectivealtruism.org/";
      icon = "ea.png";
    }
  ];
in
{
  environment.systemPackages = map mkWebApp webApps;
}
