-- ~/.config/nvim/lua/plugins.lua
-- プラグイン管理 (vim.pack)

-- ============================================================
-- プラグインの追加 (Install)
-- ============================================================
vim.pack.add({
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },                  -- カラースキーム
  { src = "https://github.com/romus204/tree-sitter-manager.nvim", name = "tree-sitter-manager" }, -- Tree-sitter パーサー管理
  { src = "https://github.com/folke/snacks.nvim", name = "snacks" },                    -- Picker / Explorer 等の便利機能集
  { src = "https://github.com/echasnovski/mini.icons", name = "mini.icons" },           -- アイコン表示 (snacks 等で使用)
  { src = "https://github.com/folke/sidekick.nvim", name = "sidekick" },                 -- AI CLI 連携 (Claude Code)
  { src = "https://github.com/christoomey/vim-tmux-navigator", name = "vim-tmux-navigator" }, -- Neovim split と tmux pane をシームレスに移動
  { src = "https://github.com/rachartier/tiny-cmdline.nvim", name = "tiny-cmdline" },     -- コマンドラインを中央フローティング表示 (0.12 ui2)
  { src = "https://github.com/rcarriga/nvim-notify", name = "nvim-notify" },             -- vim.notify をリッチな通知UIに置き換え
  { src = "https://github.com/lewis6991/gitsigns.nvim", name = "gitsigns" },             -- git の差分を sign 表示 (incline の git diff にも使用)
  { src = "https://github.com/b0o/incline.nvim", name = "incline" },                     -- ウィンドウごとのフローティングファイル名表示
  { src = "https://github.com/WilliamHsieh/overlook.nvim", name = "overlook" },          -- 定義等をポップアップでプレビュー (peek)
  { src = "https://github.com/dlyongemallo/diffview-plus.nvim", name = "diffview" },      -- diff レビュー特化 (sindrets/diffview.nvim の維持fork)
  { src = "https://github.com/nvim-lua/plenary.nvim", name = "plenary" },                 -- Lua ユーティリティ (octo の依存)
  { src = "https://github.com/pwntester/octo.nvim", name = "octo" },                      -- GitHub PR / Issue レビュー (gh CLI 連携)
})

-- ============================================================
-- 各プラグインの設定 (lua/plugins/*.lua)
-- ============================================================
require("plugins.catppuccin")  -- カラースキーム
require("plugins.treesitter")  -- Tree-sitter (Parser / Highlight)
require("plugins.icons")       -- Icons (mini.icons)
require("plugins.snacks")      -- Picker / Explorer
require("plugins.sidekick")    -- AI CLI: Claude Code
require("plugins.cmdline")     -- コマンドライン (tiny-cmdline) + 通知 (nvim-notify)
require("plugins.gitsigns")    -- git 差分の sign 表示
require("plugins.incline")     -- フローティングファイル名 (右下)
require("plugins.overlook")    -- 定義プレビュー (peek popup)
require("plugins.diffview")    -- diff レビュー (diffview-plus)
require("plugins.octo")        -- GitHub PR / Issue レビュー (octo)
