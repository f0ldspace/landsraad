final: prev: {
  osu-lazer-bin = prev.appimageTools.wrapType2 rec {
    pname = "osu-lazer-bin";
    version = "2026.418.0-lazer";
    src = prev.fetchurl {
      url = "https://github.com/ppy/osu/releases/download/${version}/osu.AppImage";
      hash = "sha256-51zjZ7OxftIKl21d2xCjUhaQMtwyQK6vEGRPTXnqjXU=";
    };
    meta = {
      description = "Rhythm is just a *click* away";
      homepage = "https://osu.ppy.sh";
      mainProgram = "osu-lazer-bin";
    };
  };
}
