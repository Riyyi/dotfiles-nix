{ config, lib, ... }:

{

  config = lib.mkIf config.features.hammerspoon {

    system.defaults = {
      CustomUserPreferences = {
        "org.hammerspoon.Hammerspoon" = {
          MJConfigFile = "~/.config/hammerspoon/init.lua";
        };
      };
    };

  };

}
