-- ============================================================================
-- プラグイン管理（vim.pack - Neovim 標準のビルトインパッケージマネージャー）
-- ============================================================================

-- ----------------------------------------------------------------------------
-- ビルドフック（インストール/更新時にネイティブバイナリを用意する）
-- PackChanged は vim.pack.add のインストール時に発火するため、
-- 取りこぼさないよう add より前に登録しておく
-- ----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    -- fff.nvim: Rust 製バイナリをダウンロード or ビルド（設定は plugins/fff.lua）
    if name == "fff.nvim" and (kind == "install" or kind == "update") then
      if not ev.data.active then vim.cmd.packadd("fff.nvim") end
      require("fff.download").download_or_build_binary()
    end
  end,
})

-- ----------------------------------------------------------------------------
-- プラグイン宣言
-- 未導入のものは vim.pack.add 実行時に自動でクローン・読み込みされる
-- ----------------------------------------------------------------------------
vim.pack.add({
  { src = "https://github.com/nvim-mini/mini.icons" },                         -- アイコン（nvim-web-devicons 互換シム付き）
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },         -- カラーテーマ Catppuccin
  { src = "https://github.com/romus204/tree-sitter-manager.nvim" },            -- Tree-sitter パーサー管理
  { src = "https://github.com/dmtrKovalenko/fff.nvim" },                       -- 高速ファイルピッカー（要 Rust ビルド）
  { src = "https://github.com/sindrets/diffview.nvim" },                       -- 変更ファイル一覧 + 差分レビュー
  { src = "https://github.com/lewis6991/gitsigns.nvim" },                      -- 行単位の変更サイン / hunk 取捨選択
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },    -- Markdown のバッファ内インラインレンダリング
  { src = "https://github.com/folke/snacks.nvim" },                            -- image モジュールで mermaid/画像を実描画
  { src = "https://github.com/b0o/incline.nvim" },                             -- 各ウィンドウ右上にファイル名をフロート表示（ステータスライン代替）
  { src = "https://github.com/mvllow/modes.nvim" },                            -- モード（挿入/ビジュアル等）に応じて cursorline/行番号を色付け
  { src = "https://github.com/MunifTanjim/nui.nvim" },                         -- noice.nvim 依存の UI コンポーネント
  { src = "https://github.com/rcarriga/nvim-notify" },                         -- noice.nvim の通知(notify)ビュー用バックエンド
  { src = "https://github.com/folke/noice.nvim" },                            -- cmdline/メッセージ/通知を置き換える UI（cmdheight=0 用）
  { src = "https://github.com/WilliamHsieh/overlook.nvim" },                   -- 定義等をスタック可能なフロートでその場プレビュー（コードジャンプ補助）
  { src = "https://github.com/folke/which-key.nvim" },                         -- キーバインドの discoverability（プレフィックス押下で候補をポップアップ）
})

-- ----------------------------------------------------------------------------
-- 各プラグインの設定を読み込む（lua/plugins/ 配下を 1 ファイルずつ）
-- アイコン(mini.icons)は他プラグインの描画より先に mock を立てるため最初に読む
-- ----------------------------------------------------------------------------
require("plugins.mini-icons")
require("plugins.catppuccin")
require("plugins.tree-sitter-manager")
require("plugins.fff")
require("plugins.diffview")
require("plugins.gitsigns")
require("plugins.render-markdown")
require("plugins.snacks")
require("plugins.incline")
require("plugins.modes")
require("plugins.noice")
require("plugins.overlook")
require("plugins.which-key")
