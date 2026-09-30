{
  config,
  dot,
  lib,
  pkgs,
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
    features.postgresql.enable = true;
    features.postgresql.databases = [ "vaultwarden" ];

    sops.secrets."vaultwarden/env" = {
      owner = "podman";
      group = "podman";
      mode = "0440";
    };

    sops.secrets."vaultwarden/database/password" = {
      owner = "postgres";
      group = "postgres";
      mode = "0440";
      restartUnits = [ "vaultwarden-postgres.service" ];
    };

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

    systemd.services.vaultwarden-postgres = lib.mkIf config.features.postgresql.enable {
      description = "Set Vaultwarden PostgreSQL user password";
      after = [
        "postgresql.service"
        "sops-nix.service"
      ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "postgres";
        Group = "postgres";
        RemainAfterExit = true;
      };
      script = ''
        passwd="$(cat ${config.sops.secrets."vaultwarden/database/password".path})"
        ${config.services.postgresql.package}/bin/psql -c "ALTER USER vaultwarden WITH PASSWORD '$passwd';"
      '';
    };

  };

}
