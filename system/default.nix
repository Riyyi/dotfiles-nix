{ ... }:
{

  imports = [
    ./gitea.nix
    ./jellyfin.nix
    ./mysql.nix
    ./nextcloud.nix
    ./nginx.nix
    ./syncthing.nix
    ./transmission.nix
  ];

}
