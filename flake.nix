{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, disko, home-manager, ... }:
    let
      # Get all profiles from the profiles directory
      profileContents = builtins.readDir ./profiles;
      isDirectory = name: profileContents.${name} == "directory";
      profiles = builtins.filter isDirectory (builtins.attrNames profileContents);

      cwd = builtins.toPath ./.;  # active store directory

      system = "x86_64-linux";
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
                ./profiles/${profile}/disko.nix
                ./profiles/${profile}/disko-mount.nix
                ./profiles/hardware-configuration.nix
              ];
            };
          }
        ) profiles);

        # Bootstrap script
        packages.${system} =
          let
            pkgs = import nixpkgs { inherit system; };
          in {
            default = self.packages.${system}.install;
            install = pkgs.writeShellApplication {
              name = "install";
              runtimeInputs = with pkgs; [ git ];
              text = ''${builtins.readFile ./install.sh}'';
            };
          };
        apps.${system} = {
          default = self.apps.${system}.install;
          install = {
            type = "app";
            program = "${self.packages.${system}.install}/bin/install";
          };
        };

      };

}
