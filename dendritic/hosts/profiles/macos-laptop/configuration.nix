{

  flake.modules.darwin."darwinConfigurations/macos-laptop" =
    {
      inputs,
      config,
      lib,
      ...
    }:
    {
      imports =
        with inputs.self.modules.generic;
        with inputs.self.modules.darwin;
        [
          # hosts-common
          sops
        ];

      # TEST options
      programs.zsh.interactiveShellInit = lib.mkAfter ''
        export TOBY="${config.dot.hostname}";
      '';
    };

  flake.modules.homeManager."darwinConfigurations/macos-laptop" =
    {
      inputs,
      ...
    }:
    {
      imports =
        with inputs.self.modules.generic;
        with inputs.self.modules.homeManager;
        [
          firefox
        ];
    };

}
