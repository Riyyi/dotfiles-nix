{ config, pkgs, lib, dot, ... }:

{

  options.hammerspoon = {
    enable = lib.mkEnableOption "hammerspoon";
  };

  config = lib.mkIf config.hammerspoon.enable {

    home.file.".config/hammerspoon/init.lua".text = ''
      local SkyRocket = hs.loadSpoon("SkyRocket")

      local sky = SkyRocket:new({
          opacity = 0.75,
          moveModifiers = { "alt" },
          moveMouseButton = "left",
          resizeModifiers = { "alt" },
          resizeMouseButton = "right",
          focusWindowOnClick = true,
      })

      -- Kill Ghostty when its last window closes
      hs.application.watcher.new(function(appName, eventType, appObject)
          if appName ~= "Ghostty" then return end
          if eventType ~= hs.application.watcher.deactivated then return end

          if #appObject:allWindows() == 0 then
              appObject:kill()
          end
      end):start()
    '';

    home.file.".config/hammerspoon/Spoons/SkyRocket.spoon" = {
      source = pkgs.fetchFromGitHub {
        owner = "dbalatero";
        repo = "SkyRocket.spoon";
        rev = "9f469623773f0f3a6f28c316eb4253f2ac659d2a";
        sha256 = "sha256-U74TD1Q1Rozf9SxtwEr8xcmURm/pmlJknAz3WadtMdI=";
      };
    };

  };

}
