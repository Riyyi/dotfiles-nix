{ config, pkgs, lib, dot, ... }:

{
  options.mysql = {
    enable = lib.mkEnableOption "mysql";
    databases = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of database names needed by services";
    };
  };

  config = lib.mkIf config.mysql.enable {

    services.mysql = {
      enable = true;
      user = dot.user;
      group = dot.group;
      package = pkgs.mariadb;
      dataDir = "${dot.config}/mysql";
      settings = {
        mysqld.bind-address = "0.0.0.0";
      };
      ensureDatabases = config.mysql.databases;
      ensureUsers = [
        {
          name = dot.user;
          ensurePermissions = builtins.listToAttrs (
            map (db: {
              name = "${db}.*";
              value = "ALL PRIVILEGES";
            }) config.mysql.databases
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
      databases = config.mysql.databases;
      calendar = "01:05:00"; # every day at 01:05 AM
    };

    networking.firewall.allowedTCPPorts = lib.mkAfter [ 3306 ];
    networking.firewall.allowedUDPPorts = lib.mkAfter [ 3306 ];

  };

}
