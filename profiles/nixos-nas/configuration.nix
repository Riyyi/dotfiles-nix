{ config, pkgs, lib, inputs, dot, cwd, ... }:

{
  # ----------------------------------------
  # Imports

  imports = [
    ./../common.nix
    ./../../system
  ];

  # ----------------------------------------
  # Bootloader

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = { zfs = true; };
  boot.kernelParams = [ "zfs.zfs_arc_max=21474836480" ]; # 20 GiB
  boot.zfs.extraPools = [ "znas" ];
  boot.swraid.mdadmConf = ''
    MAILADDR=nobody@nowhere
  '';

  networking.hostId = "b267d9ef"; # required by ZFS

  # Mirrored boot doesnt work with systemd-boot yet, so manually copy contents
  system.activationScripts.duplicateESP = ''
    cp -a /boot/. /boot2/
  '';

  # ----------------------------------------
  # Users

  # ZSH
  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];

	users.users.root = {
    isSystemUser = true;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [ dot.sshKey ];
  };

  # Define a user account
  users.users.${dot.user} = {
    isNormalUser = true;
    description = dot.user;
    extraGroups = lib.mkAfter [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [ dot.sshKey ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs dot cwd; };
    users.root = import ./root.nix;
    users.${dot.user} = import ./home.nix;
  };

  # Allow default user to write to SMB share directories
  system.activationScripts.userPermissions = ''
    for dir in ${dot.code} ${dot.documents} ${dot.downloads} ${dot.games} ${dot.music} ${dot.pictures} ${dot.videos}; do
      ${pkgs.acl}/bin/setfacl -R -m u:${dot.user}:rwX $dir
      ${pkgs.acl}/bin/setfacl -R -d -m u:${dot.user}:rwX $dir
    done
  '';

  # ----------------------------------------
  # Packages

  environment.systemPackages = with pkgs; [
    acl
    # collabora-online
    coreutils
    cpio # dependency of collabora
    duf
    exiftool
    fastfetch
    fzf
    gcc
    git
    gitea
    gnumake
    htop
    imagemagick
    immich
    intel-compute-runtime
    intel-gpu-tools
    intel-media-driver
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    ksmbd-tools
    libgcc
    libva
    libvpl
    lua-language-server
    mariadb
    navidrome
    ncdu
    neovim
    nextcloud31
    nfs-utils
    nginx
    nh
    nixd
    nixfmt-classic
    openssh
    openssl
    pciutils # lspci
    php
    postgresql_16
    postgresql16Packages.pgvecto-rs
    qbittorrent-nox
    rclone
    redis
    rsync
    samba4Full
    sops
    sqlite
    sudo
    syncthing
    tlp
    transmission_4
    tree
    vpl-gpu-rt
    zfs
    zsh
  ];

  hardware.enableAllFirmware = true; # load all firmware, required for i915/dg2
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ # add packages to the graphics driver lookup path
      intel-media-driver
      intel-compute-runtime
      libva
      libvpl
      vpl-gpu-rt
    ];
  };

  # ----------------------------------------
  # System modules

  gitea.enable = true;
  immich.enable = true;
  jellyfin.enable = true;
  ksmbd.enable = true;
  navidrome.enable = true;
  # nextcloud.enable = true;
  nfs.enable = true;
  nginx.enable = true;
  qbittorrent-nox.enable = true;
  # samba.enable = true;
  syncthing.enable = true;
  # transmission.enable = true;

  # ----------------------------------------
  # Services

  services.fstrim.enable = true;

  services.zfs = {
    autoScrub.enable = true;
    autoSnapshot = {
      enable = true;
      flags = "-k -p --utc"; # make snapshot names use utc timestamp
      monthly = 3; # keep 3 monthly snapshots
      weekly = 4;  # keep 4 weekly snapshots
      daily = 7;   # keep 7 daily snapshots
      hourly = 12; # keep 12 hourly snapshots
      frequent = 4; # keep 4 15-minute snapshots
    };
    trim.enable = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 4000 ];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = [ "root" dot.user "git" ];
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "yes";
    };
  };

  services.tlp.enable = true;

  # ----------------------------------------
  # Firewall

  # Open ports in the firewall
  firewall.enable = true;
  firewall.safeTCPPorts = lib.mkAfter [ 4000 ]; # open port to all IPs

  # ----------------------------------------
  # Other

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = dot.version; # Did you read the comment?
}
