{ dot, ... }:

{

  sops.secrets.zshrc-extended = {
    owner = dot.user;
    mode = "0550"; # add execute permissions
    sopsFile = ./../sops/secrets/zshrc-extended.sh; # from
    key = "data"; # what
    path = "/Users/${dot.user}/.config/zsh/.zshrc-extended"; # to
  };

}
