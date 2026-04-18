final: prev: {
  osu-lazer-bin = prev.osu-lazer-bin.overrideAttrs (old: rec {
    version = "2026.418.0-lazer";
    src = prev.fetchurl {
      url = "https://github.com/ppy/osu/releases/download/${version}/osu.AppImage";
      hash = "sha256-51zjZ7OxftIKl21d2xCjUhaQMtwyQK6vEGRPTXnqjXU=";
    };
  });
}
