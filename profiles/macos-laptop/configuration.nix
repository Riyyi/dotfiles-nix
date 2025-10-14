{ config, pkgs, pkgs-unstable, inputs, dot, cwd, ... }:

{
  # ----------------------------------------
  # Imports

  imports = [
    ./../common-darwin.nix
  ];

  # ----------------------------------------
  # Users

  # ZSH
  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];

  users.users.root = {
    shell = pkgs.zsh;
  };

  # Define a user account
  users.users.${dot.user} = {
    packages = with pkgs; [];
    shell = pkgs.zsh;
    home = "/Users/${dot.user}"; # required here AND home.nix, see
    # https://discourse.nixos.org/t/homedirectory-is-note-of-type-path-darwin/57453/7
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs dot cwd; };
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
    brewPrefix = "/opt/homebrew/bin";
    brews = [
      "mas"
      "sqlite" # nvim searches in /opt/homebrew by default?
    ];
    casks = [
      "font-dejavu-sans-mono-nerd-font"
      "ghostty"
      "hammerspoon"
      "karabiner-elements"
      "keepassxc"
      "krita"
      "mysqlworkbench"
      "openmtp"
    ];
    masApps = { # App store apps go here
      "uBlock Origin Lite" = 6745342698;
    };
  };

  environment.systemPackages = with pkgs; [
    aerospace
    aldente
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
    neovim
    # nerd-fonts.dejavu-sans-mono # doesnt become system font
    nixd
    nixfmt-classic
    omnisharp-roslyn
    openssh
    qbittorrent
    ripgrep
    rsync
    (pkgs-unstable.signal-desktop-bin)
    sketchybar
    soundsource
    streamlink
    syncthing
    tree
    typescript-language-server
    util-linux
    wget
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


  # ----------------------------------------
  # Services

  # ----------------------------------------
  # Other

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
}
