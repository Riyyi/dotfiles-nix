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
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDwMjqBU9ihK/i8mWkvCcylbIxv9z4vhMlC2mvJQdnmUVuKgW6vPoY2Lp1jI0Bag+yGzV6KFRcgoOp9QxZhFczN2nDirBqqIRQtRJgaZgR+HiDVSDogFzCWEJcbfk1MUq593JferGtqGGcMfV3XoECZjbyecCQoQ4KC0q/LQDJLNu2wGyes/B0DGRiG9XfmUbgRz63uifmQ3P3A4MnUKetfte9O3vrhOJfFxbpPp1qufFL8dp1g/SLh4u5h1vN/yMa5LII1ro05cnXjT1nNboJWITMnBxiTBTWsnFDJsPvZ4TDP8cRUO1BV341sWKecUnAdM/6DTktxJLW9WywgMYJy9nEJ49bjR1H31p9M4mIERcMBurkTZ3Fxtq91n+CcXof2QzEVL7us8Z217ycm9qTztQuF9Y9GW1pF4tHKTHug+uQWMofJngU7/Pfj0ZcgLu0WIqkeC47iCB2g8BGlRybOyDp9vEmXQkGIr37s95MwzoDa5BJngvJGE7FIZp20F9iMVwq2Avim2GdW2/obqwxP/jfcMZXGSBGOE4Acp+J4DirLniL9SR26PuVQczb70uwjD4KQJ0ZCGL/SLUDPVb4+bwEJWMTlt416d1DyFtZPvAhMiXJFXcGDDAdWdxaqj3HOLo2R3mDOqu8onDl00JBO8DgyMn9ikZvejPGoFhuhMw== riyyi3@gmail.com"
    ];
  };

  # Define a user account
  users.users.${dot.user} = {
    isNormalUser = true;
    description = dot.user;
    extraGroups = lib.mkAfter [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDwMjqBU9ihK/i8mWkvCcylbIxv9z4vhMlC2mvJQdnmUVuKgW6vPoY2Lp1jI0Bag+yGzV6KFRcgoOp9QxZhFczN2nDirBqqIRQtRJgaZgR+HiDVSDogFzCWEJcbfk1MUq593JferGtqGGcMfV3XoECZjbyecCQoQ4KC0q/LQDJLNu2wGyes/B0DGRiG9XfmUbgRz63uifmQ3P3A4MnUKetfte9O3vrhOJfFxbpPp1qufFL8dp1g/SLh4u5h1vN/yMa5LII1ro05cnXjT1nNboJWITMnBxiTBTWsnFDJsPvZ4TDP8cRUO1BV341sWKecUnAdM/6DTktxJLW9WywgMYJy9nEJ49bjR1H31p9M4mIERcMBurkTZ3Fxtq91n+CcXof2QzEVL7us8Z217ycm9qTztQuF9Y9GW1pF4tHKTHug+uQWMofJngU7/Pfj0ZcgLu0WIqkeC47iCB2g8BGlRybOyDp9vEmXQkGIr37s95MwzoDa5BJngvJGE7FIZp20F9iMVwq2Avim2GdW2/obqwxP/jfcMZXGSBGOE4Acp+J4DirLniL9SR26PuVQczb70uwjD4KQJ0ZCGL/SLUDPVb4+bwEJWMTlt416d1DyFtZPvAhMiXJFXcGDDAdWdxaqj3HOLo2R3mDOqu8onDl00JBO8DgyMn9ikZvejPGoFhuhMw== riyyi3@gmail.com"
    ];
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
      AllowUsers = [ "root" dot.user ];
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
