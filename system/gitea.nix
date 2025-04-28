{ config, pkgs, lib, dot, ... }:

let
  database = "gitea";
in
{

	options.gitea = {
    enable = lib.mkEnableOption "gitea";
  };

  config = lib.mkIf config.gitea.enable {

    services.gitea = {
      enable = true;
      user = dot.user;
      group = dot.group;
      stateDir = "${dot.config}/gitea";
      repositoryRoot = dot.code;
      database = {
        type = "mysql";
        socket = "/run/mysqld/mysqld.sock";
        name = database;
        user = dot.user;
        createDatabase = false; # allow for user != database.user
      };
      settings = {
        log = {
          LEVEL = "Info";
          MODE = "file";
          ROOT_PATH = "/var/log/gitea";
        };
        picture = {
          DISABLE_GRAVATAR = false;
          ENABLE_FEDERATED_AVATAR = true;
        };
        server = {
          SSH_PORT = 4000;
          DOMAIN = "git-home.${dot.domain}";
          ROOT_URL = "https://git-home.${dot.domain}/";
        };
        service = {
          DEFAULT_KEEP_EMAIL_PRIVATE = true;
          DISABLE_REGISTRATION = true;
          NO_REPLY_ADDRESS = "noreply.localhost";
        };
      };
    };

    mysql.enable = true;
    mysql.databases = lib.mkAfter [ database ];

    nginx.enable = true;
    services.nginx.virtualHosts."git-home.${dot.domain}" = {
      forceSSL = true;
      useACMEHost = dot.domain;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3000";
        proxyWebsockets = true;
      };
    };

    system.activationScripts.gitea = ''
      logDir="${config.services.gitea.settings.log.ROOT_PATH}"
      mkdir -p $logDir
      chown -R ${dot.user}:${dot.group} $logDir # fix initial directory creation
    '';

  };

}
