{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.11-darwin";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    home-manager-darwin.url = "github:nix-community/home-manager/release-25.11";
    home-manager-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    mac-app-util.url = "github:hraban/mac-app-util";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-sikarugir = {
      url = "github:sikarugir-app/homebrew-sikarugir";
      flake = false;
    };

  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, nix-darwin, ... }:
  let
    # Get all profiles from the profiles directory
    profileContents = builtins.readDir ./profiles;
    isDirectory = name: profileContents.${name} == "directory";
    profiles = builtins.filter isDirectory (builtins.attrNames profileContents);

    cwd = builtins.toPath ./.; # active store directory

    system = "x86_64-linux";
  in
  {
    # Create a configuration for each profile
    nixosConfigurations = builtins.listToAttrs (map (profile:
        let
          dot = import ./profiles/${profile}/settings.nix;
          pkgs-unstable = import nixpkgs-unstable {
            system = dot.system;
            config = { allowUnfree = true; };
          };
        in {
          name = dot.hostname;
          value = nixpkgs.lib.nixosSystem {
            system = dot.system;
            specialArgs = {
              inherit inputs dot cwd pkgs-unstable;
            };
            modules = [
              ./profiles/${profile}/configuration.nix
              ./profiles/${profile}/disko.nix
              ./profiles/${profile}/disko-mount.nix
              ./profiles/hardware-configuration.nix
            ];
          };
        }
      )
      # Only add nixosConfigurations from profiles that match
      (builtins.filter (profile:
        let
          dot = import ./profiles/${profile}/settings.nix;
        in
        dot.system == "x86_64-linux"
      ) profiles)
    );

    # Create a configuration for each profile
    darwinConfigurations = builtins.listToAttrs (map (profile:
        let
          dot = import ./profiles/${profile}/settings.nix;
          pkgs-unstable = import nixpkgs-unstable {
            system = dot.system;
            config = { allowUnfree = true; };
          };
        in {
          name = dot.hostname;
          value = nix-darwin.lib.darwinSystem {
            system = dot.system;
            specialArgs = {
              inherit inputs dot cwd pkgs-unstable;
            };
            modules = [
              ./profiles/${profile}/configuration.nix
            ];
          };
        }
      )
      # Only add nixosConfigurations from profiles that match
      (builtins.filter (profile:
        let
          dot = import ./profiles/${profile}/settings.nix;
        in
        dot.system == "aarch64-darwin"
      ) profiles)
    );

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
