{ config, pkgs, lib, inputs, dot, cwd, ... }:

{
  imports = [
    ./../common.nix
    ./../../system
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = { zfs = true; };
  boot.kernelParams = [ "zfs.zfs_arc_max=21474836480" ]; # 20 GiB
  boot.zfs.extraPools = [ "znas" ];

  networking.hostId = "b267d9ef"; # required by ZFS

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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    coreutils
    duf
    exiftool
    fastfetch
    fzf
    git
    gitea
    htop
    imagemagick
    immich
    intel-compute-runtime
    intel-gpu-tools
    intel-media-driver
    intel-media-sdk
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    libva
    libvpl
    mariadb
    navidrome
    ncdu
    neovim
    nextcloud30
    nginx
    nh
    openssh
    php
    postgresql
    postgresql16Packages.pgvecto-rs
    rclone
    redis
    rsync
    sops
    sudo
    syncthing
    tlp
    transmission_4
    tree
    vpl-gpu-rt
    zfs
    zsh
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # System modules

  gitea.enable = true;
  immich.enable = true;
  jellyfin.enable = true;
  navidrome.enable = true;
  nextcloud.enable = false;
  nginx.enable = true;
  syncthing.enable = true;
  transmission.enable = true;

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

  # Open ports in the firewall
  firewall.enable = true;
  firewall.safeTCPPorts = lib.mkAfter [ 4000 ]; # open port to all IPs

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = dot.version; # Did you read the comment?
}
