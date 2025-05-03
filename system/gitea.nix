{ config, pkgs, lib, dot, ... }:

let
  user = "git";
  group = user;
  database = user;
in
{

  options.gitea = {
    enable = lib.mkEnableOption "gitea";
  };

  config = lib.mkIf config.gitea.enable {

    users.users.${user} = {
      isSystemUser = true;
      description = "Gitea Service";
      home = config.services.gitea.stateDir;
      useDefaultShell = true;
      group = group;
      openssh.authorizedKeys.keys = [ dot.sshKey ];
    };

    users.groups.${group} = {};

    services.gitea = {
      enable = true;
      user = user;
      group = group;
      stateDir = "${dot.config}/gitea";
      repositoryRoot = "${dot.code}/gitea";
      database = {
        type = "mysql";
        socket = "/run/mysqld/mysqld.sock";
        name = database;
        user = user;
        createDatabase = true; # false means: allow for user != database.user
      };
      # https://docs.gitea.com/next/administration/config-cheat-sheet
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
          # https://docs.gitea.com/next/installation/install-with-docker#understanding-ssh-access-to-gitea-without-passthrough
          DISABLE_SSH = false;
          START_SSH_SERVER = false; # use system SSH
          SSH_CREATE_AUTHORIZED_KEYS_FILE = true;
          SSH_PORT = 4000;
          SSH_DOMAIN = "git-ssh.${dot.domain}";
          HTTP_PORT = 3000;
          DOMAIN = "git-home.${dot.domain}";
          ROOT_URL = "https://git-home.${dot.domain}/";
        };
        service = {
          DEFAULT_KEEP_EMAIL_PRIVATE = true;
          DISABLE_REGISTRATION = true;
          NO_REPLY_ADDRESS = "noreply.localhost";
        };
        repository = {
          DEFAULT_BRANCH = "master";
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
        proxyPass = "http://127.0.0.1:${toString config.services.gitea.settings.server.HTTP_PORT}";
        proxyWebsockets = true;
      };
    };

    system.activationScripts.gitea = ''
      logDir="${config.services.gitea.settings.log.ROOT_PATH}"
      mkdir -p $logDir
      chown -R ${user}:${group} $logDir # fix initial directory creation
    '';

  };

}
