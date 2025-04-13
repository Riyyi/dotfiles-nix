{

  # ----------------------------------
  # System

  system = "x86_64-linux";
  hostname = "nixos-nas";
  timezone = "Europe/Amsterdam";
  locale = "en_US.UTF-8";
  version = "24.11";

  # Paths
  # ----------------------------------

  cache = "/mnt/data/cache";
  code = "/mnt/data/code";
  config = "/mnt/data/config";
  downloads = "/mnt/data/downloads";

  # ----------------------------------
  # User

  user = "rick";
  group = "users";

}
