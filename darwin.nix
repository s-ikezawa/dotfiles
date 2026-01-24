{ pkgs, username, ... }: {
  system.stateVersion = 5;
  system.primaryUser = username;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  system.defaults = {
    dock = {
      autohide = true;      # 自動的に隠す
      show-recents = false; # 最近使ったアプリは非表示
      tilesize = 16;        # アイコンサイズ
      magnification = true; # 拡大を有効化
      largesize = 128;      # 拡大時のサイズ(max:128)
      orientation = "left"; # 表示位置(bottom, left, right)
    };
  };

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
    };
    casks = [
      "1password"
      "1password-cli"
    ];
  };
}
