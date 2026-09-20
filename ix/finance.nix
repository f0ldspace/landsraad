{
  config,
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    trezor-suite
    portfolio
    inputs.railoxide.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
