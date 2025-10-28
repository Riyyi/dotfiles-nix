{ config, lib, ... }:

{

  options.autoraise = {
    enable = lib.mkEnableOption "autoraise";
  };

  config = lib.mkIf config.autoraise.enable {

    home.file = {
      ".config/AutoRaise/config".text = ''
        delay=1
        focusDelay=0
      '';
    };

  };

}
