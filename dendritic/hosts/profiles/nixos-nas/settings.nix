{

  flake.modules.darwin."nixosConfigurations/nixos-nas" =
    { inputs, ... }:
    {
      imports =
        (with inputs.self.modules.generic; [
          settings
        ])
        ++ [
          rec {

            # ----------------------------------
            # System

            dot.system = "x86_64-linux";
            dot.hostname = "nixos-nas";
            dot.timezone = "Europe/Amsterdam";
            dot.locale = "en_US.UTF-8";
            dot.version = "24.11";
            dot.domain = "riyyi.com";

            # Paths
            # ----------------------------------

            dot.home = "/home/${dot.user}";

            dot.cache = "/mnt/data/cache";
            dot.code = "/mnt/data/code";
            dot.config = "/mnt/data/config";
            dot.documents = "/mnt/data/documents";
            dot.dotfiles = "/etc/nixos";
            dot.downloads = "/mnt/data/downloads";
            dot.games = "/mnt/data/games";
            dot.music = "/mnt/data/music";
            dot.pictures = "/mnt/data/pictures";
            dot.videos = "/mnt/data/videos";

            # ----------------------------------
            # User

            dot.user = "rick";
            dot.group = "users";
            dot.sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINAag0kZm0MYNKz5ixAfY4XXJmwoB+Zij6egvw6h2C6/ riyyi3@gmail.com";

          }
        ];
    };
}
