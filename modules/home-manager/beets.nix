{
  config,
  pkgs,
  lib,
  dot,
  ...
}:

let
  cfg = config.features.beets;
in
{

  options.features.beets = {
  };

  config = lib.mkIf cfg.enable {

    programs.beets = {
      enable = true;
      package = pkgs.beets;
      settings = {
        directory = dot.music;
        library = "${dot.config}/beets/musiclibrary.db";
        import.copy = "no";
        plugins = [
          "musicbrainz"
          "chroma"
        ];
      };
    };

  };

}
