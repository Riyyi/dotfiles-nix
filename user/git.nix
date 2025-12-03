{ config, lib, ... }:

{

  options.git = {
    enable = lib.mkEnableOption "git";
  };

  config = lib.mkIf config.git.enable {

    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "Riyyi";
          email = "riyyi3@gmail.com";
        };
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
