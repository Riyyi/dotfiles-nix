{
  inputs,
  ...
}:

{
  flake = {

    # ==================================== #
    # Overlays #

    # Custom modifications/overrides to upstream packages
    overlays = import ../../overlays { inherit inputs; };

  };
}
