{ config, pkgs, dot, ... }:

{

  services.transmission = {
    enable = true;
    user = dot.user;
    group = dot.group;
    openRPCPort = false; # web access via nginx
    openPeerPorts = true;
    package = pkgs.transmission_4;
    settings = {
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist = "*";
      rpc-whitelist-enabled = true;
      rpc-host-whitelist = "*";
      rpc-host-whitelist-enabled = true;
      download-dir = "${config.services.transmission.home}/Downloads";
      # incomplete-dir = "${config.services.transmission.home}/Downloads/.incomplete";
    };
  };

}
