{ pkgs, username, config, ... }: {
  home.stateVersion = "24.05";
  home.username = username;
  home.homeDirectory = "/Users/${username}";

  home.packages = with pkgs; [
    ghostty-bin
    plemoljp-nf
    zsh-completions
    eza
    zoxide
    fzf
    ripgrep
    bat
    ghq
    mise
  ];

  xdg.configFile = {
    "ghostty" = {
      source = ./config/ghostty;
      recursive = true;
    };
    "claude" = {
      source = ./config/claude;
      recursive = true;
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    dotDir = "${config.xdg.configHome}/zsh";

    autosuggestion = {
      enable = true;
      strategy = [ "history" "completion" ];
    };

    syntaxHighlighting.enable = true;

    completionInit = ''
      autoload -Uz compinit
      compinit -u -d "${config.xdg.cacheHome}/zsh/zcompdumpp-$ZSH_VERSION"
    '';

    history = {
      size = 100000;
      save = 1000000;
      path = "${config.xdg.stateHome}/zsh/history";
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
      extended = true;
      share = true;
    };

    shellAliases = {
      ls = "eza -a --icons";
      ll = "eza -al --icons";
      tree = "eza -T -L 3";
      nixrebuild = "sudo darwin-rebuild switch --flake ~/Projects/github.com/s-ikezawa/dotfiles";
    };

    # .zshenvに出力
    envExtra = ''
      # XDG Base Directory
      export XDG_CONFIG_HOME="$HOME/.config"
      export XDG_CACHE_HOME="$HOME/.cache"
      export XDG_DATA_HOME="$HOME/.local/share"
      export XDG_STATE_HOME="$HOME/.local/state"

      # Claude Code
      export CLAUDE_CONFIG_DIR="$XDG_CONFIG_HOME/claude"
      export CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1
    '';

    # .zprofileに出力
    profileExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
      eval "$(mise activate zsh --shims)"
    '';

    # .zshrcに出力
    initContent = ''
      bindkey -e
      
      export FZF_DEFAULT_OPTS="
        --height 50%
        --layout=reverse
        --border
        --preview-window=right:60%:wrap
        --preview 'bat --color=always --style=header,grid --line-range :100 {}'
      "
      export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

      eval "$(zoxide init zsh --cmd cd)"
      eval "$(mise activate zsh)"
    '';
  };
}
