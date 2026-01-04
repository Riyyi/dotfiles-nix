{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  dot,
  ...
}:

{
  imports = [
    # Fix Spotlight not finding apps
    inputs.mac-app-util.darwinModules.default

    # Home Manager
    inputs.home-manager-darwin.darwinModules.home-manager
    {
      home-manager.sharedModules = [
        inputs.mac-app-util.homeManagerModules.default
      ];
    }

    # Sops
    inputs.sops-nix.darwinModules.sops

    # Homebrew
    inputs.nix-homebrew.darwinModules.nix-homebrew
    {
      nix-homebrew = {
        enable = true;
        enableRosetta = true;
        user = dot.user; # owner of Homebrew prefix

        # Declarative tap management
        taps = {
          "homebrew/homebrew-core" = inputs.homebrew-core;
          "homebrew/homebrew-cask" = inputs.homebrew-cask;
          "sikarugir-app/homebrew-sikarugir" = inputs.homebrew-sikarugir;
        };
        mutableTaps = false;
      };
    }
  ];

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
  sops.defaultSopsFile = ./../sops/secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.generateKey = false;
  sops.age.sshKeyPaths = [ "/Users/${dot.user}/.ssh/id_ed25519" ];
  sops.gnupg.sshKeyPaths = [ ]; # do not import
  programs.zsh.interactiveShellInit = inputs.nixpkgs.lib.mkAfter ''
    export SOPS_AGE_KEY_CMD="ssh-to-age -private-key -i /Users/${dot.user}/.ssh/id_ed25519"
  '';

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nixpkgs.hostPlatform = dot.system;

  networking.hostName = dot.hostname;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  system.primaryUser = dot.user; # required for homebrew.enable for now

  # Set your time zone
  time.timeZone = dot.timezone;

}
