{ config, pkgs, dot, ... }:

let
	user = "nextcloud";
  group = "nextcloud";
in
{

  users.users.${user} = {
    isSystemUser = true;
  };

  sops.secrets."nextcloud/database/password" = {
    owner = user;
  };

  sops.secrets."nextcloud/gui/password" = {
    owner = user;
  };

  services.nextcloud = {
    enable = true;
    user = user;
    group = group;
    hostName= "nextcloud.example.test";
    https = false;
    extraApps = {
      inherit (pkgs.nextcloud30.packages.apps) contacts calendar tasks;
    };
    extraAppsEnable = true;
    config = {
      dbtype = "mysql";
      dbhost = "localhost";
      dbuser = user;
      dbname = user;
      dbpassFile = config.sops.secrets."nextcloud/database/password".path;
      adminuser = "Riyyi";
      adminpassFile = config.sops.secrets."nextcloud/gui/password".path;
    };
    ensureUsers = {
      ${dot.user} = {
        email = "${dot.user}@localhost";
        passwordFile = "/etc/nextcloud-user-pass";
      };
    };
  };

}
