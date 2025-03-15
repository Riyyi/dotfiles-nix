{ config, pkgs, dot, ... }:

let
	user = "jellyfin";
  group = "jellyfin";
in
{

  users.users.${user} = {
    isSystemUser = true;
  };

  services.jellyfin = {
    enable = true;
    user = user;
    group = group;
    openFirewall = true; # TCP 8096/8920, UDP 1900/7359
  };

}
