{

  flake.modules.generic.settings =
    { lib, ... }:
    {
      options.dot = {

        # ----------------------------------
        # System

        system = lib.mkOption { type = lib.types.str; };
        hostname = lib.mkOption { type = lib.types.str; };
        timezone = lib.mkOption { type = lib.types.str; };
        locale = lib.mkOption { type = lib.types.str; };
        version = lib.mkOption { type = lib.types.str; };
        domain = lib.mkOption { type = lib.types.nullOr lib.types.str; };

        # Paths
        # ----------------------------------

        home = lib.mkOption { type = lib.types.str; };

        cache = lib.mkOption { type = lib.types.nullOr lib.types.str; };
        code = lib.mkOption { type = lib.types.nullOr lib.types.str; };
        config = lib.mkOption { type = lib.types.nullOr lib.types.str; };
        documents = lib.mkOption { type = lib.types.nullOr lib.types.str; };
        dotfiles = lib.mkOption { type = lib.types.str; };
        downloads = lib.mkOption { type = lib.types.nullOr lib.types.str; };
        games = lib.mkOption { type = lib.types.nullOr lib.types.str; };
        music = lib.mkOption { type = lib.types.nullOr lib.types.str; };
        pictures = lib.mkOption { type = lib.types.nullOr lib.types.str; };
        videos = lib.mkOption { type = lib.types.nullOr lib.types.str; };

        # ----------------------------------
        # User

        user = lib.mkOption { type = lib.types.str; };
        group = lib.mkOption { type = lib.types.str; };
        sshKey = lib.mkOption { type = lib.types.str; };

      };

    };
}
