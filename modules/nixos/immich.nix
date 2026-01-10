{
  config,
  dot,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.immich;

  user = "immich";
  group = user;
  database = user;
in
{

  options.features.immich = {
  };

  config = lib.mkIf cfg.enable {

    users.users.${user}.extraGroups = [
      "render"
      "video"
    ];

    services.immich = {
      enable = true;
      user = user;
      group = group;
      package = pkgs.immich;

      host = "localhost"; # only listens on IPv6! ::1
      port = 2283;

      mediaLocation = "${dot.pictures}/immich";

      database = {
        # PostgreSQL support only
        enable = true;
        createDB = true;
        name = database;
        user = user;
      };

      redis.enable = true;
      machine-learning.enable = false;

      # https://immich.app/docs/install/config-file/
      settings.server.externalDomain = "https://pictures.${dot.domain}";
    };

    features.postgresql.enable = true;
    features.postgresql.databases = lib.mkAfter [ database ];

    features.nginx.enable = true;
    services.nginx.virtualHosts."pictures.${dot.domain}" = {
      forceSSL = true;
      useACMEHost = dot.domain;
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
