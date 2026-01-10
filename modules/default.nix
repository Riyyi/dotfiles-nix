{ lib, ... }:

{

  # In this file we define all the modules that exist,
  # from any of the (evaluation-specific) directories

  options.features = {
    aerospace = lib.mkEnableOption "aerospace";
    autoraise = lib.mkEnableOption "autoraise";
    beets = lib.mkEnableOption "beets";
    firefox = lib.mkEnableOption "firefox";
    firewall = lib.mkEnableOption "firewall";
    ghostty = lib.mkEnableOption "ghostty";
    git = lib.mkEnableOption "git";
    gitea = lib.mkEnableOption "gitea";
    hammerspoon = lib.mkEnableOption "hammerspoon";
    immich = lib.mkEnableOption "immich";
    jankyborders = lib.mkEnableOption "jankyborders";
    jellyfin = lib.mkEnableOption "jellyfin";
    ksmbd = lib.mkEnableOption "ksmbd";
    mpv = lib.mkEnableOption "mpv";
    mysql = lib.mkEnableOption "mysql";
    navidrome = lib.mkEnableOption "navidrome";
    nextcloud = lib.mkEnableOption "nextcloud";
    nfs = lib.mkEnableOption "nfs";
    nginx = lib.mkEnableOption "nginx";
    nvim = lib.mkEnableOption "nvim";
    postgresql = lib.mkEnableOption "postgresql";
    qbittorrent-nox = lib.mkEnableOption "qbittorrent";
    samba = lib.mkEnableOption "samba";
    sketchybar = lib.mkEnableOption "sketchybar";
    syncthing = lib.mkEnableOption "syncthing";
    transmission = lib.mkEnableOption "transmission";
    zsh = lib.mkEnableOption "zsh";
  };

}
