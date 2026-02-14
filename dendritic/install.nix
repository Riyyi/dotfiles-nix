{
  lib,
  rootPath,
  ...
}:

{

  # ==================================== #
  # Other #

  perSystem =
    { system, pkgs, ... }:
    let
      installPkg = pkgs.writeShellApplication {
        name = "install";
        runtimeInputs = with pkgs; [ git ];
        text = builtins.readFile "${rootPath}/install.sh";
      };
    in
    {
      packages = lib.optionalAttrs (system == "x86_64-linux") {
        install = installPkg;
        default = installPkg;
      };

      apps = lib.optionalAttrs (system == "x86_64-linux") {
        install = {
          type = "app";
          program = "${installPkg}/bin/install";
        };
        default = {
          type = "app";
          program = "${installPkg}/bin/install";
        };
      };
    };

}
