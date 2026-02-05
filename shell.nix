{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    git
    jq
  ];

  shellHook = ''
    echo "Landsraad bootstrap environment"
    echo "Run ./bootstrap.sh to set up this NixOS configuration"
  '';
}
