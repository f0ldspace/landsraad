final: prev: {
  railway-wallet = prev.appimageTools.wrapType2 rec {
    pname = "railway-wallet";
    version = "5.24.13";
    src = prev.fetchurl {
      url = "https://github.com/Railway-Wallet/Railway-Wallet/releases/download/v${version}/Railway.linux.x86_64.AppImage";
      hash = "sha256-e1itj0wxlX2WqyDynxBeLi06bzxwz2/cR9RuOfCLxF8=";
    };
    meta = {
      description = "Private DeFi wallet for Linux";
      homepage = "https://www.railway.xyz";
      license = prev.lib.licenses.agpl3Only;
      maintainers = with prev.lib.maintainers; [ mitchmindtree ];
      platforms = [ "x86_64-linux" ];
    };
  };
}
