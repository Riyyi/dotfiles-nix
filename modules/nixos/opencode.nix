{
  config,
  dot,
  lib,
  ...
}:

let
  cfg = config.features.opencode;

  containerName = "opencode";
  dataDir = "/var/lib/opencode";
in
{

  options.features.opencode = {
  };

  config = lib.mkIf cfg.enable {

    virtualisation.podman = {
      enable = true;

      # Use podman directly through oci-containers, no docker socket needed
      dockerSocket.enable = false;

      defaultNetwork.settings = {
        # No custom networks required, the container is published on loopback
        # dns_enabled = true;
      };
    };

    virtualisation.oci-containers = {
      backend = "podman";

      containers.${containerName} = {
        image = "docker.io/smanx/opencode:latest";
        autoStart = true;

        # loopback only, exposed through nginx
        ports = [
          "127.0.0.1:4096:4096"
        ];

        # environment file with:
        #   OPENCODE_SERVER_USERNAME=<...>
        #   OPENCODE_SERVER_PASSWORD=<...>
        environmentFiles = [
          config.sops.secrets."opencode/server/env".path
        ];

        volumes = [
          "${dataDir}/config:/root/.config/opencode"
          "${dataDir}/data:/root/.local/share/opencode"
          "${dataDir}/state:/root/.local/state/opencode"
          "${dataDir}/cache:/root/.cache/opencode"
        ];
      };
    };

    sops.secrets."opencode/server/env" = {
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
      chown -R root:root ${dataDir} # fix initial directory creation; container runs as root
    '';

  };

}
