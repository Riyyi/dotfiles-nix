{ config, lib, ... }:

let
  cfg = config.programs.git;
in
{

  options.programs.git = {
  };

  config = lib.mkIf cfg.enable {

    programs.git = {
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
