{ config, pkgs, inputs, dot, ... }:

{
  imports = [
    # disko
    inputs.disko.nixosModules.default
    # Home Manager
    inputs.home-manager.nixosModules.default
    # Sops
    inputs.sops-nix.nixosModules.sops
  ];

  # Nix settings
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" "pipe-operators" ]; # enable flakes
    optimise.automatic = true; # store optimizer on a daily timer
  };

  # Configure sops
  sops.defaultSopsFile = ./../sops/secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.generateKey = false;
  sops.age.sshKeyPaths = [ "/root/.ssh/id_ed25519" ];
  sops.gnupg.sshKeyPaths = []; # do not import

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  networking.hostName = dot.hostname;

  # Enable networking
  networking.networkmanager.enable = true;
  networking.usePredictableInterfaceNames = false;

  # Set your time zone
  time.timeZone = dot.timezone;

  # Select internationalisation properties
  i18n.defaultLocale = dot.locale;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = dot.locale;
    LC_IDENTIFICATION = dot.locale;
    LC_MEASUREMENT = dot.locale;
    LC_MONETARY = dot.locale;
    LC_NAME = dot.locale;
    LC_NUMERIC = dot.locale;
    LC_PAPER = dot.locale;
    LC_TELEPHONE = dot.locale;
    LC_TIME = dot.locale;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

}
