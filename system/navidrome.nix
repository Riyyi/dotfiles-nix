{ config, pkgs, lib, dot, ... }:

{

	options.navidrome = {
    enable = lib.mkEnableOption "navidrome";
  };

  config = lib.mkIf config.navidrome.enable {

    services.navidrome = {
      enable = true;
      user = dot.user;
      group = dot.group;
      package = pkgs.navidrome;

      # https://www.navidrome.org/docs/usage/configuration-options/
      settings = {
        BaseUrl = "http://navidrome.example.test";
        Address = "127.0.0.1";
        Port = 4533;

        MusicFolder = "/mnt/data/music";
        CacheFolder = "/mnt/data/cache/navidrome";
        DataFolder = "/mnt/data/config/navidrome";

        EnableGravatar = true;
        EnableInsightsCollector = false; # disable usage data collection
      };
    };

  };

}
