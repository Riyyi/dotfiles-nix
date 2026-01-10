{
  dot,
  inputs,
  lib,
  outputs,
  ...
}:

{

  imports = [ ];

  # Overlays
  nixpkgs.overlays = lib.mkAfter [
    outputs.overlays.default
  ];

  # Nix settings
  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operators"
    ]; # enable flakes
    optimise.automatic = true; # store optimizer on a daily timer
  };

  # Configure sops
  sops.defaultSopsFile = ./../../sops/secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.generateKey = false;
  sops.age.sshKeyPaths = [ "${dot.home}/.ssh/id_ed25519" ];
  sops.gnupg.sshKeyPaths = [ ]; # do not import
  programs.zsh.interactiveShellInit = inputs.nixpkgs.lib.mkAfter ''
    export SOPS_AGE_KEY_CMD="ssh-to-age -private-key -i ${dot.home}/.ssh/id_ed25519"
  '';

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = dot.system;

  networking.hostName = dot.hostname;

  # Set your time zone
  time.timeZone = dot.timezone;

}
