{ config, lib, ... }:

let
  # cfg = config.programs.git;
in
{

  options.programs.git = {
  };

  config = lib.mkIf config.features.git {

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
