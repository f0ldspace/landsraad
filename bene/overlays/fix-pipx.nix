# pipx 1.14.0 fails its test suite under nixpkgs-unstable's pytest due to a
# `parametrize` strictness change in tests/test_inject.py (test-only, not a
# functional bug). Skip the checkPhase so the package builds.
final: prev: {
  pipx = prev.pipx.overridePythonAttrs (old: {
    doCheck = false;
    doInstallCheck = false;
  });
}
