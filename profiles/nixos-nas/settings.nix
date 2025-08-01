{

  # ----------------------------------
  # System

  system = "x86_64-linux";
  hostname = "nixos-nas";
  timezone = "Europe/Amsterdam";
  locale = "en_US.UTF-8";
  version = "24.11";
  domain = "riyyi.com";

  # Paths
  # ----------------------------------

  cache = "/mnt/data/cache";
  code = "/mnt/data/code";
  config = "/mnt/data/config";
  documents = "/mnt/data/documents";
  dotfiles = "/etc/nixos";
  downloads = "/mnt/data/downloads";
  games = "/mnt/data/games";
  music = "/mnt/data/music";
  pictures = "/mnt/data/pictures";
  videos = "/mnt/data/videos";

  # ----------------------------------
  # User

  user = "rick";
  group = "users";
  sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINAag0kZm0MYNKz5ixAfY4XXJmwoB+Zij6egvw6h2C6/ riyyi3@gmail.com";

}
