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

  programs.tmux = {
    enable = true;

    prefix = "C-a";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 100000;
    mouse = false;
    terminal = "tmux-256color";
    keyMode = "vi";

    extraConfig = ''
      # インデックス
      set -g pane-base-index 1
      set -g renumber-windows on

      # True Colors
      set -sg terminal-overrides ",xterm-256color:Tc"

      # Paneの境界線
      set -g pane-border-lines simple

      #QoL
      set -g repeat-time 1000
      set -g display-time 4000
      set -g focus-events on
      set -g assume-paste-time 0

      # StatusLine
      set -g status-position top
      set -g status-interval 60
      set -g status-style "fg=default,bg=default"
      set -g message-style "fg=default,bg=default"
      set -g status-left-length 100
      set -g status-left "#[bold]  #h   #S #[nobold]| "
      set -g status-right ""
      set -g window-status-current-format "#[bold]● #[underscore]#I:#W"
      set -g window-status-format "  #I:#W"

      # Key Bindings
      bind C-a send-prefix # <C-a>2回でプログラムに<C-a>を送る
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"
      bind v split-window -h -c "#{pane_current_path}"
      bind s split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"
      bind -r h select-pane -L
      bind -r j select-pane -D
      bind -r k select-pane -U
      bind -r l select-pane -R
      bind -r H resize-pane -L 1
      bind -r J resize-pane -D 1
      bind -r K resize-pane -U 1
      bind -r L resize-pane -R 1

      # Copy Mode
      set -s set-clipboard on
      bind -T copy-mode-vi v { send-keys -X begin-selection }
      bind -T copy-mode-vi C-v { send-keys -X rectangle-toggle }
      bind -T copy-mode-vi V { send-keys -X select-line }
      bind -T copy-mode-vi y { send-keys -X copy-pipe }

      # インクリメンタル検索
      bind -T copy-mode-vi / command-prompt -i -p "search down" "send -X search-forward-incremental \"%%%\""
      bind -T copy-mode-vi ? command-prompt -i -p "search up" "send -X search-backward-incremental \"%%%\""
    '';
  };
}
