{ pkgs, system, ... }:

{
  default = pkgs.mkShell {
    NIX_CONFIG = "experimental-features = nix-command flakes pipe-operators";
    nativeBuildInputs = with pkgs; [
      deadnix
      git
      nixd
      nixfmt-tree
      sops
      statix
    ];
    shellHook = ''
      export PS1="nix> "

      alias repl="${pkgs.nix}/bin/nix repl --expr '
        let
          flake = builtins.getFlake (toString ./.);
          pkgs = flake.inputs.nixpkgs.legacyPackages.${system};
          lib = flake.inputs.nixpkgs.lib;
        in
          flake // { inherit pkgs lib; }
      '"
    '';
  };
}

# References:
# - https://nixos.wiki/wiki/Flakes#Output_schema (devShells)
# - https://nix.dev/tutorials/first-steps/declarative-shell.html
# - https://github.com/EmergentMind/nix-config/blob/dev/shell.nix
# - https://www.youtube.com/watch?v=swiWnAwionc (Nix REPL)
