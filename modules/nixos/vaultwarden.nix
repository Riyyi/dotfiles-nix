{
  config,
  dot,
  lib,
  ...
}:

let
  cfg = config.features.vaultwarden;

  dataDir = "${dot.config}/vaultwarden";
in
{

  options.features.vaultwarden = {
  };

  config = lib.mkIf cfg.enable {

    features.podman.enable = lib.mkDefault true;

    features.nginx.enable = true;
    services.nginx.virtualHosts."vault.${dot.domain}" = {
      forceSSL = true;
      useACMEHost = dot.domain;
      locations."/" = {
        proxyPass = "http://127.0.0.1:7661";
        proxyWebsockets = true;
        recommendedProxySettings = true;
      };
    };

    system.activationScripts.vaultwarden = ''
      mkdir -p ${dataDir}/data
      chown -R podman:podman ${dataDir}
    '';

  };

}
