{ inputs, ... }:

let
  overlays = {

    autoraise = (import ./autoraise.nix);

    firefox-addons = inputs.firefox-addons.overlays.default;

    soundsource = (import ./soundsource.nix);

    unstable-packages = final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        system = final.stdenv.hostPlatform.system;
        config.allowUnfree = true;
        overlays = [ ];
      };
    };

  };

  lib = inputs.nixpkgs.lib;
in
{
  default =
    final: prev:
    lib.attrNames overlays
    |> map (name: (overlays.${name} final prev)) # nixfmt hack
    |> lib.mergeAttrsList;
}
