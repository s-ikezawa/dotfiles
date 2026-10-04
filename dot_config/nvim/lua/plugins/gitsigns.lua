-- gitsigns.nvim。Git の変更行をサインカラムに印で出し、バッファごとの差分の数を
-- b:gitsigns_status_dict(added / changed / removed / head)に置く。
-- その数は incline(lua/plugins/incline.lua)がファイル名の横に出すのに使う。
--
-- version は "^2.0"(>=2.0.0 <3.0.0)。v2 系はタグが定期的に打たれている(v2.1.0 は 2026-03)。
-- Neovim 0.11 以上が要る(README の Requirements)。
vim.pack.add({
  {
    src = "https://github.com/lewis6991/gitsigns.nvim",
    version = vim.version.range("^2.0"),
  },
})

require("gitsigns").setup()
