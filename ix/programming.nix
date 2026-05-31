{
  config,
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    neovim
    tokei
    lazygit
    git
    bc
    signal-cli
    gh
    #android-studio
    vscodium-fhs
    python3
    wakatime-cli
    #zellij
    #NOTE: Temp pipx
    rustc
    cargo
    cargo-ui
    nodejs_24
    rust-analyzer
    #marp-cli
    #markdownlint-cli # nodePackages removed from nixpkgs
    #markdownlint-cli2 # nodePackages removed from nixpkgs
  ];
}
