{ config, pkgs, lib, dot, ... }:

let
  user = "immich";
  group = user;
  database = user;
in
{

  options.immich = {
    enable = lib.mkEnableOption "immich";
  };

  config = lib.mkIf config.immich.enable {

    users.users.${user}.extraGroups = [ "render" "video" ];

    services.immich = {
      enable = true;
      user = user;
      group = group;
      package = pkgs.immich;

      host = "localhost"; # only listens on IPv6! ::1
      port = 2283;

      mediaLocation = "${dot.pictures}/immich";

      database = { # PostgreSQL support only
        enable = true;
        createDB = true;
        name = database;
        user = user;
      };

      redis.enable = true;
      machine-learning.enable = false;

      # https://immich.app/docs/install/config-file/
      settings.server.externalDomain = "http://immich.${dot.domain}";
    };

    postgresql.enable = true;
    postgresql.databases = lib.mkAfter [ database ];

    nginx.enable = true;
    services.nginx.virtualHosts."immich.${dot.domain}" = {
      locations."/" = {
        proxyPass = "http://[::1]:${toString config.services.immich.port}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
        extraConfig = ''
          client_max_body_size 50000M;
          proxy_read_timeout   600s;
          proxy_send_timeout   600s;
          send_timeout         600s;
        '';
      };
    };

    system.activationScripts.immich = ''
      mediaDir="${config.services.immich.mediaLocation}"
      mkdir -p $mediaDir
      chown -R ${user}:${group} $mediaDir # fix initial directory creation
    '';

  };

}
