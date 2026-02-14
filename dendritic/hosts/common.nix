{
  inputs,
  lib,
  outputs,
  toby, #???
  ...
}:

let
  module = "host-common";
in
{

  # ====================================== #
  # Common #

  flake.modules.generic.${module} = {

    # Overlays
    # nixpkgs.overlays = lib.mkAfter [
    #   outputs.overlays.default
    # ];
    #
    # # Nix settings
    # nix = {
    #   settings.experimental-features = [
    #     "nix-command"
    #     "flakes"
    #     "pipe-operators"
    #   ]; # enable flakes
    #   optimise.automatic = true; # store optimizer on a daily timer
    # };

  };

  # ====================================== #
  # NixOS #

  flake.modules.nixos.${module} = {
  };

  # ====================================== #
  # Darwin #

  flake.modules.darwin.${module} = {
  };
}
