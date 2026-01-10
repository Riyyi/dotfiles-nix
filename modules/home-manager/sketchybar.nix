{
  config,
  lib,
  ...
}:

let
  # cfg = config.programs.sketchybar;
in
{

  options.programs.sketchybar = {
  };

  config = lib.mkIf config.features.sketchybar {

    home.file.".config/sketchybar" = {
      source = ./dotfiles/.config/sketchybar;
      executable = true;
    };

  };

}
