{ config, lib, ... }:

let
  cfg = config.features.autoraise;
in
{

  options.features.autoraise = {
  };

  config = lib.mkIf cfg.enable {

    home.file = {
      ".config/AutoRaise/config".text = ''
        delay=1
        focusDelay=0
      '';
    };

  };

}
