# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').
{
  config,
  pkgs,
  username,
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
      exec = "appimage-run appimages/helium.AppImage --app=${url}";
      icon = "/home/${username}/.icons/${icon}";
      categories = [ "Network" ];
    };

  webApps = [
    {
      name = "Cryptee";
      url = "https://crypt.ee/home";
      icon = "crypt.png";
    }
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
      name = "openrouter";
      url = "https://openrouter.ai/chat";
      icon = "openrouter.png";
    }
    {
      name = "audiobookshelf";
      url = "https://audiobookshelf.arrakis.computer";
      icon = "audiobookshelf.png";
    }
    {
      name = "EA Forum";
      url = "https://forum.effectivealtruism.org/";
      icon = "ea.png";
    }
    {
      name = "mistral-le-chat";
      url = "https://chat.mistral.ai/chat";
      icon = "mistral.png";
    }
  ];
in
{
  environment.systemPackages = map mkWebApp webApps;
}
