-- ~/.config/nvim/lua/icons.lua
-- アイコン定義の共通モジュール
-- =============================================================================
-- 診断 / git などのグリフ(アイコン文字)を一箇所に集約する。
-- 各所 (lua/lsp.lua の診断 sign、lua/plugins/incline.lua の表示など) は
-- require("icons") して参照し、定義の二重管理・ズレを防ぐ。
-- グリフは末尾に半角スペースを含む (signcolumn の2セル幅 / 表示の余白用)。
--
-- ファイルタイプアイコンは mini.icons に一本化しているため、ここには含めない
-- (require("mini.icons").get("file", name) で取得)。
-- see: https://www.nerdfonts.com/cheat-sheet
-- =============================================================================

local M = {}

-- 診断 (severity 名は vim.diagnostic.severity と対応; 大文字キー)
M.diagnostics = {
  ERROR = " ", -- nf-oct-x_circle
  WARN  = " ", -- nf-oct-alert
  INFO  = " ", -- nf-oct-info
  HINT  = " ", -- nf-oct-light_bulb
}

-- git 差分 (gitsigns_status_dict のキー added/changed/removed に対応)
M.git = {
  added   = " ", -- nf-oct-added
  changed = " ", -- nf-oct-modified
  removed = " ", -- nf-oct-removed
}

return M
