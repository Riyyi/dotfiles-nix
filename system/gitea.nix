{ config, pkgs, dot, ... }:

let
	user = "gitea";
  group = "gitea";
in
{

  users.users.${user} = {
    isSystemUser = true;
  };

  sops.secrets."gitea/database/password" = {
    owner = user;
  };

  services.gitea = {
    enable = true;
    user = user;
    group = group;
    # stateDir = "/var/lib/gitea";
    # repositoryRoot = "${config.services.gitea.stateDir}/repositories";
    database = {
      type = "mysql";
      name = user;
      user = user;
      passwordFile = config.sops.secrets."gitea/database/password".path;
    };
    settings = {
      log = {
        LEVEL = "Info";
        MODE = "file";
        ROOT_PATH = "/var/log/gitea"; # FIXME: This directory doesnt get created automatically (chown rick:users)
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

}
