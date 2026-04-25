-- =============================================================================
-- folke/lazydev.nvim
-- =============================================================================
-- Neovim 設定ファイルを編集中、lua_ls の workspace.library を必要なときだけ
-- 動的に拡張する (neodev.nvim の後継)。
--
-- 動作:
--   - 編集中の lua バッファに `require("X")` があれば X のソースパスを追加
--   - library の `words` パターンが現れたバッファでも対応するパスを追加
--   - LspAttach 時に上書きするので、setup は vim.lsp.enable('lua_ls') より前
--
-- パスの書式:
--   - `${3rd}/luv/library` のような lua_ls の組み込みプレースホルダ
--   - "プラグイン名" (vim.pack 配下や runtimepath 上から自動解決される)
-- =============================================================================

require("lazydev").setup({
  library = {
    -- vim.uv (libuv) の型情報。`vim.uv` を参照しているバッファでのみ追加
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    -- mini.icons の MiniIcons グローバル (icons.lua で利用)
    { path = "mini.icons", words = { "MiniIcons" } },
    -- snacks.nvim の Snacks グローバル
    { path = "snacks.nvim", words = { "Snacks" } },
  },
})
