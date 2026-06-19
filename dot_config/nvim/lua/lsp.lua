-- ============================================================================
-- LSP 設定（Neovim 標準の vim.lsp、ネイティブ構成）
-- ============================================================================
-- nvim-lspconfig は使わない。各サーバの設定は runtimepath 上の lsp/<name>.lua
-- に置き（Neovim 0.11+ が自動で vim.lsp.config として読み込む）、ここでは
-- vim.lsp.enable で有効化するだけにする。
--   サーバ定義: lsp/kotlin_lsp.lua
--
-- キーマップは 0.11+ 組み込みの既定をそのまま使うため、ここでは定義しない:
--   K=hover, grn=rename, gra=code action, grr=references, gri=implementation,
--   gO=document symbol, [d/]d=診断移動, CTRL-S(挿入)=signature help

-- kotlin-lsp（設定は lsp/kotlin_lsp.lua）。未導入環境では有効化しない
-- （kotlin ファイルを開いた際の起動エラーを避ける）。
if vim.fn.executable("kotlin-lsp") == 1 then
  vim.lsp.enable("kotlin_lsp")
end
