local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ============================================================================
-- 外部変更の自動検知 (Claude Code などの外部ツールによる編集を反映)
-- ============================================================================

augroup("auto_reload", { clear = true })

-- Neovim にフォーカスが戻った時、またはバッファに入った時にファイル変更をチェック
autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  group = "auto_reload",
  command = "checktime",
  desc = "外部でファイルが変更された場合に自動で再読み込み",
})
