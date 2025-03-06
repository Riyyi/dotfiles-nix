{ config, pkgs, ... }:

{

  programs.git = {
    enable = true;
    userName = "Riyyi";
    userEmail = "riyyi3@gmail.com";
    extraConfig = {
      core = {
        pager = "less -x 1,5";
      };
      init = {
        defaultBranch = "master";
      };
    };
  };

}
