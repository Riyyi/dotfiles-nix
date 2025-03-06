{ config, pkgs, ... }:

let
  user = "rick";
  group = "users";
in
{

  services.nginx = {
    enable = true;
    user = "${user}";
    group = "${group}";

    virtualHosts."example.test" = {
      root = "/var/www/riyyi/public";

      extraConfig = ''
        index index.php index.html index.htm;
      '';

      locations."/".extraConfig = ''
        try_files $uri $uri/ /index.php?$query_string;
      '';

      locations."~ \\.php$".extraConfig = ''
        fastcgi_pass  unix:${config.services.phpfpm.pools.pool.socket};
      '';

    };

    virtualHosts."git.example.test" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:3000";
        proxyWebsockets = true;
      };
    };

    virtualHosts."syncthing.example.test" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:8384";
        proxyWebsockets = true;
      };
    };

    virtualHosts."transmission.example.test" = {
      # basicAuth = { myuser = "mypassword"; }; # plain text in Nix store
      locations."/" = {
        proxyPass = "http://127.0.0.1:9091";
        proxyWebsockets = true;
      };
      locations."/".extraConfig = ''
        proxy_pass_header  X-Transmission-Session-Id;
      '';
    };
  };

  # Lift restriction to write OS disk
  systemd.services.nginx.serviceConfig.ReadWritePaths = [ "/var/log/nginx/" ];

  services.phpfpm.pools.pool = {
    # enable is implicit by defining a pool
    user = "${user}";
    group = "${group}";
    settings = {
      "pm" = "dynamic";
      "listen.owner" = config.services.nginx.user;
      "listen.group" = config.services.nginx.group;
      "pm.max_children" = 5;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 3;
      "pm.max_requests" = 500;
    };
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    user = "${user}";
    group = "${group}";
    ensureDatabases = [ "gitea" ];
    settings = {
      mysqld.bind-address = "0.0.0.0";
    };
    # sudo mysql_secure_installation
    # <enter>
    # n
    # n
    # y
    # y
    # y
    # y
    # sudo mariadb
    # SET PASSWORD FOR 'riyyi'@'%' = PASSWORD('1qwerty1');
    # FLUSH PRIVILEGES;
    # exit
  };

}
