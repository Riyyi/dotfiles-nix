{ config, lib, ... }:

{

  options.ghostty = {
    enable = lib.mkEnableOption "ghostty";
  };

  config = lib.mkIf config.ghostty.enable {

    programs.ghostty = {
      enable = true;
      package = null; # installed via homebrew for now
      settings = {
        app-notifications = "no-clipboard-copy";
        confirm-close-surface = false;
        copy-on-select = "clipboard";
        cursor-style-blink = false;
        font-family = "DejaVuSansM Nerd Font Mono";
        font-feature = "-calt, -liga, -dlig"; # disable ligatures
        font-size = 12;
        link-url = true;
        macos-titlebar-style = "hidden";
        selection-invert-fg-bg = true;
        shell-integration-features = "no-cursor";
        term = "xterm-256color";
        theme = "terminal-sexy";
        window-decoration = true;
        window-inherit-working-directory = true;

        keybind = [
          "super+d=unbind"
          "super+t=unbind"
          "super+w=unbind"

          # Neovim fixes:

          # forward command + backtick the <C-6> (Ctrl-^) sequence
          "super+grave_accent=text:\\x1E"
          # make command + h work
          "unconsumed:super+h=text:h"
        ];
      };
      themes = {
        terminal-sexy = {
          palette = [
            "0=#282a2e"
            "1=#a54242"
            "2=#8c9440"
            "3=#de935f"
            "4=#5f819d"
            "5=#85678f"
            "6=#5e8d87"
            "7=#707880"
            "8=#373b41"
            "9=#cc6666"
            "10=#b5bd68"
            "11=#f0c674"
            "12=#81a2be"
            "13=#b294bb"
            "14=#8abeb7"
            "15=#c5c8c6"
          ];

          background = "#1c1c1c";
          foreground = "#c5c8c6";
          cursor-color = "#c5c8c6";
          selection-background = "#373b41";
          selection-foreground = "#c5c8c6";
        };
      };
    };

  };

}
