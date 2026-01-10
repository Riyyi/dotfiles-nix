{
  dot,
  inputs,
  ...
}:

{

  imports = [
    # Home Manager
    inputs.home-manager-darwin.darwinModules.home-manager
    {
      home-manager.sharedModules = [
        inputs.mac-app-util.homeManagerModules.default
      ];
    }

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

    # Sops
    inputs.sops-nix.darwinModules.sops
  ];

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  system.primaryUser = dot.user; # required for homebrew.enable for now

}
