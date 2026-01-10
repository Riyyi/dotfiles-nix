{
  config,
  dot,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.qbittorrent-nox;

  port = 50000;
in
{

  options.features.qbittorrent-nox = {
  };

  config = lib.mkIf cfg.enable {

    services.qbittorrent = {
      enable = true;
      user = dot.user;
      group = dot.group;
      package = pkgs.qbittorrent-nox;
      webuiPort = 8080;
      torrentingPort = port;
      profileDir = "${dot.config}/qbittorrent";
      serverConfig = {
        LegalNotice.Accepted = true;
        BitTorrent = {
          Session = {
            AlternativeGlobalDLSpeedLimit = 10240;
            AlternativeGlobalUPSpeedLimit = 10240;
            DefaultSavePath = dot.downloads;
            GlobalDLSpeedLimit = 0;
            GlobalMaxRatio = 2.1;
            GlobalUPSpeedLimit = 0;
          };
        };
        Preferences = {
          WebUI = {
            Username = "riyyi";
            Password_PBKDF2 = "@ByteArray(TIeXUxgTjiq5fYfSwl/oNQ==:4iiN8mkGEL2aKEv6w2nBTnFhGNa0aT9YIq7t5yeAQ9DtoSEKlPyhBo6xxuHtb6P4bwN+Kuzd3wDWk6KLDlczGQ==)";
          };
          General.Locale = "en";
        };
      };
    };

    features.nginx.enable = true;
    services.nginx.virtualHosts."download.${dot.domain}" = {
      forceSSL = true;
      useACMEHost = dot.domain;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8080";
        proxyWebsockets = true;
        extraConfig = ''
          # headers recognized by qBittorrent
          proxy_set_header   Host               $proxy_host;
          proxy_set_header   X-Forwarded-For    $proxy_add_x_forwarded_for;
          proxy_set_header   X-Forwarded-Host   $http_host;
          proxy_set_header   X-Forwarded-Proto  $scheme;

          # POST request size limit, to allow adding a lot of torrents at once
          client_max_body_size 100M;
        '';
      };
    };

    features.firewall.enable = true;
    features.firewall.safeTCPPorts = lib.mkAfter [ port ]; # open port to all IPs

  };

}

# Generate password tool
# https://codeberg.org/feathecutie/qbittorrent_password
