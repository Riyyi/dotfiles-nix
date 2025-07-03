{ config, pkgs, ... }:

{

  programs.aerospace = {
    enable = true;
    userSettings = {
      start-at-login = true;

      automatically-unhide-macos-hidden-apps = true; # disable macOS "hide application"

      on-focus-changed = [ "move-mouse window-lazy-center" ];
      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];

      # ------------------------------------
      # Look and feel

      accordion-padding = 30;

      # Unfortunately no smart gaps
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

	# See: https://nikitabobko.github.io/AeroSpace/commands#exec-and-forget
        alt-enter = "exec-and-forget open -n /Applications/Ghostty.app";

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

        cmd-h = []; # disable "hide application"
        cmd-alt-h = []; # disable "hide others"

	# ----------------------------------
	# Focus

        # See: https://nikitabobko.github.io/AeroSpace/commands#focus
        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";

        # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-5 = "workspace 5";
        alt-6 = "workspace 6";
        alt-7 = "workspace 7";
        alt-8 = "workspace 8";
        alt-9 = "workspace 9";
        alt-0 = "workspace 0";

	# ----------------------------------
	# Move

        # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";
        alt-shift-5 = "move-node-to-workspace 5";
        alt-shift-6 = "move-node-to-workspace 6";
        alt-shift-7 = "move-node-to-workspace 7";
        alt-shift-8 = "move-node-to-workspace 8";
        alt-shift-9 = "move-node-to-workspace 9";
        alt-shift-0 = "move-node-to-workspace 0";

	# ----------------------------------
	# Desktop

        # Toggle tiled/accordion layout
        alt-z = "layout tiles accordion";

        # Focus last desktop
        alt-backtick = "workspace-back-and-forth";
      };
    };
  };

}

# Notes:
# - command = ctrl in Linux, basically everything minus ctrl+left and ctrl+right
# - option  = no equivalent, really only does ctrl+left and ctrl+right text actions
# - control = ctrl in linux, but only in the terminal, example: control+L to clear, also does some macOS window manager stuff (spaces, with control+up and control+down)
# https://chatgpt.com/c/684602aa-2560-8007-816a-9432316208e1
#
# option or control seem the best bet?
