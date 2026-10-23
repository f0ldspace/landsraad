{ config, pkgs, lib, ... }:

{
  home.sessionPath = [ "$HOME/.local/bin" ];

  programs.git.enable = true;

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "";
      plugins = [ "per-directory-history" ];
    };
  };
}
