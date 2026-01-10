{ config, lib, ... }:

let
  # cfg = config.programs.autoraise;
in
{

  options.programs.autoraise = {
  };

  config = lib.mkIf config.features.autoraise {

    home.file = {
      ".config/AutoRaise/config".text = ''
        delay=1
        focusDelay=0
      '';
    };

  };

}
