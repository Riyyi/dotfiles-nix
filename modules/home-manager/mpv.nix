{
  config,
  lib,
  ...
}:

let
  cfg = config.features.mpv;
in
{

  options.features.mpv = {
  };

  config = lib.mkIf cfg.enable {

    # TODO: Change this to nix syntax
    home.file = {
      ".config/mpv/mpv.conf".source = ./dotfiles/.config/mpv/mpv.conf;
      ".config/mpv/input.conf".source = ./dotfiles/.config/mpv/input.conf;
      ".config/mpv/scripts/playlist.lua".source = ./dotfiles/.config/mpv/scripts/playlist.lua;
      ".config/mpv/script-opts/osc.conf".source = ./dotfiles/.config/mpv/script-opts/osc.conf;
    };

  };

}
