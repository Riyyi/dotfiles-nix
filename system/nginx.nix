{ config, pkgs, dot, ... }:

{

  sops.secrets."transmission/nginx/password" = {
    owner = dot.user;
  };

  services.nginx = {
    enable = true;
    user = dot.user;
    group = dot.group;

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

    virtualHosts."jellyfin.example.test" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:8096";
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
      basicAuthFile = config.sops.secrets."transmission/nginx/password".path;
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
    user = dot.user;
    group = dot.group;
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
    user = dot.user;
    group = dot.group;
    dataDir = "${dot.config}/mysql";
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
    # CREATE USER 'riyyi'@'%' IDENTIFIED BY 'newpassword';
    # CREATE DATABASE gitea;
    # GRANT ALL ON gitea.* TO 'gitea'@'localhost' IDENTIFIED BY 'mypassword' WITH GRANT OPTION;
    # FLUSH PRIVILEGES;
    # exit
  };

  networking.firewall.allowedTCPPorts = [ 80 443 3306 ];
  networking.firewall.allowedUDPPorts = [ 80 443 3306 ];

}

  # Generate password with:
  # nix-shell -p apacheHttpd --run 'htpasswd -B -c FILENAME USERNAME'

# htpasswd -bnBC 10 "" "yourpassword" | tr -d ':\n'
