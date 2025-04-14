{ config, pkgs, lib, dot, ... }:

let
  database = "nextcloud";
in
{

  sops.secrets."nextcloud/gui/password" = {
    owner = dot.user;
  };

  services.nextcloud = {
    enable = true;
    # user = dot.user;
    # group = dot.group;
    home = "${dot.config}/nextcloud";
    datadir = config.services.nextcloud.home;
    hostName= "nextcloud.example.test";
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

  mysql.databases = lib.mkAfter [ database ];

}
