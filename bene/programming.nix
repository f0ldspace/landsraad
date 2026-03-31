{
  config,
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    git
    lazygit
    gh
    vscodium-fhs
    python3
    pipx
    nodejs_24
    godot_4
  ];
}
