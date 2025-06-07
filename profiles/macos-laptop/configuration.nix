{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    # Fix Spotlight not finding apps
    inputs.mac-app-util.darwinModules.default
    # Home Manager
    inputs.home-manager-darwin.darwinModules.default
    # Homebrew
    inputs.nix-homebrew.darwinModules.nix-homebrew {
      nix-homebrew = {
        enable = true;
        enableRosetta = true;
        user = "rick"; # owner of Homebrew prefix

        # Declarative tap management
        taps = {
          "homebrew/homebrew-core" = inputs.homebrew-core;
          "homebrew/homebrew-cask" = inputs.homebrew-cask;
        };
        mutableTaps = false;
      };
    }
  ];

  networking.hostName = "macos-laptop";

  # ZSH
  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];

  users.users.root = {
    shell = pkgs.zsh;
  };

  # Define a user account
  users.users."rick" = {
    packages = with pkgs; [];
    shell = pkgs.zsh;
    home = "/Users/rick"; # required here AND home.nix: https://discourse.nixos.org/t/homedirectory-is-note-of-type-path-darwin/57453/7
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users."rick" = import ./home.nix;
  };

  # ----------------------------------------
      
  nixpkgs.config.allowUnfree = true;
  
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    aerospace
    coreutils
    fastfetch
    firefox
    git
    htop
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
  
  system.primaryUser = "rick"; # required for homebrew.enable for now
  homebrew = {
    enable = true;
    brews = [
      "mas"
    ];
    casks = [
      "ghostty"
      "karabiner-elements"
      "keepassxc"
      "krita"
      "mysqlworkbench"
    ];
    masApps = {
      # App store apps goo here
    };
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
  
  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";
  
  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;
  
  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
  
  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  
  # macOS system settings
  system.defaults = {
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
  };
  system.startup.chime = false;
  
  power.sleep.allowSleepByPowerButton = true;
  power.sleep.computer = 30;
  power.sleep.display = 10;
  
  # -----------------------------------
  # Programs
  
  # These seem to require home-manager?
  #programs.firefox.enable = true;
  #programs.firefox.nativeMessagingHosts.ff2mpv = true;
  #programs.firefox.nativeMessagingHosts.packages = [
  #  "ff2mpv-go"
  #];

}
