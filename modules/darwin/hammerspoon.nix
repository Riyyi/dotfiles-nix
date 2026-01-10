{ config, lib, ... }:

let
  cfg = config.features.hammerspoon;
in
{

  config = lib.mkIf cfg.enable {

    system.defaults = {
      CustomUserPreferences = {
        "org.hammerspoon.Hammerspoon" = {
          MJConfigFile = "~/.config/hammerspoon/init.lua";
        };
      };
    };

  };

}
