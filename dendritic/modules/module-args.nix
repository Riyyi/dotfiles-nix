{
  lib,
  ...
}:

{

  options.moduleArgs = {
    rootPath = lib.mkOption {
      type = lib.types.path;
      default = null;
      description = "Path to the root of the repository";
    };
  };

}
