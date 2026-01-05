{
  config,
  lib,
  ...
}:

let
  cfg = config.programs.sketchybar;
in
{

  options.programs.sketchybar = {
  };

  config = lib.mkIf cfg.enable {

    home.file.".config/sketchybar" = {
      source = ./dotfiles/.config/sketchybar;
      executable = true;
    };

  };

}
