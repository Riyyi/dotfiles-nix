{
  config,
  dot,
  lib,
  ...
}:

let
  cfg = config.features.emacs;
in
{

  options.features.emacs = {
  };

  config = lib.mkIf cfg.enable {

    # home.file.".config/emacs" = {
    #   source = ./dotfiles/.config/emacs;
    # };

    home.activation.emacs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ln -sf ${dot.dotfiles}/modules/home-manager/dotfiles/.config/emacs "$HOME/.config/emacs"
    '';

  };

}
