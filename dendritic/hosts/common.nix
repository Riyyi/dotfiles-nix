let
  module = "hosts-common";
in
{

  # ====================================== #
  # Common #

  flake.modules.generic.${module} =
    {
      config,
      lib,
      outputs,
      ...
    }:
    {

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
