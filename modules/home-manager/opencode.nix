{
  config,
  dot,
  lib,
  ...
}:

let
  cfg = config.features.opencode;

  containerName = "opencode";
  dataDir = "${dot.config}/opencode";
in
{

  options.features.opencode = {
  };

  config = lib.mkIf cfg.enable {

    services.podman.containers.${containerName} = {
      image = "docker.io/smanx/opencode:latest";
      autoStart = true;

      # loopback only, exposed through nginx
      ports = [
        "127.0.0.1:4096:4096"
      ];

      # environment file with:
      #   OPENCODE_SERVER_USERNAME=<...>
      #   OPENCODE_SERVER_PASSWORD=<...>
      environmentFile = [
        "/run/secrets/opencode/server/env"
      ];

      volumes = [
        "${dataDir}/config:/root/.config/opencode"
        "${dataDir}/data:/root/.local/share/opencode"
        "${dataDir}/state:/root/.local/state/opencode"
        "${dataDir}/cache:/root/.cache/opencode"

        # projects visible in the container home directory
        "${dot.code}/rick:/root/rick"
        "${dot.code}/janelle:/root/janelle"
      ];
    };

  };

}
