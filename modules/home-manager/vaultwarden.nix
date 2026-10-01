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
        SIGNUPS_VERIFY = "false";

        SMTP_HOST="mail.riyyi.com";
        SMTP_FROM="noreply@riyyi.com";
        SMTP_FROM_NAME="Vaultwarden";
        SMTP_PORT=587;
        SMTP_SSL=true;
        SMTP_EXPLICIT_TLS=false;
        SMTP_USERNAME="noreply@riyyi.com";
        SMTP_AUTH_MECHANISM="Plain,Login";
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
