{ ... }:
{

  imports = [
    ./firewall.nix
    ./gitea.nix
    ./immich.nix
    ./jellyfin.nix
    ./mysql.nix
    ./nextcloud.nix
    ./navidrome.nix
    ./nginx.nix
    ./postgresql.nix
    ./syncthing.nix
    ./transmission.nix
  ];

}
