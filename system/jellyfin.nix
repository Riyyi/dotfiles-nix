{ config, pkgs, dot, ... }:

let
	user = "jellyfin";
  group = "jellyfin";
in
{

  users.users.${user} = {
    isSystemUser = true;
    extraGroups = [ "render" "video" "input" ];
  };

  services.jellyfin = {
    enable = true;
    user = user;
    group = group;
  };

  networking.firewall.allowedUDPPorts = [ 1900 7359 ];

}
