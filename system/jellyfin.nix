{ config, pkgs, lib, dot, ... }:

{

	options.jellyfin = {
    enable = lib.mkEnableOption "jellyfin";
  };

  config = lib.mkIf config.jellyfin.enable {

    users.users.${dot.user} = {
      extraGroups = lib.mkAfter [ "render" "video" "input" ];
    };

    services.jellyfin = {
      enable = true;
      user = dot.user;
      group = dot.group;
      dataDir = "${dot.config}/jellyfin";
      configDir = "${config.services.jellyfin.dataDir}/config";
      cacheDir = "${dot.cache}/jellyfin";
    };

    networking.firewall.allowedUDPPorts = [ 1900 7359 ];

    nginx.enable = true;
    services.nginx.virtualHosts."jellyfin.${dot.domain}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:8096";
        proxyWebsockets = true;
      };
    };

  };

}
