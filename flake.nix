{
  description = "NixOS configuration";

  nixConfig = {
    extra-experimental-features = [ "pipe-operators" ];
  };

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

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

  outputs =
    inputs@{
      nixpkgs,
      self,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      import-tree =
        path:
        path
        |> lib.fileset.fileFilter (file: file.hasExt "nix" && !(lib.hasPrefix "_" file.name))
        |> lib.fileset.toList;

      inherit (self) outputs;
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = import-tree ./dendritic;

      _module.args.outputs = outputs;
      _module.args.rootPath = ./.;
    };

}

# References:
# - https://dendrix.oeiuwq.com/Dendritic.html
# - https://github.com/mightyiam/infra
# - https://flake.parts
# - https://github.com/EmergentMind/nix-config

# - https://github.com/mightyiam/dendritic
# - https://github.com/Doc-Steve/dendritic-design-with-flake-parts/wiki/Dendritic_Aspects
# - https://github.com/weegs710/AnomalOS
