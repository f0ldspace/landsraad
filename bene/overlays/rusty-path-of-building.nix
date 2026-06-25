final: prev: {
  rusty-path-of-building = prev.rustPlatform.buildRustPackage rec {
    pname = "rusty-path-of-building";
    version = "0.2.18";

    src = prev.fetchFromGitHub {
      owner = "meehl";
      repo = "rusty-path-of-building";
      rev = "6b6098d3319dd9645532b77dcbca9322cd3966af";
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };

    cargoHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

    nativeBuildInputs = with prev; [
      pkg-config
      luajit
    ];

    buildInputs = with prev; [
      luajit
      openssl
      libxkbcommon
      wayland
      vulkan-loader
      libGL
    ];

    env = {
      LUAJIT_LIB = "${prev.luajit}/lib";
      LUAJIT_INC = "${prev.luajit}/include";
    };

    meta = {
      description = "Cross-platform runtime for Path of Building";
      homepage = "https://github.com/meehl/rusty-path-of-building";
      license = prev.lib.licenses.mit;
      mainProgram = "rusty-path-of-building";
    };
  };
}
