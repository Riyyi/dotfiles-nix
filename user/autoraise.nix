{ config, pkgs, ... }:

{

  home.file = {
    ".config/AutoRaise/config".text = ''
      delay=0
      focusdelay=1
    '';
  };

}
