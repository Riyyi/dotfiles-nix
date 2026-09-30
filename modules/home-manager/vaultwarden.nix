{
  config,
  dot,
  lib,
  ...
}:

let
  cfg = config.features.vaultwarden;

  containerName = "vaultwarden";
  dataDir = "${dot.config}/vaultwarden";
in
{

  options.features.vaultwarden = {
  };

  config = lib.mkIf cfg.enable {

    services.podman.containers.${containerName} = {
      image = "docker.io/vaultwarden/server:latest";
      autoStart = true;

      # loopback only, exposed through nginx
      ports = [
        "127.0.0.1:7661:80"
      ];

      environment = {
        DOMAIN = "https://vault.${dot.domain}";
        SIGNUPS_ALLOWED = "false";
      };

      environmentFile = [
        "/run/secrets/vaultwarden/env"
      ];

      volumes = [
        "${dataDir}/data:/data"
        "/run/postgresql:/run/postgresql"
      ];
    };

  };

}
