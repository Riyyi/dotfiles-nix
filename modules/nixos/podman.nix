{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.podman;

  user = "podman";
  group = user;
in
{

  options.features.podman = {
  };

  config = lib.mkIf cfg.enable {

    users.groups."${group}" = {
      name = "${group}";
    };

    users.users."${user}" = {
      group = group;
      home = "/home/${user}";
      linger = true; # keep containers running even when user is not logged in
      isNormalUser = true;
      shell = pkgs.bash;
    };

    virtualisation.podman = {
      enable = true;
      autoPrune.enable = true;

      # 'docker' alias for podman, drop-in replacement
      dockerCompat = true;

      # Allow containers to communicate to each other
      defaultNetwork.settings.dns_enabled = true;
    };

    virtualisation.oci-containers.backend = "podman";

  };

}
