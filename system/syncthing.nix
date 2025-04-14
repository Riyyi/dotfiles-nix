{ config, pkgs, lib, dot, ... }:

{

	options.syncthing = {
    enable = lib.mkEnableOption "syncthing";
  };

  config = lib.mkIf config.syncthing.enable {

    sops.secrets."syncthing/gui/password" = {
      owner = dot.user;
    };

    services.syncthing = {
      enable = true;
      user = dot.user;
      group = dot.group;
      dataDir = "${dot.config}/syncthing";
      configDir = "${config.services.syncthing.dataDir}/config";
      databaseDir = config.services.syncthing.configDir;
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
      mkdir -p $dataDir
      chown -R ${dot.user}:${dot.group} $dataDir # fix initial directory creation

      configDir="${config.services.syncthing.configDir}"
      mkdir -p $configDir
      chown -R ${dot.user}:${dot.group} $configDir # fix initial directory creation
    '';

  };

}
