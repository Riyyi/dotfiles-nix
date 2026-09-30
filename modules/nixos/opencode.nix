{
  config,
  dot,
  lib,
  ...
}:

let
  cfg = config.features.opencode;

  dataDir = "${dot.config}/opencode";
in
{

  options.features.opencode = {
  };

  config = lib.mkIf cfg.enable {

    features.podman.enable = lib.mkDefault true;

    sops.secrets."opencode/server/env" = {
      owner = "podman";
      group = "podman";
      mode = "0440";
    };

    features.nginx.enable = true;
    services.nginx.virtualHosts."code.${dot.domain}" = {
      forceSSL = true;
      useACMEHost = dot.domain;
      locations."/" = {
        proxyPass = "http://127.0.0.1:4096";
        proxyWebsockets = true;
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_read_timeout 600s;
          proxy_send_timeout 600s;
          send_timeout 600s;
        '';
      };
    };

    system.activationScripts.opencode = ''
      mkdir -p ${dataDir}/config ${dataDir}/data ${dataDir}/state ${dataDir}/cache
      chown -R podman:podman ${dataDir}
    '';

  };

}
