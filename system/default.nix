{ lib, dot, ... }:

{

  imports = []
  ++ lib.optionals (lib.hasSuffix "-linux" dot.system) [
    ./firewall.nix
    ./gitea.nix
    ./immich.nix
    ./jellyfin.nix
    ./ksmbd.nix
    ./mysql.nix
    ./navidrome.nix
    ./nextcloud.nix
    ./nfs.nix
    ./nginx.nix
    ./postgresql.nix
    ./qbittorrent.nix
    ./samba.nix
    ./syncthing.nix
    ./transmission.nix
  ]
  ++ lib.optionals (lib.hasSuffix "-darwin" dot.system) [
    ../user/hammerspoon.system.nix
  ];

}
