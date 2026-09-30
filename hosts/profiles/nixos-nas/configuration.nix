{
  config,
  cwd,
  dot,
  inputs,
  lib,
  pkgs,
  ...
}:

{
  # ----------------------------------------
  # Imports

  imports = [
    # Hosts
    ./../../common
    ./../../nixos
    # Modules
    ./../../../modules
    ./../../../modules/common
    ./../../../modules/nixos
  ];

  # ----------------------------------------
  # Bootloader

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = {
    zfs = true;
  };
  boot.kernelParams = [ "zfs.zfs_arc_max=21474836480" ]; # 20 GiB
  boot.zfs.extraPools = [ "znas" ];

  # Software RAID support must be enabled explicitly so mdadm is included in
  # the initrd and the root RAID1 array is assembled before fsck/mount.
  boot.swraid.enable = true;
  boot.swraid.mdadmConf = ''
    MAILADDR=nobody@nowhere
    # Treat arrays from any homehost as local. This matches the by-id symlink
    # naming used by disko (md-name-any:raid1) and avoids assembly failures
    # after hostname changes or reinstalls.
    HOMEHOST <ignore>
    # Deterministic assembly for the root array.
    # Fill in the UUID by running:
    #   mdadm --detail /dev/md/raid1 | grep UUID
    ARRAY /dev/md/raid1 metadata=1.2 UUID=0ec5db07:9a033314:bb7c2184:808532f7
  '';

  # Some modules we don't need on a headless server
  boot.blacklistedKernelModules = [
    # Audio
    "snd_compress"
    "snd_hda_codec"
    "snd_hda_codec_generic"
    "snd_hda_codec_hdmi"
    "snd_hda_codec_realtek"
    "snd_hda_core"
    "snd_hda_ext_core"
    "snd_hda_intel"
    "snd_hwdep"
    "snd_intel_dspcfg"
    "snd_intel_sdw_acpi"
    "snd_pcm"
    "snd_soc_avs"
    "snd_soc_core"
    "snd_soc_hda_codec"
    "snd_timer"
    "soundcore"

    # Input devices (PS/2 stack)
    "atkbd"
    "i8042"
    "libps2"
    "psmouse"
    "serio"
    "serio_raw"
    "vivaldi_fmap"
  ];

  networking.hostId = "b267d9ef"; # required by ZFS

  # Mirrored boot doesnt work with systemd-boot yet, so manually copy contents
  system.activationScripts.duplicateESP = ''
    cp -a /boot/. /boot2/
  '';

  # ----------------------------------------
  # Users

  # NOTE: Add the root password to sops/secrets/secrets.yaml under the key
  # `root-password` by running:
  #   sops sops/secrets/secrets.yaml
  # Generate the hash with: mkpasswd -m sha-512
  # This unlocks the root account so emergency mode can spawn a console.
  sops.secrets.root-password = {
    neededForUsers = true;
  };

  users.users.root = {
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [ dot.sshKey ];
    hashedPasswordFile = config.sops.secrets.root-password.path;
  };

  # Define a user account
  users.users.${dot.user} = {
    isNormalUser = true;
    description = dot.user;
    extraGroups = lib.mkAfter [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [ dot.sshKey ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs dot cwd; };
    users.root = import ./root.nix;
    users.${dot.user} = import ./home.nix;
    users.podman = import ../../../modules/home-manager/podman.nix;
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
    beets
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
    #nextcloud34
    nfs-utils
    nginx
    nh
    nixd
    nixfmt
    nixfmt-tree
    ns
    openssh
    openssl
    pciutils # lspci
    php
    postgresql_16
    postgresql16Packages.vectorchord
    qbittorrent-nox
    rclone
    redis
    rsync
    samba4Full
    sops
    sqlite
    ssh-to-age
    sudo
    syncthing
    tlp
    tmux
    transmission_4
    tree
    vpl-gpu-rt
    yt-dlp
    zfs
    zsh
  ];

  hardware.enableAllFirmware = true; # load all firmware, required for i915/dg2
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # add packages to the graphics driver lookup path
      intel-media-driver
      intel-compute-runtime
      libva
      libvpl
      vpl-gpu-rt
    ];
  };

  # ----------------------------------------
  # System modules

  features.gitea.enable = true;
  features.immich.enable = true;
  features.jellyfin.enable = true;
  features.ksmbd.enable = true;
  features.navidrome.enable = true;
  # features.nextcloud.enable = true;
  features.nfs.enable = true;
  features.nginx.enable = true;
  features.opencode.enable = true;
  features.qbittorrent-nox.enable = true;
  # features.samba.enable = true;
  features.syncthing.enable = true;
  # features.transmission.enable = true;
  features.zsh.enable = true;

  # ----------------------------------------
  # Services

  services.fstrim.enable = true;

  services.zfs = {
    autoScrub.enable = true;
    autoSnapshot = {
      enable = true;
      flags = "-k -p --utc"; # make snapshot names use utc timestamp
      monthly = 3; # keep 3 monthly snapshots
      weekly = 4; # keep 4 weekly snapshots
      daily = 7; # keep 7 daily snapshots
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
      AllowUsers = [
        "root"
        dot.user
        "git"
      ];
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "yes";
    };
  };

  services.tlp = {
    enable = true;
    settings = {
      TLP_AUTO_SWITCH = 0;
      TLP_DEFAULT_MODE = "BAT";
      TLP_PERSISTENT_DEFAULT = 1;

      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "power";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      USB_AUTOSUSPEND = 1;

      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "off";
    };
  };

  # ----------------------------------------
  # Firewall

  # Open ports in the firewall
  features.firewall.enable = true;
  features.firewall.safeTCPPorts = lib.mkAfter [ 4000 ]; # open port to all IPs

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
