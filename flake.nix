# sudo nixos-rebuild switch --use-remote-sudo --flake /etc/nixos#nixos-nas

{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      dot = {
        # ----------------------------------
        # System
        system = "x86_64-linux";
        hostname = "nixos-nas";
        timezone = "Europe/Amsterdam";
        locale = "en_US.UTF-8";
        version = "24.11";
        # ----------------------------------
        # User
        user = "rick";
        group = "users";
      };
    in
      {
        nixosConfigurations = {
          nixos-nas = nixpkgs.lib.nixosSystem {
            system = dot.system;
            specialArgs = {
              inherit inputs dot;
            };
            modules = [
              ./configuration.nix
            ];
          };
        };
      };

}
