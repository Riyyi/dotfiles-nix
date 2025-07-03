{ config, pkgs, lib, dot, ... }:

{

  options.nginx = {
    enable = lib.mkEnableOption "nginx";
  };

  config = lib.mkIf config.nginx.enable {

    sops.secrets."cloudflare/dns/api_key" = {
      owner = dot.user;
    };

    services.nginx = {
      enable = true;
      user = dot.user;
      group = dot.group;

      virtualHosts."home.${dot.domain}" = {
        addSSL = true;
        useACMEHost = dot.domain;

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

    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "riyyi3@gmail.com";
      };
      certs.${dot.domain} = {
        group = dot.group;
        reloadServices = [ "nginx.service" ];
        domain = "${dot.domain}";
        extraDomainNames = [ "*.${dot.domain}" ];
        dnsProvider = "cloudflare";
        dnsResolver = "1.1.1.1:53";
        dnsPropagationCheck = true;
        renewInterval = "monthly";
        environmentFile = config.sops.secrets."cloudflare/dns/api_key".path;
      };
    };

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

    firewall.enable = true;
    firewall.allowedTCPPorts = lib.mkAfter [ 80 443 ];

    system.activationScripts.acme = ''
      homeDir="/var/lib/acme"
      mkdir -p $homeDir
      chown -R acme:${dot.group} $homeDir # fix initial directory creation
    '';

  };

}

  # Generate password with:
  # nix-shell -p apacheHttpd --run 'htpasswd -B -c FILENAME USERNAME'

  # htpasswd -bnBC 10 "" "yourpassword" | tr -d ':\n'
