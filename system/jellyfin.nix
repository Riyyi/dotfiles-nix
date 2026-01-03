{
  config,
  pkgs,
  lib,
  dot,
  ...
}:

{

  options.jellyfin = {
    enable = lib.mkEnableOption "jellyfin";
  };

  config = lib.mkIf config.jellyfin.enable {

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

    firewall.enable = true;
    firewall.safeUDPPorts = lib.mkAfter [
      1900
      7359
    ]; # open port to all IPs

    nginx.enable = true;
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
