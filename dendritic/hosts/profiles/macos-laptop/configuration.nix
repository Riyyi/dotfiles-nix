{

  flake.modules.darwin."darwinConfigurations/macos-laptop" =
    {
      inputs,
      config,
      lib,
      ...
    }:
    {
      imports = with inputs.self.modules.darwin; [
        sops
      ];

      # TEST options
      programs.zsh.interactiveShellInit = lib.mkAfter ''
        export TOBY="${config.dot.hostname}";
      '';
    };

}
