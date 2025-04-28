{ config, pkgs, lib, dot, ... }:

let
  database = "nextcloud";
in
{

  options.nextcloud = {
    enable = lib.mkEnableOption "nextcloud";
  };

  config = lib.mkIf config.nextcloud.enable {

    sops.secrets."nextcloud/gui/password" = {
      owner = "nextcloud";
    };

    services.nextcloud = {
      enable = true;
      # user = dot.user;
      # group = dot.group;
      home = "${dot.config}/nextcloud";
      datadir = config.services.nextcloud.home;
      hostName= "localhost";
      https = false;
      extraApps = {
        inherit (pkgs.nextcloud30.packages.apps) contacts calendar tasks;
      };
      extraAppsEnable = true;
      config = {
        dbtype = "mysql";
        dbhost = "/run/mysqld/mysqld.sock";
        dbname = database;
        dbuser = dot.user;
        adminuser = "Riyyi";
        adminpassFile = config.sops.secrets."nextcloud/gui/password".path;
      };
      # ensureUsers = {
      #   ${dot.user} = {
      #     email = "${dot.user}@localhost";
      #     passwordFile = "/etc/nextcloud-user-pass";
      #   };
      # };
    };

    mysql.enable = true;
    mysql.databases = lib.mkAfter [ database ];

    nginx.enable = true;
    services.nginx.virtualHosts."nextcloud.${dot.domain}" = {
      forceSSL = true;
      useACMEHost = dot.domain;
      locations."/" = {
        proxyPass = "http://127.0.0.1:80";
        proxyWebsockets = true;
      };
    };

  };

}
