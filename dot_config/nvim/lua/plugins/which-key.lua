-- ============================================================================
-- which-key.nvim - キーバインドの discoverability
-- https://github.com/folke/which-key.nvim
-- ============================================================================
-- プレフィックス（リーダー "," など）を押して少し待つと、その先のキーと
-- 説明(desc)がポップアップ表示される。各マップは既に desc 付きで定義済みなので、
-- ここでは setup とプレフィックスのグループ名登録だけ行う（新しいキーは増やさない）。
-- 表示までの待ち時間は options.lua の timeoutlen(300ms)。アイコンは mini.icons 連携。

local wk = require("which-key")

wk.setup({
  preset = "modern", -- ポップアップの見た目（classic / modern / helix から選択）
})

-- プレフィックスにグループ名を付ける（個々のキーの desc は自動で拾われる）
wk.add({
  { "<leader>h", group = "Git hunk (gitsigns)" }, -- ,hp ,hs ,hr ,hS ,hR ,hb ,hd
  { "<leader>f", group = "Find (fff)" },           -- ,ff ,fg
  { "<leader>g", group = "Git" },                  -- ,gf
  { "<leader>n", group = "Noice" },                -- ,nh ,nl ,nd
  { "<leader>p", group = "Overlook (peek)" },      -- ,pd ,pp ,pf ,pu ,pc ,ps ,pv ,pt
  { "<leader>u", group = "Toggle (UI)" },          -- ,uh (inlay hints)
})
