-- ~/.config/nvim/lua/keymaps.lua
-- キーマッピング設定

local keymap = vim.keymap.set

-- ============================================================
-- ウィンドウ移動 (Window navigation)
-- ============================================================
-- <C-h/j/k/l> による移動は vim-tmux-navigator が自動設定する。
-- (plugins.lua 参照。Neovim split の端では tmux pane へシームレスに移動する)
