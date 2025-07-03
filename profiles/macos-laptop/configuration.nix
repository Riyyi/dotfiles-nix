{ config, pkgs, inputs, dot, cwd, ... }:

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
    ];
    casks = [
      "ghostty"
      "karabiner-elements"
      "keepassxc"
      "krita"
      "mysqlworkbench"
      "openmtp"
    ];
    masApps = {
      # App store apps go here
    };
  };
  
  environment.systemPackages = with pkgs; [
    aerospace
    autoraise
    coreutils
    cyberduck
    fastfetch
    ff2mpv-go
    firefox
    # ghostty # broken
    git
    htop
    iina
    jankyborders
    jq
    # keepassxc # broken
    # krita # unavailable on arm
    mpv
    # mysql-workbench # unavailable on arm
    neovim
    openssh
    qbittorrent
    rsync
    sketchybar
    soundsource
    streamlink
    syncthing
    tree
    wget
    yt-dlp
    zsh
  ];
  
  # -----------------------------------
  # Programs
  
  # These seem to require home-manager?
  #programs.firefox.enable = true;
  #programs.firefox.nativeMessagingHosts.ff2mpv = true;
  #programs.firefox.nativeMessagingHosts.packages = [
  #  "ff2mpv-go"
  #];

  # ----------------------------------------
  # System modules

  # ----------------------------------------
  # System settings

  # macOS system settings
  system.defaults = {
    dock.autohide = true;
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
    NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;
    NSGlobalDomain.NSWindowShouldDragOnGesture = true;
    #universalaccess.reduceMotion = true;
  };
  system.startup.chime = false;
  
  power.sleep.allowSleepByPowerButton = true;
  power.sleep.computer = 30;
  power.sleep.display = 10;

  # ----------------------------------------
  # Services

  # ----------------------------------------
  # Other

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
}
