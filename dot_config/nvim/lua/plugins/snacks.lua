-- =============================================================================
-- folke/snacks.nvim
-- =============================================================================
-- folke 氏 (LazyVim 作者) によるオールインワンユーティリティ集。
-- 必要なモジュールだけ enabled=true にして使う。
--
-- 有効化中のモジュール:
--   - bigfile   : 大きなファイルを開いた時の自動最適化 (treesitter/syntax 無効化等)
--   - quickfile : Neovim 起動を高速化 (重いプラグインを VeryLazy にする)
--   - picker    : Telescope 代替のファジーピッカー (files/grep/lsp/buffers ...)
--   - image     : Markdown / Norg 等の画像 / Mermaid / LaTeX をバッファ内に
--                 Kitty graphics protocol で表示 (Ghostty/Kitty/WezTerm が必要)
--
-- 他のモジュール (必要になったら enabled=true にする):
--   - notifier  : vim.notify をリッチな UI に置き換え
--   - dashboard : 起動時のダッシュボード画面
--   - indent    : インデントガイド
--   - lazygit   : :lua Snacks.lazygit() でターミナル lazygit を起動
--   - scratch   : 一時バッファ
--   - terminal  : 浮動ターミナル
--   - statuscolumn : 折りたたみ/サインの統合カラム
--
-- 詳細: :help snacks / https://github.com/folke/snacks.nvim
-- =============================================================================

require("snacks").setup({
  -- 大きなファイルを開いた時に重い機能を自動で無効化する
  -- (デフォルト 1.5MB 超で発火。treesitter, syntax, foldmethod=manual などに切替)
  bigfile = { enabled = true },

  -- Neovim 起動を高速化する。argv で渡されたファイルを描画してから
  -- プラグインを遅延ロードする仕組み
  quickfile = { enabled = true },

  -- ファジーピッカー (Telescope 相当)
  -- Snacks.picker.files() / grep() / buffers() / lsp_*() などで呼び出す
  picker = { enabled = true },

  -- バッファ内画像レンダリング
  -- 外部依存: ImageMagick (`magick`) と mermaid-cli (`mmdc`)
  -- ターミナル要件: Kitty graphics protocol 対応 (Ghostty/Kitty/WezTerm)
  -- デフォルトで markdown 等のドキュメント内の画像 / mermaid / latex を
  -- インライン表示してくれる (doc.enabled / doc.inline は true がデフォルト)
  image = { enabled = true },
})
