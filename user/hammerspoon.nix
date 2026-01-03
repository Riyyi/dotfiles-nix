{
  config,
  pkgs,
  lib,
  ...
}:

{

  options.hammerspoon = {
    enable = lib.mkEnableOption "hammerspoon";
  };

  config = lib.mkIf config.hammerspoon.enable {

    home.file.".config/hammerspoon/init.lua".text = ''

      -- enable IPC for CLI usage
      -- https://www.hammerspoon.org/docs/hs.ipc.html
      -- require("hs.ipc")

      -- local SkyRocket = hs.loadSpoon("SkyRocket")
      --
      -- local sky = SkyRocket:new({
      --     opacity = 0.75,
      --     moveModifiers = { "alt" },
      --     moveMouseButton = "left",
      --     resizeModifiers = { "alt" },
      --     resizeMouseButton = "right",
      --     focusWindowOnClick = true,
      -- })

      -- Kill Ghostty when its last window closes
      -- hs.application.watcher.new(function(appName, eventType, appObject)
      --     if appName ~= "Ghostty" then return end
      --     if eventType ~= hs.application.watcher.deactivated then return end
      --
      --     if #appObject:allWindows() == 0 then
      --         appObject:kill()
      --     end
      -- end):start()

      -- Update SketchyBar Aerospace workspaces
      local wf = hs.window.filter.new()
      wf:subscribe(
        {
            hs.window.filter.windowCreated,
            hs.window.filter.windowDestroyed,
        },
        function()
            hs.task.new("${pkgs.sketchybar}/bin/sketchybar", nil,
                { "--trigger", "aerospace_workspace_change" }):start()
        end)

      -- Open new Ghostty window
      -- hs.hotkey.bind({"alt"}, "return", function()
      --     local app = hs.application.find("Ghostty")
      --     if not app then
      --         hs.application.launchOrFocus("Ghostty")
      --     else
      --         app:selectMenuItem({"File", "New Window"})
      --     end
      -- end)
    '';

    home.file.".config/hammerspoon/Spoons/SkyRocket.spoon" = {
      source = pkgs.fetchFromGitHub {
        owner = "dbalatero";
        repo = "SkyRocket.spoon";
        rev = "9f469623773f0f3a6f28c316eb4253f2ac659d2a";
        sha256 = "sha256-U74TD1Q1Rozf9SxtwEr8xcmURm/pmlJknAz3WadtMdI=";
      };
    };

    # home.activation.hammerspoon = ''
    #   /opt/homebrew/bin/hs -c "hs.reload()"
    # '';

  };

}
