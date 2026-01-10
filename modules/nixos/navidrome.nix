{
  config,
  dot,
  lib,
  pkgs,
  ...
}:

{

  options.navidrome = {
  };

  config = lib.mkIf config.features.navidrome {

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

    nginx.enable = true;
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
