{
  config,
  lib,
  ...
}:

let
  cfg = config.features.sketchybar;
in
{

  options.features.sketchybar = {
  };

  config = lib.mkIf cfg.enable {

    home.file.".config/sketchybar" = {
      source = ./dotfiles/.config/sketchybar;
      executable = true;
    };

  };

}
