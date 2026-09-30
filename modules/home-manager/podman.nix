{
  config,
  lib,
  ...
}:

{

  imports = [
    ../.
    ./opencode.nix
    ./vaultwarden.nix
  ];

  home.username = "podman";
  home.homeDirectory = "/home/podman";
  home.stateVersion = "26.05";

  services.podman = {
    enable = true;
  };

  features.opencode.enable = true;
  features.vaultwarden.enable = true;

}
