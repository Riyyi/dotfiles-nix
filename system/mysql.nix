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
      package = pkgs.mariadb;
      user = dot.user;
      group = dot.group;
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

    networking.firewall.allowedTCPPorts = lib.mkAfter [ 3306 ];
    networking.firewall.allowedUDPPorts = lib.mkAfter [ 3306 ];

  };

}
