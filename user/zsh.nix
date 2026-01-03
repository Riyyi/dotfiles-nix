{ config, lib, dot, ... }:

let
  switch-nixos = "sudo nixos-rebuild switch --sudo --flake /etc/nixos#$HOST";
  update-nixos = "sudo nix flake update --flake /etc/nixos && switch";
  clean-nixos = "sudo nix-env --delete-generations +5 --profile /nix/var/nix/profiles/system && nix-collect-garbage && nix-store --optimise && sudo nixos-rebuild boot";

  switch-darwin = "sudo darwin-rebuild switch --flake ~/Code/nix/dotfiles-nix#$HOST";
  update-darwin = "sudo nix flake update --flake ~/Code/nix/dotfiles-nix && switch";
  clean-darwin = "sudo nix-env --delete-generations +5 --profile /nix/var/nix/profiles/system && sudo nix-collect-garbage && sudo nix-store --optimise --ignore-failures && switch";
in
{

  options.zsh = {
    enable = lib.mkEnableOption "zsh";
  };

  config = lib.mkIf config.zsh.enable {

    programs.zsh = {
      dotDir = "${config.xdg.configHome}/zsh";

      enable = true;
      enableCompletion = true;
      syntaxHighlighting = {
        enable = true;
        highlighters = [
          "main"
          "brackets"
        ];
        styles = {
          path = "fg=12,underline";
        };
      };

      defaultKeymap = "viins";
      completionInit = "autoload -Uz promptinit colors vcs_info compinit";

      initContent = ''
# Disable Ctrl+S and Ctrl+Q
stty -ixon

# Use hard tabs
stty tab0

# Set tab width
tabs -4

## ZSH

# Prompt
promptinit
colors
setopt INTERACTIVE_COMMENTS
setopt PROMPT_SUBST

__precmd() {
	vcs_info

	print -Pn "\e]0;%n@%m %~\a"
}
precmd_functions+=(__precmd)

# ZSH parameters
USR_HOST="%F{cyan}%n%f@%F{cyan}%m%f"
DIRECTORY="%F{green}%~%f"
ARROW="%(?..%F{red})➤%f"
PROMPT='╭─''${USR_HOST} ''${DIRECTORY} ''${vcs_info_msg_0_}
╰─''${ARROW} '
RPROMPT='%t'
TIMEFMT=$"\nreal\t%*Es\nuser\t%*Us\nsys\t%*Ss"

# Git
zstyle ":vcs_info:*" enable git
zstyle ":vcs_info:*" check-for-changes true
zstyle ":vcs_info:*" stagedstr "%F{green}A%f"
zstyle ":vcs_info:*" unstagedstr "%F{red}M%f"
zstyle ":vcs_info:*" formats "%F{cyan}(%F{red}%b%F{cyan})%f %c%u"

# Autocompletion
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"
zstyle ":completion::complete:*" use-cache 1
zstyle ":completion::complete:*" cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
zstyle ":completion:*:options" auto-description "%d"
zstyle ":completion:*:default" list-colors ""
zstyle ":completion:*:default" list-prompt ""
zstyle ":completion:*" matcher-list "m:{a-zA-Z}={A-Za-z}" "r:|[._-]=* r:|=*" "l:|=* r:|=*"
zstyle ":completion:*" menu select

zstyle ":completion:*" group-name ""
zstyle ":completion:*" list-dirs-first true
zstyle ":completion:*" verbose yes
zstyle ":completion:*:default" list-prompt "%S%M matches%s"
zstyle ":completion:*:matches" group "yes"
zstyle ":completion:*:options" description "yes"

# Completion formatting
zstyle ":completion:*" format " %F{yellow}-- %d --%f"
zstyle ":completion:*:corrections" format " %F{green}-- %d (errors: %e) --%f"
zstyle ":completion:*:descriptions" format " %F{yellow}-- %d --%f"
zstyle ":completion:*:messages" format " %F{purple} -- %d --%f"
zstyle ":completion:*:warnings" format " %F{red}-- no matches found --%f"

# Bind keys, find them with $ cat -v or <C-v>
bindkey "\eOc" forward-word                               # ctrl-right
bindkey "\e[1;5C" forward-word                            # ctrl-right
bindkey "\eOd" backward-word                              # ctrl-left
bindkey "\e[1;5D" backward-word                           # ctrl-left
bindkey "\e[3~" delete-char                               # del
bindkey "\e[7~" beginning-of-line                         # home
bindkey "\e[H" beginning-of-line                          # home
bindkey "\eOH" beginning-of-line                          # home
bindkey "\e[8~" end-of-line                               # end
bindkey "\e[F" end-of-line                                # end
bindkey "\eOF" end-of-line                                # end
bindkey "\e[A" history-substring-search-up                # up
bindkey "\eOA" history-substring-search-up                # up
bindkey "\e[B" history-substring-search-down              # down
bindkey "\eOB" history-substring-search-down              # down
bindkey "\e[Z" reverse-menu-complete                      # shift-tab
bindkey "\eh" kill-whole-line                             # meta-h
bindkey "\ej" history-substring-search-down               # meta-j
bindkey "\ek" history-substring-search-up                 # meta-k
bindkey "\el" accept-line                                 # meta-l
bindkey "^R" history-incremental-pattern-search-backward  # ctrl-r

# History
HISTORY_SUBSTRING_SEARCH_PREFIXED=1

# HACK: Prevent blinking cursor in Ghostty
# https://github.com/ghostty-org/ghostty/discussions/2812#discussioncomment-12419014
function __set_beam_cursor { echo -ne '\e[6 q' }
function __set_block_cursor { echo -ne '\e[2 q' }
function zle-keymap-select {
  case $KEYMAP in
    vicmd) __set_block_cursor;;
    viins|main) __set_beam_cursor;;
  esac
}
zle -N zle-keymap-select
precmd_functions+=(__set_beam_cursor)

[ -f "$ZDOTDIR/.zshrc-extended" ] && source "$ZDOTDIR/.zshrc-extended"
      '';

      history = {
        size = 10000;
        path = "${config.xdg.cacheHome}/zsh/zsh_history";
        extended = true;
        ignoreDups = true;
        ignoreAllDups = true;
        ignoreSpace = true;
        share = false;
      };

      historySubstringSearch = {
        enable = true;
        #searchUpKey = [ "\\e[A" "\\eOA" "\\ek" ];
        #searchDownKey = [ "\\e[B" "\\eOB" "\\ej" ];
      };

      shellAliases = {
        # General
        ".." = "cd ..";
        "..." = "cd ../..";
        "..2" = "cd ../..";
        "..3" = "cd ../../..";
        "..4" = "cd ../../../..";
        cp = "cp -i";
        df = "df -h";
        diff = "diff --color";
        du = "du -h";
        e = "aliases emacs";
        emacs = "aliases emacs";
        fuck = "sudo $(fc -ln -1)";
        grep = "grep --color=always";
        ip = "ip --color";
        ipb = "ip --color --brief a";
        la = "ls -lAGh --color --group-directories-first --hyperlink";
        less = "less -x 4";
        ls = "ls --color --group-directories-first --hyperlink";
        mkdir = "mkdir -pv";
        mv = "mv -i";
        pkill = "pkill -9";
        q = "exit";
        rm = "rm -i";
        se = "sudoedit";
        semacs = "sudoedit";
        ss = "sudo systemctl";
        v = "vim --servername VIM";
        vim = "vim --servername VIM";

        # Git
        g = "git";
        ga = "git add";
        gap = "git add -p";
        gb = "git branch";
        gc = "git commit";
        gch = "git checkout";
        gd = "git diff";
        gdc = "git diff --cached";
        gds = "git diff --staged";
        gf = "git fetch";
        gl = "git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%ai%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d    %C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all";
        gle = "git log --graph --stat --format=format:'%C(bold blue)commit %H%C(reset)%C(bold yellow)%d %C(reset)%nAuthor: %C(dim white)%an <%ae>%C(reset)%nDate:   %C(bold cyan)%ai%C(reset) %C(bold green)(%ar)%C(reset)%n%n%w(64,4,4)%B'";
        gm = "git merge";
        gp = "git pull";
        gps = "git push || git push origin $(git branch --show-current)";
        gpsa = "git remote | xargs -I remotes git push remotes $(git branch --show-current)";
        gpsaf = "git remote | xargs -I remotes git push --force remotes $(git branch --show-current)";
        gr = "git reset";
        gs = "git status";
        gsh = "git show --format=format:'%C(bold blue)commit %H%C(reset) %C(bold yellow)%d %C(reset)%nAuthor: %C(dim white)%an <%ae>%C(reset)%nDate:   %C(bold cyan)%ai%C(reset) %C(bold green)(%ar)%C(reset)%n%n%w(64,4,4)%B'";
        gt = "git ls-tree -r --name-only $(git branch --show-current) .";

        # NixOS
        list = "nixos-rebuild list-generations";
        switch = if dot.system != "x86_64-darwin" && dot.system != "aarch64-darwin" then switch-nixos else switch-darwin;
        update = if dot.system != "x86_64-darwin" && dot.system != "aarch64-darwin" then update-nixos else update-darwin;
        clean = if dot.system != "x86_64-darwin" && dot.system != "aarch64-darwin" then clean-nixos else clean-darwin;

        # Applications
        mpv = "nohup mpv --idle --force-window >/dev/null 2>&1 &";
        neofetch = "fastfetch -c neofetch";
      };

      profileExtra = "export GHOSTTY_SHELL_INTEGRATION_NO_CURSOR=1";

    };

    home.sessionPath = [
      "$HOME/.local/bin"
    ];

  };

}
