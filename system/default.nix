{ ... }:
{

  imports = [
    ./firewall.nix
    ./gitea.nix
    ./immich.nix
    ./jellyfin.nix
    ./mysql.nix
    ./navidrome.nix
    ./nextcloud.nix
    ./nfs.nix
    ./nginx.nix
    ./postgresql.nix
    ./samba.nix
    ./syncthing.nix
    ./transmission.nix
  ];

}
