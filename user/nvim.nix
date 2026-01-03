{
  config,
  pkgs,
  lib,
  dot,
  ...
}:

let
  files = [
    ".config/nvim/init.lua"
    #".config/nvim/lazy-lock.json"

    ".config/nvim/after/ftplugin/lua.lua"

    ".config/nvim/lua/core/autocommands.lua"
    ".config/nvim/lua/core/buffers.lua"
    ".config/nvim/lua/core/config.lua"
    ".config/nvim/lua/core/filetypes.lua"
    ".config/nvim/lua/core/functions.lua"
    ".config/nvim/lua/core/globals.lua"
    ".config/nvim/lua/core/leader-key.lua"

    ".config/nvim/lua/core.lua"
    ".config/nvim/lua/development.lua"
    ".config/nvim/lua/editor.lua"
    ".config/nvim/lua/git.lua"
    ".config/nvim/lua/keybind-functions.lua"
    ".config/nvim/lua/keybinds.lua"
    ".config/nvim/lua/packages.lua"
    ".config/nvim/lua/selection.lua"
    ".config/nvim/lua/terminal.lua"
    ".config/nvim/lua/ui.lua"
  ];
in
{

  options.nvim = {
    enable = lib.mkEnableOption "nvim";
  };

  config = lib.mkIf config.nvim.enable {

    home.file =
      lib.genAttrs files (file: {
        source = ./dotfiles + "/${file}";
      })
      // {
        ".config/nvim/lua/nix.lua".text = ''
          vim.g.sqlite_clib_path = "${pkgs.sqlite.out}/lib/libsqlite3${pkgs.stdenv.hostPlatform.extensions.sharedLibrary}"
        '';
      };

    # lazy-lock.json wont be linked from Nix store, so it remains writable
    home.activation.nvim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ln -sf ${dot.dotfiles}/user/dotfiles/.config/nvim/lazy-lock.json "$HOME/.config/nvim/lazy-lock.json"
    '';

  };

}
