{ config, lib, ... }:

let
  cfg = config.features.git;
in
{

  options.features.git = {
  };

  config = lib.mkIf cfg.enable {

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
