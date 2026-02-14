{
  inputs,
  outputs,
  rootPath,
  ...
}:

let
  # Loop through all profiles and create a configuration for matching system types
  addProfiles =
    { system, mkConfiguration }:
    let
      matchSystem = profile: (import "${rootPath}/hosts/profiles/${profile}/settings.nix").system == system;
    in
    builtins.readDir "${rootPath}/hosts/profiles"
    |> inputs.nixpkgs.lib.filterAttrs (name: type: type == "directory")
    |> builtins.attrNames
    |> builtins.filter matchSystem
    |> builtins.map mkConfiguration
    |> builtins.listToAttrs;

  cwd = rootPath; # active store directory
in
{
  flake = {

    # ==================================== #
    # NixOS Profiles #

    nixosConfigurations =
      let
        mkConfiguration =
          profile:
          let
            dot = import "${rootPath}/hosts/profiles/${profile}/settings.nix";
          in
          {
            name = dot.hostname;
            value = inputs.nixpkgs.lib.nixosSystem {
              system = dot.system;
              specialArgs = {
                inherit
                  inputs
                  outputs
                  dot
                  cwd
                  ;
              };
              modules = [
                "${rootPath}/hosts/profiles/${profile}/configuration.nix"
                "${rootPath}/hosts/profiles/${profile}/disko.nix"
                "${rootPath}/hosts/profiles/${profile}/disko-mount.nix"
                inputs.self.modules.nixos."nixosConfigurations/${profile}"
              ];
            };
          };
      in
      addProfiles {
        system = "x86_64-linux";
        mkConfiguration = mkConfiguration;
      };

    # ==================================== #
    # Darwin Profiles #

    darwinConfigurations =
      let
        mkConfiguration =
          profile:
          let
            dot = import "${rootPath}/hosts/profiles/${profile}/settings.nix";
          in
          {
            name = dot.hostname;
            value = inputs.nix-darwin.lib.darwinSystem {
              system = dot.system;
              specialArgs = {
                inherit
                  inputs
                  outputs
                  dot
                  cwd
                  ;
              };
              modules = [
                "${rootPath}/hosts/profiles/${profile}/configuration.nix"
                inputs.self.modules.darwin."darwinConfigurations/${profile}"
              ];
            };
          };
      in
      addProfiles {
        system = "aarch64-darwin";
        mkConfiguration = mkConfiguration;
      };

  };
}
