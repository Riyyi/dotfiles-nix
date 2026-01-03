{
  config,
  pkgs,
  lib,
  ...
}:

let
  aerospace-pkg = pkgs.unstable.aerospace;
  autoraise = "${pkgs.autoraise}/bin/autoraise";
  sketchybar = "${pkgs.sketchybar}/bin/sketchybar";
  sketchybar-trigger = "exec-and-forget ${sketchybar} --trigger aerospace_workspace_change";
in
{

  options.aerospace = {
    enable = lib.mkEnableOption "aerospace";
  };

  config = lib.mkIf config.aerospace.enable {

    programs.aerospace = {
      enable = true;
      package = aerospace-pkg;

      userSettings = {

        automatically-unhide-macos-hidden-apps = true; # disable macOS "hide application"

        # ------------------------------------
        # Autostart

        start-at-login = true;

        after-startup-command = [
          "exec-and-forget ${autoraise}"
          "exec-and-forget ${sketchybar}"
          "exec-and-forget open -g -a /Applications/Hammerspoon.app"
        ];
        # See: https://nikitabobko.github.io/AeroSpace/commands#exec-and-forget

        # ------------------------------------
        # Events

        on-focus-changed = [ "move-mouse window-lazy-center" ];
        on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];

        exec-on-workspace-change = [
          "${pkgs.zsh}/bin/zsh"
          "-c"
          # Notify Sketchybar about workspace change
          "${sketchybar} --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
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

          # Combine windows into common parent container
          alt-cmd-ctrl-h = "join-with left";
          alt-cmd-ctrl-j = "join-with down";
          alt-cmd-ctrl-k = "join-with up";
          alt-cmd-ctrl-l = "join-with right";

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
          alt-shift-1 = [
            "move-node-to-workspace 一"
            sketchybar-trigger
          ];
          alt-shift-2 = [
            "move-node-to-workspace 二"
            sketchybar-trigger
          ];
          alt-shift-3 = [
            "move-node-to-workspace 三"
            sketchybar-trigger
          ];
          alt-shift-4 = [
            "move-node-to-workspace 四"
            sketchybar-trigger
          ];
          alt-shift-5 = [
            "move-node-to-workspace 五"
            sketchybar-trigger
          ];
          alt-shift-6 = [
            "move-node-to-workspace 六"
            sketchybar-trigger
          ];
          alt-shift-7 = [
            "move-node-to-workspace 七"
            sketchybar-trigger
          ];
          alt-shift-8 = [
            "move-node-to-workspace 八"
            sketchybar-trigger
          ];
          alt-shift-9 = [
            "move-node-to-workspace 九"
            sketchybar-trigger
          ];
          alt-shift-0 = [
            "move-node-to-workspace 十"
            sketchybar-trigger
          ];

          # Move node to previous/next desktop
          alt-shift-minus = [
            "move-node-to-workspace prev"
            sketchybar-trigger
          ];
          alt-shift-equal = [
            "move-node-to-workspace next"
            sketchybar-trigger
          ];

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

          cmd-alt-left = "resize width -50";
          cmd-alt-down = "resize height -50";
          cmd-alt-up = "resize height +50";
          cmd-alt-right = "resize width +50";

          # ----------------------------------
          # Desktop

          # Toggle tiled/accordion layout
          alt-z = "layout h_tiles h_accordion";
          alt-v = "layout v_tiles v_accordion";

          # Focus the previous/next desktop on current monitor
          alt-minus = "exec-and-forget printf 一\\\\n二\\\\n三\\\\n四\\\\n五\\\\n六\\\\n七\\\\n八\\\\n九\\\\n十\\\\n | ${aerospace-pkg}/bin/aerospace workspace prev";
          alt-equal = "exec-and-forget printf 一\\\\n二\\\\n三\\\\n四\\\\n五\\\\n六\\\\n七\\\\n八\\\\n九\\\\n十\\\\n | ${aerospace-pkg}/bin/aerospace workspace next";

          # Focus last desktop
          alt-backtick = "workspace-back-and-forth";
        };

        # ------------------------------------
        # Windows and Workspaces

        # $ aeropace list-apps
        on-window-detected = [
          # Set to floating
          {
            "if".app-id = "io.mpv";
            check-further-callbacks = true;
            run = [ "layout floating" ]; # the callback itself
          }
        ];

        # Put workspaces on specific monitors
        workspace-to-monitor-force-assignment = {
          "一" = "main";
          "二" = "main";
          "三" = "main";
          "四" = "main";
          "五" = "main";
          "六" = "main";
          "七" = "main";
          "八" = "main";
          "九" = "secondary";
          "十" = "secondary";
        };

      };
    };

    home.activation.aerospace = ''
      if /usr/bin/pgrep -x "aerospace" >/dev/null; then
          ${aerospace-pkg}/bin/aerospace reload-config
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
