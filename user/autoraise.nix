{ config, lib, ... }:

let
  cfg = config.programs.autoraise;
in
{

  options.programs.autoraise = {
    enable = lib.mkEnableOption "autoraise";
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
