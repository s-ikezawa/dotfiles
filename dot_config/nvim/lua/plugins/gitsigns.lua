-- ~/.config/nvim/lua/plugins/gitsigns.lua
-- lewis6991/gitsigns.nvim
-- =============================================================================
-- git の追加/変更/削除行を signcolumn に表示する。
-- incline の git diff 表示は、gitsigns がバッファ変数に格納する
-- b:gitsigns_status_dict (added/changed/removed の行数) を参照する。
-- =============================================================================

require("gitsigns").setup()
