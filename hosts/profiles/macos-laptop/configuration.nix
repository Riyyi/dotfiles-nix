{
  config,
  cwd,
  dot,
  inputs,
  pkgs,
  ...
}:

{
  # ----------------------------------------
  # Imports

  imports = [
    # Hosts
    ./../../common
    ./../../darwin
    # Modules
    ./../../../modules
    ./../../../modules/common
    ./../../../modules/darwin
  ];

  # ----------------------------------------
  # Users

  # nix-darwin cant set the shell of the root user
  # $ less /etc/shells
  # $ chsh -s /run/current-system/sw/bin/zsh root

  users.users.root = {
    shell = pkgs.zsh;
    home = "/var/root"; # required here AND root.nix, see
    # https://discourse.nixos.org/t/homedirectory-is-note-of-type-path-darwin/57453/7
  };

  # Define a user account
  users.users.${dot.user} = {
    description = dot.user;
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
    home = dot.home; # required here AND home.nix, see
    # https://discourse.nixos.org/t/homedirectory-is-note-of-type-path-darwin/57453/7
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs dot cwd; };
    users.root = import ./root.nix;
    users.${dot.user} = import ./home.nix;
  };

  # ----------------------------------------
  # Packages

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
    taps = builtins.attrNames config.nix-homebrew.taps;
    brewPrefix = "/opt/homebrew/bin";
    brews = [
      "mas"
    ];
    casks = [
      "font-dejavu-sans-mono-nerd-font"
      "ghostty"
      "hammerspoon"
      "karabiner-elements"
      "keepassxc"
      "krita"
      # "mysqlworkbench" # broken until zhaofengli/nix-homebrew updates to 5.0.7
      "openmtp"
      "sikarugir"
      "steam"
    ];
    masApps = {
      # App store apps go here
      "uBlock Origin Lite" = 6745342698;
    };
  };

  environment.systemPackages = with pkgs; [
    pkgs.unstable.aerospace
    pkgs.unstable.aldente
    autoraise
    cppcheck
    cmake
    coreutils
    cyberduck
    dotnet-ef
    fastfetch
    ff2mpv-go
    firefox
    fzf
    # ghostty # broken
    git
    htop
    intelephense
    jankyborders
    jetbrains.rider
    jq
    # keepassxc # broken
    # krita # unavailable on arm
    lua
    lua-language-server
    mesa
    moonlight-qt
    mpv
    # mysql-workbench # unavailable on arm
    ncdu
    neovim
    # nerd-fonts.dejavu-sans-mono # doesnt become system font
    nixd
    nixfmt
    nixfmt-tree
    ns
    omnisharp-roslyn
    openssh
    qbittorrent
    ripgrep
    rsync
    pkgs.unstable.signal-desktop-bin
    sketchybar
    sops
    soundsource
    sqlite
    ssh-to-age
    streamlink
    syncthing
    tokei
    tree
    typescript-language-server
    util-linux
    wget
    windsurf
    yt-dlp
    zsh
  ];

  # Some Apple specific packages are managed via:
  # softwareupdate --list
  # softwareupdate --install "Command Line Tools for Xcode 26.0-26.0"

  # ----------------------------------------
  # System settings

  # macOS system settings
  system.defaults = {
    dock.autohide = true;
    dock.expose-group-apps = true; # helps with small icons in Mission Control
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      CreateDesktop = false;
      FXEnableExtensionChangeWarning = false;
      FXRemoveOldTrashItems = true; # remove items older than 30 days
      QuitMenuItem = true;
      ShowPathbar = true;
      ShowStatusBar = true;
    };
    iCal."first day of week" = "Monday";
    loginwindow.GuestEnabled = false;
    NSGlobalDomain."com.apple.sound.beep.volume" = 0.000;
    NSGlobalDomain.AppleICUForce24HourTime = false;
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    NSGlobalDomain.AppleMeasurementUnits = "Centimeters";
    NSGlobalDomain.AppleMetricUnits = 1;
    NSGlobalDomain.AppleTemperatureUnit = "Celsius";
    NSGlobalDomain.NSAutomaticWindowAnimationsEnabled = false; # window open animation
    NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;
    NSGlobalDomain.NSWindowShouldDragOnGesture = true; # ctrl + cmd drag anywhere
    #universalaccess.reduceMotion = true;
  };
  system.startup.chime = false;

  power.sleep.allowSleepByPowerButton = true;
  power.sleep.computer = 30;
  power.sleep.display = 10;

  # ----------------------------------------
  # System modules

  features.zsh.enable = true;

  # ----------------------------------------
  # Services

  # ----------------------------------------
  # Other

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
}
