{ config, lib, ... }:

{

  options.git = {
    enable = lib.mkEnableOption "git";
  };

  config = lib.mkIf config.git.enable {

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

  };

}
