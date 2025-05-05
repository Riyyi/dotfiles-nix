{ config, pkgs, lib, dot, ... }:

let
  user = "nextcloud";
  database = user;
in
{

  options.nextcloud = {
    enable = lib.mkEnableOption "nextcloud";
  };

  config = lib.mkIf config.nextcloud.enable {

    sops.secrets."nextcloud/gui/password" = {
      owner = "nextcloud";
    };

    users.users.nextcloud.extraGroups = [ dot.group ];

    services.nextcloud = {
      enable = true;
      home = "${dot.config}/nextcloud";
      datadir = config.services.nextcloud.home;
      hostName= "cloud.${dot.domain}";

      package = pkgs.nextcloud31;
      database.createLocally = true;
      configureRedis = true;

      https = true;
      maxUploadSize = "16G";

      autoUpdateApps.enable = true;
      extraAppsEnable = true;
      extraApps = {
				inherit (pkgs.nextcloud31Packages.apps) contacts calendar tasks notes richdocuments;
      };

      config = {
        dbtype = "mysql";
        dbhost = "localhost:/run/mysqld/mysqld.sock";
        dbname = database;
        dbuser = user;
        adminuser = "Riyyi";
        adminpassFile = config.sops.secrets."nextcloud/gui/password".path;
      };
      # Extra options appended to config.php
      # https://docs.nextcloud.com/server/31/Nextcloud_Server_Administration_Manual.pdf
      settings = {
        overwriteprotocol = "https";
        overwritehost = config.services.nextcloud.hostName;
        "overwrite.cli.url" = "https://${config.services.nextcloud.hostName}/";
        default_phone_region = "NL";
        trusted_proxies = [ "127.0.0.1" "::1" ];
      };
    };

    mysql.enable = true;
    # mysql.databases = lib.mkafter [ database ];

    # Nextcloud module already has an nginx entry, just append HTTPS
    nginx.enable = true;
    services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
      forceSSL = true;
      useACMEHost = dot.domain;
    };

    # https://github.com/NixOS/nixpkgs/issues/218878#issuecomment-2407953344
    # https://github.com/CollaboraOnline/online/issues/9303#issuecomment-2681631769
    # services.collabora-online = {
    #   enable = true;
    #   package = pkgs.collabora-online;
    #   port = 9980;
    #   aliasGroups = [
    #     { host = "https://office.${dot.domain}"; }
    #     { host = "https://${config.services.nextcloud.hostName}"; }
    #   ];
    # };

    # services.nginx.virtualHosts."office.${dot.domain}" = {
    #   forceSSL = true;
    #   useACMEHost = dot.domain;
    #   locations."/" = {
    #     proxyPass = "http://127.0.0.1:${toString config.services.collabora-online.port}";
    #     proxyWebsockets = true;
    #   };
    # };

  };

}
