{
  config,
  pkgs,
  ...
}:

{
  programs.doom-emacs = {
    enable = true;

    # doomDir defaults to the `doomdir` flake input (./doom.d in this repo).
    # doomLocalDir defaults to ~/.local/share/nix-doom.

    # Wayland-native Emacs, for niri/GNOME. Switch to `pkgs.emacs` if you
    # prefer the GTK/X11 build.
    emacs = pkgs.emacs-pgtk;

    # Packages on Emacs' PATH. Defaults are git/ripgrep/fd (Doom needs them);
    # plus the language servers for the +lsp (eglot) modules enabled in doom.d.
    extraBinPackages = with pkgs; [
      git
      ripgrep
      fd
      nil # nix language server
      pyright # python language server
    ];

    # extraPackages = epkgs: [ epkgs.treesit-grammars.with-all-grammars ];
  };
}
