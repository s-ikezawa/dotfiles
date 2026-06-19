-- ============================================================================
-- gitsigns.nvim - 行単位の変更サイン / hunk 取捨選択
-- https://github.com/lewis6991/gitsigns.nvim
-- ============================================================================
-- 編集中バッファの変更箇所を gutter に表示し、hunk 単位で
-- プレビュー / 採用(stage) / 破棄(reset) する。diffview の補完役で、
-- 「見る → 差分 → 取捨選択」ループの取捨選択を担う。

require("gitsigns").setup({
  on_attach = function(bufnr)
    local gs = require("gitsigns")
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    -- hunk 間移動（diff モード中は標準の ]c/[c にフォールバック）
    map("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gs.nav_hunk("next")
      end
    end, "Gitsigns: 次の変更")
    map("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gs.nav_hunk("prev")
      end
    end, "Gitsigns: 前の変更")

    -- hunk 操作（,h プレフィックス）
    map("n", "<leader>hp", gs.preview_hunk, "Gitsigns: hunk をプレビュー")
    map("n", "<leader>hs", gs.stage_hunk, "Gitsigns: hunk を採用(stage)")
    map("n", "<leader>hr", gs.reset_hunk, "Gitsigns: hunk を破棄(reset)")
    map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Gitsigns: 選択範囲を採用")
    map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Gitsigns: 選択範囲を破棄")
    map("n", "<leader>hS", gs.stage_buffer, "Gitsigns: バッファ全体を採用")
    map("n", "<leader>hR", gs.reset_buffer, "Gitsigns: バッファ全体を破棄")
    map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Gitsigns: 行の blame")
    map("n", "<leader>hd", gs.diffthis, "Gitsigns: index との差分")
  end,
})
