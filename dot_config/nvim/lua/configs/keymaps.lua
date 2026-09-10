-- キーマップ。
--
-- Neovim には既定のマッピングがある（gc でコメント、grn / gra などの LSP、
-- ]d / [d で診断、]q / [q で quickfix、gO で目次。一覧は :help default-mappings）。
-- それらと重ならないものだけをここに置く。

-- 検索後のハイライトを Esc で消す。:nohlsearch を毎回打たずに済ませるため。
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "検索ハイライトを消す" })
