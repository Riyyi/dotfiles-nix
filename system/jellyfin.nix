{ config, pkgs, dot, ... }:

{

  users.users.${dot.user} = {
    extraGroups = [ "render" "video" "input" ];
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

}
