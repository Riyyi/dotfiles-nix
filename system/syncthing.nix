{ config, pkgs, ... }:

let
	user = "syncthing";
  group = "syncthing";
in
{

  users.users.${user} = {
    isSystemUser = true;
    group = group;
  };
  users.groups.${group} = {};

  sops.secrets."syncthing/gui/password" = {
    owner = user;
  };

  services.syncthing = {
    enable = true;
    user = user;
    group = group;
    openDefaultPorts = true; # TCP/UDP = 22000, UDP = 21027
    settings = {
      gui = {
        address = "0.0.0.0:8384"; # enable remote access
        user = "Riyyi";
        password = "$2a$10$B34nHbqKXe1GbQhjA3dls.5wHB66y9EUN6jl0.I83eqFVgaWsO9Lq";
      };
      options = {
        crashReportingEnabled = false;
      };
    };
  };

  system.activationScripts.syncthing = ''
    dataDir="${config.services.syncthing.dataDir}"
    chown -R ${user}:${group} $dataDir # fix initial directory creation
  '';

}
