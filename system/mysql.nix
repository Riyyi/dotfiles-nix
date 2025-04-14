{ config, pkgs, lib, dot, ... }:

{
  options.mysql = {
    databases = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of database names needed by services";
    };
  };

  config = {
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
      # ensureUsers = [
      #   {
      #     name = dot.user;
      #     ensurePermissions = {
      #       "gitea.*" = "ALL PRIVILEGES";
      #       "nextcloud.*" = "ALL PRIVILEGES";
      #     };
      #   }
      # ];
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

      # sudo mariadb
      # CREATE USER 'riyyi'@'%' IDENTIFIED BY 'newpassword';
      # CREATE DATABASE gitea;
      # GRANT ALL ON gitea.* TO 'gitea'@'localhost' IDENTIFIED BY 'mypassword' WITH GRANT OPTION;
      # FLUSH PRIVILEGES;
      # exit
    };

    networking.firewall.allowedTCPPorts = lib.mkAfter [ 3306 ];
    networking.firewall.allowedUDPPorts = lib.mkAfter [ 3306 ];
  };

}
