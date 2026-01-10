{
  config,
  dot,
  lib,
  ...
}:

let
  cfg = config.features.jellyfin;
in
{

  options.features.jellyfin = {
  };

  config = lib.mkIf cfg.enable {

    users.users.${dot.user} = {
      extraGroups = lib.mkAfter [
        "render"
        "video"
        "input"
      ];
    };

    services.jellyfin = {
      enable = true;
      user = dot.user;
      group = dot.group;
      dataDir = "${dot.config}/jellyfin";
      configDir = "${config.services.jellyfin.dataDir}/config";
      cacheDir = "${dot.cache}/jellyfin";
    };

    features.firewall.enable = true;
    features.firewall.safeUDPPorts = lib.mkAfter [
      1900
      7359
    ]; # open port to all IPs

    features.nginx.enable = true;
    services.nginx.virtualHosts."videos.${dot.domain}" = {
      forceSSL = true;
      useACMEHost = dot.domain;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8096";
        proxyWebsockets = true;
      };
    };

  };

}
