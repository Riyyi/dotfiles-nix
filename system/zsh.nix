{ dot, ... }:

{

  sops.secrets."zshrc-extended" = {
    owner = dot.user;
  };

}
