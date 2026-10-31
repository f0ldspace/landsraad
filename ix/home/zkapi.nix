{ inputs, ... }:

{
  imports = [ inputs.zkapi-clientd.homeManagerModules.default ];

  # Local OpenAI-compatible proxy (http://127.0.0.1:8787/v1) that fronts a
  # prepaid zkAPI wallet. Point Open WebUI / any OpenAI client at that URL.
  #
  # The wallet profile is NOT managed by Nix: create it once, as f0ld, with
  #   zkapi-clientd config
  # It lives in ~/.config/zkapi-clientd (mode 0700) and is never in the store.
  # The unit's ConditionPathExists keeps it stopped until config.json exists.
  services.zkapi-clientd = {
    enable = true;
    startAtLogin = true;
  };
}
