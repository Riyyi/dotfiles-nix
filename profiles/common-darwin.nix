{ config, pkgs, lib, inputs, dot, ... }:

{
  imports = [
    # Fix Spotlight not finding apps
    inputs.mac-app-util.darwinModules.default

    # Home Manager
    inputs.home-manager-darwin.darwinModules.home-manager {
      home-manager.sharedModules = [
        inputs.mac-app-util.homeManagerModules.default
      ];
    }

    # Homebrew
    inputs.nix-homebrew.darwinModules.nix-homebrew {
      nix-homebrew = {
        enable = true;
        enableRosetta = true;
        user = dot.user; # owner of Homebrew prefix

        # Declarative tap management
        taps = {
          "homebrew/homebrew-core" = inputs.homebrew-core;
          "homebrew/homebrew-cask" = inputs.homebrew-cask;
        };
        mutableTaps = false;
      };
    }
  ];

  # Overlays
  nixpkgs.overlays = lib.mkAfter [
    inputs.firefox-addons.overlays.default
    (import ./../user/autoraise.overlay.nix)
  ];

  # Nix settings
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ]; # enable flakes
    optimise.automatic = true; # store optimizer on a daily timer
  };

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
