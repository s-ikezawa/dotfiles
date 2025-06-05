-- 開発支援プラグイン設定
return {
  -- Claude Code統合
  {
    'greggh/claude-code.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('claude-code').setup({
        -- コマンド設定
        command = "claude",
        -- コマンドのバリエーション
        command_variants = {
          -- 会話管理
          continue = "--continue", -- 最新の会話を再開
          resume = "--resume",     -- インタラクティブな会話選択画面を表示

          -- 出力オプション
          verbose = "--verbose",   -- ターン毎の詳細出力による詳細ログを有効化
        },
        -- ターミナルの表示位置設定
        window = {
          split_ratio = 0.3, -- ターミナルウィンドウの画面占有率（水平分割では高さ、垂直分割では幅）
          position = "rightbelow vsplit", -- ウィンドウの位置: "botright", "topleft", "vertical", "rightbelow vsplit"など
          enter_insert = true, -- Claude Code開始時にインサートモードに入るかどうか
          hide_numbers = true, -- ターミナルウィンドウで行番号を非表示
          hide_signcolumn = true, -- ターミナルウィンドウでサインカラムを非表示
        },
        -- ファイル更新設定
        refresh = {
          enable = true,           -- ファイル変更検出を有効化
          updatetime = 100,        -- Claude Code有効時のupdatetime（ミリ秒）
          timer_interval = 1000,   -- ファイル変更チェック間隔（ミリ秒）
          show_notifications = true, -- ファイルリロード時の通知表示
        },
        -- Gitプロジェクト設定
        git = {
          use_git_root = true,     -- Claude Code開始時にCWDをgitルートに設定（gitプロジェクト内の場合）
        },
        -- キーマップ
        keymaps = {
          toggle = {
            normal = "<C-,>", -- Claude Code切り替えのノーマルモードキーマップ、無効化するにはfalse
            terminal = "<C-,>", -- Claude Code切り替えのターミナルモードキーマップ、無効化するにはfalse
            variants = {
              continue = "<leader>cC", -- continueフラグ付きClaude Codeのノーマルモードキーマップ
              verbose = "<leader>cV", -- verboseフラグ付きClaude Codeのノーマルモードキーマップ
            },
          },
          window_navigation = true, -- ウィンドウナビゲーションキーマップ（<C-h/j/k/l>）を有効化
          scrolling = true, -- ページアップ/ダウンのスクロールキーマップ（<C-f/b>）を有効化
        }
      })
    end,
  },
}