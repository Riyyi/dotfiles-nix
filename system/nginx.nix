{ config, pkgs, lib, dot, ... }:

{

	options.nginx = {
    enable = lib.mkEnableOption "nginx";
  };

  config = lib.mkIf config.nginx.enable {

    sops.secrets."transmission/nginx/password" = {
      owner = dot.user;
    };

    services.nginx = {
      enable = true;
      user = dot.user;
      group = dot.group;

      virtualHosts."${dot.domain}" = {
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

    networking.firewall.allowedTCPPorts = lib.mkAfter [ 80 443 ];
    networking.firewall.allowedUDPPorts = lib.mkAfter [ 80 443 ];

  };

}

  # Generate password with:
  # nix-shell -p apacheHttpd --run 'htpasswd -B -c FILENAME USERNAME'

  # htpasswd -bnBC 10 "" "yourpassword" | tr -d ':\n'
