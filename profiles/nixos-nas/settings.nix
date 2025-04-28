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
  downloads = "/mnt/data/downloads";
  music = "/mnt/data/music";
  pictures = "/mnt/data/pictures";

  # ----------------------------------
  # User

  user = "rick";
  group = "users";

}
