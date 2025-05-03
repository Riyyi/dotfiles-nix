{ config, pkgs, lib, dot, ... }:

let
	addFolder = { id, path }: {
    id = id;
    path = "${config.services.syncthing.dataDir}/${path}";
    devices = [ "arch-desktop" "arch-laptop" "debian-vps" ];
    versioning.type = "simple";
    versioning.params.keep = "10";
  };
in
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
          urAccepted = -1; # disable usage data collection
        };
        devices = {
          "arch-desktop" = { id = "QHSELGQ-7WWMSGI-GBI6JKB-QHTT34A-WG6LFZ2-L2M4HBF-P6KHSVY-SQ7NVA3"; };
          "arch-laptop" = { id = "6PINF5J-PNZOSK6-6I4RZPD-ZTN63YM-O4XF4EX-OYAIA6D-VP4I2MS-ZLI7KQM"; };
          "debian-vps" = { id = "PKEBMIL-XRZV5HG-ZPRKMIM-7VVL7AT-62YVBH7-SADHWFY-S4I2CPU-BDP2WA2"; };
        };
        folders = {
          "Config"         = addFolder { id = "lwq5v-etaxu"; path =".config"; };
          "Documents Root" = addFolder { id = "bngf2-vvuwd"; path ="documents"; };
          "Local"          = addFolder { id = "wukrh-fq9tn"; path =".local/share"; };
          "Org"            = addFolder { id = "jhv4y-mmmb9"; path ="documents/org"; };
          "SSH"            = addFolder { id = "dia9g-xghyy"; path =".ssh"; };
          "Scripts"        = addFolder { id = "x2ns4-4nebl"; path =".local/bin"; };
          "Share"          = addFolder { id = "default";     path ="documents/share"; };
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
