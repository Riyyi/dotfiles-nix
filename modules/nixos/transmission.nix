{
  config,
  dot,
  lib,
  pkgs,
  ...
}:

let
  # cfg = config.transmission;
  port = 51413;
in
{

  options.transmission = {
  };

  config = lib.mkIf config.features.transmission {

    sops.secrets."transmission/nginx/password" = {
      owner = dot.user;
    };

    services.transmission = {
      enable = true;
      user = dot.user;
      group = dot.group;
      home = "${dot.config}/transmission";
      openPeerPorts = true;
      openRPCPort = false; # web access via nginx
      package = pkgs.transmission_4;
      settings = {
        peer-port = port;
        peer-port-random-on-start = false;
        rpc-bind-address = "0.0.0.0";
        rpc-whitelist = "*";
        rpc-whitelist-enabled = true;
        rpc-host-whitelist = "*";
        rpc-host-whitelist-enabled = true;
        download-dir = "${dot.downloads}";
        incomplete-dir = "${dot.downloads}/.incomplete";
      };
    };

    nginx.enable = true;
    services.nginx.virtualHosts."download.${dot.domain}" = {
      forceSSL = true;
      useACMEHost = dot.domain;
      basicAuthFile = config.sops.secrets."transmission/nginx/password".path;
      locations."/" = {
        proxyPass = "http://127.0.0.1:9091";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_pass_header  X-Transmission-Session-Id;
        '';
      };
    };

    firewall.enable = true;
    firewall.safeTCPPorts = lib.mkAfter [ port ]; # open port to all IPs
    firewall.safeUDPPorts = lib.mkAfter [ port ]; # open port to all IPs

    system.activationScripts.transmission = ''
      configDir="${config.services.transmission.home}/.config/transmission-daemon"
      mkdir -p $configDir
      chown -R ${dot.user}:${dot.group} $configDir # fix initial directory creation

      incompleteDir="${config.services.transmission.settings.incomplete-dir}"
      mkdir -p $incompleteDir
      chown -R ${dot.user}:${dot.group} $incompleteDir # fix initial directory creation
    '';

  };

}
