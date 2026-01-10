{
  config,
  dot,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.navidrome;
in
{

  options.features.navidrome = {
  };

  config = lib.mkIf cfg.enable {

    services.navidrome = {
      enable = true;
      user = dot.user;
      group = dot.group;
      package = pkgs.navidrome;

      # https://www.navidrome.org/docs/usage/configuration-options/
      settings = {
        BaseUrl = "https://music.${dot.domain}";
        Address = "127.0.0.1";
        Port = 4533;

        MusicFolder = "${dot.music}";
        CacheFolder = "${dot.cache}/navidrome";
        DataFolder = "${dot.config}/navidrome";

        EnableGravatar = true;
        EnableInsightsCollector = false; # disable usage data collection
      };
    };

    features.nginx.enable = true;
    services.nginx.virtualHosts."music.${dot.domain}" = {
      forceSSL = true;
      useACMEHost = dot.domain;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.navidrome.settings.Port}";
        proxyWebsockets = true;
      };
    };

  };

}
