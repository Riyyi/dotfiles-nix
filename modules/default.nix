{ lib, ... }:

{

  # In this file we define all the modules that exist,
  # from any of the (evaluation-specific) directories

  options.features = {

    aerospace = {
      enable = lib.mkEnableOption "aerospace";
    };

    autoraise = {
      enable = lib.mkEnableOption "autoraise";
    };

    beets = {
      enable = lib.mkEnableOption "beets";
    };

    firefox = {
      enable = lib.mkEnableOption "firefox";
    };

    firewall = {
      enable = lib.mkEnableOption "firewall";
    };

    ghostty = {
      enable = lib.mkEnableOption "ghostty";
    };

    git = {
      enable = lib.mkEnableOption "git";
    };

    gitea = {
      enable = lib.mkEnableOption "gitea";
    };

    hammerspoon = {
      enable = lib.mkEnableOption "hammerspoon";
    };

    immich = {
      enable = lib.mkEnableOption "immich";
    };

    jankyborders = {
      enable = lib.mkEnableOption "jankyborders";
    };

    jellyfin = {
      enable = lib.mkEnableOption "jellyfin";
    };

    ksmbd = {
      enable = lib.mkEnableOption "ksmbd";
    };

    mpv = {
      enable = lib.mkEnableOption "mpv";
    };

    mysql = {
      enable = lib.mkEnableOption "mysql";
    };

    navidrome = {
      enable = lib.mkEnableOption "navidrome";
    };

    nextcloud = {
      enable = lib.mkEnableOption "nextcloud";
    };

    nfs = {
      enable = lib.mkEnableOption "nfs";
    };

    nginx = {
      enable = lib.mkEnableOption "nginx";
    };

    nvim = {
      enable = lib.mkEnableOption "nvim";
    };

    postgresql = {
      enable = lib.mkEnableOption "postgresql";
    };

    qbittorrent-nox = {
      enable = lib.mkEnableOption "qbittorrent";
    };

    samba = {
      enable = lib.mkEnableOption "samba";
    };

    sketchybar = {
      enable = lib.mkEnableOption "sketchybar";
    };

    syncthing = {
      enable = lib.mkEnableOption "syncthing";
    };

    transmission = {
      enable = lib.mkEnableOption "transmission";
    };

    zsh = {
      enable = lib.mkEnableOption "zsh";
    };

  };

}
