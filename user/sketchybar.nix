{
  config,
  pkgs,
  lib,
  dot,
  ...
}:

{

  options.sketchybar = {
    enable = lib.mkEnableOption "sketchybar";
  };

  config = lib.mkIf config.sketchybar.enable {

    home.file.".config/sketchybar" = {
      source = ./dotfiles/.config/sketchybar;
      executable = true;
    };

  };

}
