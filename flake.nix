{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      # Get all profiles from the profiles directory
      profileContents = builtins.readDir ./profiles;
      isDirectory = name: profileContents.${name} == "directory";
      profiles = builtins.filter isDirectory (builtins.attrNames profileContents);

      cwd = builtins.toPath ./.;  # active store directory
    in
      {
        # Create a configuration for each profile
        nixosConfigurations = builtins.listToAttrs (map (profile:
          let
            dot = import ./profiles/${profile}/settings.nix;
          in {
            name = dot.hostname;
            value = nixpkgs.lib.nixosSystem {
              system = dot.system;
              specialArgs = {
                inherit inputs dot cwd;
              };
              modules = [
                ./profiles/${profile}/configuration.nix
              ];
            };
          }
        ) profiles);
      };

}
