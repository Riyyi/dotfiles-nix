{
  dot,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.nextcloud;

  user = "nextcloud";
  database = user;
in
{

  options.features.nextcloud = {
  };

  config = lib.mkIf cfg.enable {

    sops.secrets."nextcloud/gui/password" = {
      owner = "nextcloud";
    };

    users.users.nextcloud.extraGroups = [ dot.group ];

    services.nextcloud = {
      enable = true;
      home = "${dot.config}/nextcloud";
      datadir = config.services.nextcloud.home;
      hostName = "cloud.${dot.domain}";

      package = pkgs.nextcloud31;
      database.createLocally = true;
      configureRedis = true;

      https = true;
      maxUploadSize = "16G";

      autoUpdateApps.enable = true;
      extraAppsEnable = true;
      extraApps = {
        inherit (pkgs.nextcloud31Packages.apps)
          contacts
          calendar
          tasks
          notes
          richdocuments
          ;
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
        trusted_proxies = [
          "127.0.0.1"
          "::1"
        ];
      };
    };

    features.mysql.enable = true;
    # features.mysql.databases = lib.mkafter [ database ];

    # Nextcloud module already has an nginx entry, just extend with HTTPS
    features.nginx.enable = true;
    services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
      forceSSL = true;
      useACMEHost = dot.domain;
    };

    # --------------------------------------
    # Office

    # Configured with the help from:
    # https://diogotc.com/blog/collabora-nextcloud-nixos/

    # https://github.com/NixOS/nixpkgs/issues/218878#issuecomment-2407953344
    # https://github.com/CollaboraOnline/online/issues/9303#issuecomment-2681631769

    services.collabora-online = {
      enable = true;
      package = pkgs.collabora-online;
      port = 9980;

      # https://github.com/CollaboraOnline/online/blob/master/coolwsd.xml.in
      settings = {
        # Rely on reverse proxy for SSL
        ssl = {
          enable = false;
          termination = true;
        };

        # Listen on loopback interface only, and accept requests from ::1
        net = {
          proto = "IPv4";
          listen = "loopback";
          post_allow.host = [ ''127\.0\.0\.1'' ];
        };

        # Restrict loading documents from WOPI Host
        storage.wopi = {
          "@allow" = true;
          host = [ "cloud.${dot.domain}" ];
        };

        # Set FQDN of server
        server_name = "office.${dot.domain}";
      };
    };

    services.nginx.virtualHosts.${config.services.collabora-online.settings.server_name} = {
      forceSSL = true;
      useACMEHost = dot.domain;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.collabora-online.port}";
        proxyWebsockets = true;
      };
    };

    # --------------------------------------
    # Declaratively configure office settings

    systemd.services.nextcloud-config-collabora =
      let
        inherit (config.services.nextcloud) occ;

        wopi_url = "http://127.0.0.1:${toString config.services.collabora-online.port}";
        public_wopi_url = "https://${config.services.collabora-online.settings.server_name}";
        wopi_allowlist = lib.concatStringsSep "," [
          "127.0.0.1"
          "::1"
        ];
      in
      {
        wantedBy = [ "multi-user.target" ];
        after = [
          "nextcloud-setup.service"
          "coolwsd.service"
        ];
        requires = [ "coolwsd.service" ];
        script = ''
          ${occ}/bin/nextcloud-occ config:app:set richdocuments wopi_url --value ${lib.escapeShellArg wopi_url}
          ${occ}/bin/nextcloud-occ config:app:set richdocuments public_wopi_url --value ${lib.escapeShellArg public_wopi_url}
          ${occ}/bin/nextcloud-occ config:app:set richdocuments wopi_allowlist --value ${lib.escapeShellArg wopi_allowlist}
          ${occ}/bin/nextcloud-occ richdocuments:setup
        '';
        serviceConfig = {
          Type = "oneshot";
          User = "nextcloud";
        };
      };

    # Make Collabora resolve Nextcloud to localhost, so the WOPI whitelist works
    networking.hosts = {
      "127.0.0.1" = [
        config.services.nextcloud.hostName
        config.services.collabora-online.settings.server_name
      ];
      "::1" = [
        config.services.nextcloud.hostName
        config.services.collabora-online.settings.server_name
      ];
    };

  };

}
