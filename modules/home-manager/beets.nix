{
  config,
  pkgs,
  lib,
  dot,
  ...
}:

let
  # cfg = config.programs.beets;
in
{

  options.programs.beets = {
  };

  config = lib.mkIf config.features.beets {

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
