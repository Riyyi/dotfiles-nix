{
  config,
  dot,
  lib,
  pkgs,
  ...
}:

{

  config = lib.mkIf config.features.zsh {

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
