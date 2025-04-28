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

    firewall.enable = true;
    firewall.allowedTCPPorts = lib.mkAfter [ 22000 ];
    firewall.allowedUDPPorts = lib.mkAfter [ 22000 21027 ];

    nginx.enable = true;
    services.nginx.virtualHosts."syncthing-home.${dot.domain}" = {
      forceSSL = true;
      useACMEHost = dot.domain;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8384";
        proxyWebsockets = true;
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
