{
  dot,
  inputs,
  ...
}:

{

  imports = [
    # disko
    inputs.disko.nixosModules.default

    # Home Manager
    inputs.home-manager.nixosModules.default

    # Sops
    inputs.sops-nix.nixosModules.sops
  ];

  # Enable networking
  networking.networkmanager.enable = true;
  networking.usePredictableInterfaceNames = false;

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
