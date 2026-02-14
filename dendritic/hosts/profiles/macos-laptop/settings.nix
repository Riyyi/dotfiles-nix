{

  flake.modules.darwin."darwinConfigurations/macos-laptop" =
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

            dot.system = "aarch64-darwin";
            dot.hostname = "macos-laptop";
            dot.timezone = "Europe/Amsterdam";
            dot.locale = "en_US.UTF-8";
            dot.version = "25.05";

            # Paths
            # ----------------------------------

            dot.home = "/Users/${dot.user}";

            dot.dotfiles = "${dot.home}/Code/nix/dotfiles-nix";

            # ----------------------------------
            # User

            dot.user = "rick";
            dot.group = "users";
            dot.sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINAag0kZm0MYNKz5ixAfY4XXJmwoB+Zij6egvw6h2C6/ riyyi3@gmail.com";

          }
        ];
    };
}
