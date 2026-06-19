-- ============================================================================
-- tree-sitter-manager.nvim - Tree-sitter パーサーの管理
-- https://github.com/romus204/tree-sitter-manager.nvim
-- ============================================================================
-- 注: ensure_installed = "all" は全パーサー(200個超)を並列インストールするため、
--     ファイルディスクリプタ(同時オープンファイル数)の上限が必要。
--     macOS 既定の 256 では EMFILE(too many open files)になるので、
--     ~/.zshrc で `ulimit -n 10240` に引き上げて対応している。

require("tree-sitter-manager").setup({
  ensure_installed = "all", -- 起動時にすべての言語パーサーをインストールする
  auto_install = true,      -- 未対応のファイルタイプを開いた際に自動でパーサーを導入する
  highlight = true,         -- インストール済みパーサーで Tree-sitter ハイライトを有効化する
})
