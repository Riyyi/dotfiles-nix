{
  config,
  dot,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.mysql;
in
{
  options.features.mysql = {
    databases = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of database names needed by services";
    };
  };

  config = lib.mkIf cfg.enable {

    services.mysql = {
      enable = true;
      user = dot.user;
      group = dot.group;
      package = pkgs.mariadb;
      dataDir = "${dot.config}/mysql";
      settings = {
        mysqld.bind-address = "0.0.0.0";
      };
      ensureDatabases = cfg.databases;
      ensureUsers = [
        {
          name = dot.user;
          ensurePermissions = builtins.listToAttrs (
            map (db: {
              name = "${db}.*";
              value = "ALL PRIVILEGES";
            }) cfg.databases
          );
        }
      ];

      # sudo mysql_secure_installation
      # <enter>
      # n
      # n
      # y
      # y
      # y
      # y
    };

    services.mysqlBackup = {
      enable = true;
      user = dot.user;
      location = "${dot.documents}/backup/${dot.hostname}/mysql";
      databases = cfg.databases;
      calendar = "01:05:00"; # every day at 01:05 AM
    };

    features.firewall.enable = true;
    features.firewall.allowedTCPPorts = lib.mkAfter [ 3306 ];
    features.firewall.allowedUDPPorts = lib.mkAfter [ 3306 ];

  };

}
