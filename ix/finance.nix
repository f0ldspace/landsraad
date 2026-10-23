{
  config,
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    portfolio
    inputs.railoxide.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
