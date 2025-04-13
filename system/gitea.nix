{ config, pkgs, lib, dot, ... }:

let
  database = "gitea";
in
{

  sops.secrets."gitea/database/password" = {
    owner = dot.user;
  };

  services.gitea = {
    enable = true;
    user = dot.user;
    group = dot.group;
    stateDir = "${dot.config}/gitea";
    repositoryRoot = dot.code;
    database = {
      type = "mysql";
      name = database;
      user = database;
      passwordFile = config.sops.secrets."gitea/database/password".path;
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
				DOMAIN = "git.example.test";
        ROOT_URL = "http://git.example.test/";
      };
      service = {
        DEFAULT_KEEP_EMAIL_PRIVATE = true;
        DISABLE_REGISTRATION = true;
        NO_REPLY_ADDRESS = "noreply.localhost";
      };
    };
  };

  services.mysql.ensureDatabases = lib.mkAfter [ database ];

  system.activationScripts.gitea = ''
    logDir="${config.services.gitea.settings.log.ROOT_PATH}"
    mkdir -p $logDir
    chown -R ${dot.user}:${dot.group} $logDir # fix initial directory creation
  '';

}
