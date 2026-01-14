{
  fetchFromGitHub,
  fzf,
  nix-search-tv,
  writeShellApplication,
  ...
}:

let
  src = fetchFromGitHub {
    owner = "3timeslazy";
    repo = "nix-search-tv";
    tag = "v2.2.4";
    hash = "sha256-ygA9AF4PrM+4G+Le70UI12OQPIjLmELg3Xpkmc7nMz0=";
  };
in
writeShellApplication {
  name = "ns";
  runtimeInputs = [
    fzf
    nix-search-tv
  ];
  # HACK: Temporary fix, until 2.2.4 with its updated nixpkgs.sh is rolled out
  text = builtins.readFile "${src}/nixpkgs.sh";
  # text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
}

# References:
# - https://github.com/tonybanters/nixos-hyprland#nix-search-tv
