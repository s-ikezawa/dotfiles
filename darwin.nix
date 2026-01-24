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

    NSGlobalDomain = {
      KeyRepeat = 1; # リピート速度(min: 1)
      InitialKeyRepeat = 11; # リピート開始までの時間(min: 10)
    };

    WindowManager = {
      EnableStandardClickToShowDesktop = false; # 壁紙をクリックしてデスクトップを表示するを無効化
      EnableTilingByEdgeDrag = false;           # 端へのドラッグでタイル化
      EnableTilingOptionAccelerator = false;    # Optionキーでのタイル化
      EnableTopTilingByEdgeDrag = false;        # 上端へのドラッグでタイル化
      EnableTiledWindowMargins = false;         # タイル表示されたウインドウを隙間を入れて配置
      GloballyEnabled = false;                  # ステージマネージャーを無効化
      StandardHideWidgets = true;               # ウィジェットを非表示にする
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
