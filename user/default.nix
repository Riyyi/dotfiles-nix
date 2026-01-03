{ lib, dot, ... }:

{

  imports = [
    ./beets.nix
    ./firefox.nix
    ./ghostty.nix
    ./git.nix
    ./mpv.nix
    ./nvim.nix
    ./zsh.nix
  ]
  ++ lib.optionals (lib.hasSuffix "-linux" dot.system) [ ]
  ++ lib.optionals (lib.hasSuffix "-darwin" dot.system) [
    ./aerospace.nix
    ./autoraise.nix
    ./hammerspoon.nix
    ./jankyborders.nix
    ./sketchybar.nix
  ];

}
