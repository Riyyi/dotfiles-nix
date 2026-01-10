{
  config,
  dot,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.zsh;
in
{

  config = lib.mkIf cfg.enable {

    programs.zsh = {
      enable = true;
    };

    environment.shells = lib.mkAfter [ pkgs.zsh ];

    sops.secrets.zshrc-extended = {
      owner = dot.user;
      mode = "0550"; # add execute permissions
      sopsFile = ./../../sops/secrets/zshrc-extended.sh; # from
      key = "data"; # what
      path = "${dot.home}/.config/zsh/.zshrc-extended"; # to
    };

  };

}
