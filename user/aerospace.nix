{ config, pkgs, lib, ... }:

{

  options.aerospace = {
    enable = lib.mkEnableOption "aerospace";
  };

  config = lib.mkIf config.aerospace.enable {

    programs.aerospace = {
      enable = true;
      userSettings = {

        automatically-unhide-macos-hidden-apps = true; # disable macOS "hide application"

        # ------------------------------------
        # Autostart

        start-at-login = true;

        after-startup-command = [ "exec-and-forget sketchybar" ];
        # See: https://nikitabobko.github.io/AeroSpace/commands#exec-and-forget

        # ------------------------------------
        # Events

        on-focus-changed = [ "move-mouse window-lazy-center" ];
        on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];

        exec-on-workspace-change = [ "/bin/zsh" "-c"
          # Notify Sketchybar about workspace change
          "sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
        ];

        # ------------------------------------
        # Look and feel

        # TODO: Figure out the tiling layouts
        # https://www.youtube.com/watch?v=5nwnJjr5eOo
        enable-normalization-flatten-containers = true;
        enable-normalization-opposite-orientation-for-nested-containers = true;
        default-root-container-layout = "tiles";
        default-root-container-orientation = "auto";

        accordion-padding = 60;

        # Unfortunately no smart-gaps
        # https://github.com/nikitabobko/AeroSpace/issues/54
        gaps = {
          inner.horizontal = 16;
          inner.vertical = 16;
          outer.top = 13;
          outer.right = 13;
          outer.bottom = 13;
          outer.left = 13;
        };

        # ------------------------------------
        # Keybindings

        key-mapping.preset = "qwerty";

        mode.main.binding = {

          # ----------------------------------
          # General

          # Open new Ghostty window
          # alt-enter = "exec-and-forget open -n /Applications/Ghostty.app";
          alt-enter = ''
exec-and-forget osascript -e '
tell application "Ghostty"
    if it is running then
        tell application "System Events"
            tell process "Ghostty"
                click menu item "New Window" of menu "File" of menu bar 1
            end tell
        end tell
    else
        activate
    end if
end tell'
          '';
          # See: https://nikitabobko.github.io/AeroSpace/goodness#open-a-new-window-with-applescript

          # ----------------------------------
          # Control

          alt-shift-r = "reload-config";

          # ----------------------------------
          # Node

          # Close and kill focused node
          alt-q = "close --quit-if-last-window";

          # Toggle fullscreen mode
          alt-f = "fullscreen --no-outer-gaps";

          # Toggle tiled/floating
          alt-space = "layout floating tiling";

          # cmd-h = []; # disable "hide application"
          # cmd-alt-h = []; # disable "hide others"

          # ----------------------------------
          # Focus

          # See: https://nikitabobko.github.io/AeroSpace/commands#focus
          alt-h = "focus left";
          alt-j = "focus down";
          alt-k = "focus up";
          alt-l = "focus right";

          # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
          alt-1 = "workspace 一";
          alt-2 = "workspace 二";
          alt-3 = "workspace 三";
          alt-4 = "workspace 四";
          alt-5 = "workspace 五";
          alt-6 = "workspace 六";
          alt-7 = "workspace 七";
          alt-8 = "workspace 八";
          alt-9 = "workspace 九";
          alt-0 = "workspace 十";

          # ----------------------------------
          # Move

          # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
          alt-shift-1 = "move-node-to-workspace 一";
          alt-shift-2 = "move-node-to-workspace 二";
          alt-shift-3 = "move-node-to-workspace 三";
          alt-shift-4 = "move-node-to-workspace 四";
          alt-shift-5 = "move-node-to-workspace 五";
          alt-shift-6 = "move-node-to-workspace 六";
          alt-shift-7 = "move-node-to-workspace 七";
          alt-shift-8 = "move-node-to-workspace 八";
          alt-shift-9 = "move-node-to-workspace 九";
          alt-shift-0 = "move-node-to-workspace 十";

          # Move node to previous/next desktop
          alt-shift-minus = "move-node-to-workspace prev";
          alt-shift-equal = "move-node-to-workspace next";

          # Move nodes around the workspace
          alt-shift-h = "move left";
          alt-shift-j = "move down";
          alt-shift-k = "move up";
          alt-shift-l = "move right";

          # ----------------------------------
          # Resize

          cmd-alt-h = "resize width -50";
          cmd-alt-j = "resize height -50";
          cmd-alt-k = "resize height +50";
          cmd-alt-l = "resize width +50";

          cmd-alt-left  = "resize width -50";
          cmd-alt-down  = "resize height -50";
          cmd-alt-up    = "resize height +50";
          cmd-alt-right = "resize width +50";

          # ----------------------------------
          # Desktop

          # Toggle tiled/accordion layout
          alt-z = "layout tiles accordion";

          # Focus the previous/next desktop on current monitor
          alt-minus = "workspace prev";
          alt-equal = "workspace next";

          # Focus last desktop
          alt-backtick = "workspace-back-and-forth";
        };

        # ------------------------------------
        # Windoes and Workspaces

        workspace-to-monitor-force-assignment = {
          "一" = "main";
          "二" = "main";
          "三" = "main";
          "四" = "main";
          "五" = "main";
          "六" = "main";
          "七" = "main";
          "八" = "main";
          "九"  = "secondary";
          "十"  = "secondary";
        };

      };
    };

    home.activation.aerospace = ''
      if /usr/bin/pgrep -x "aerospace" >/dev/null; then
          ${pkgs.aerospace}/bin/aerospace reload-config
      fi
    '';

  };

}

# Notes:
# - command = ctrl in Linux, basically everything minus ctrl+left and ctrl+right
# - option  = no equivalent, really only does ctrl+left and ctrl+right text actions
# - control = ctrl in linux, but only in the terminal, example: control+L to clear, also does some macOS window manager stuff (spaces, with control+up and control+down)
# https://chatgpt.com/c/684602aa-2560-8007-816a-9432316208e1
#
# option or control seem the best bet?

# TODO:
# - Touchpad gestures scroll workspaces (from goodies)
# - Keybind for screenshots

# FIXME:
# - When fullscreen-ing floating windows, it gets stuck
