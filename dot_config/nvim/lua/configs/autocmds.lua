-- 自動コマンド。
--
-- グループにまとめて clear = true で作る。設定を読み直しても二重に登録されない。

local group = vim.api.nvim_create_augroup("configs.autocmds", { clear = true })

-- ヤンクした範囲を一瞬光らせる。yap や y3j のように選択を伴わない操作で、
-- どこまで取れたかを確かめるため。
vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  desc = "ヤンクした範囲をハイライトする",
  callback = function()
    vim.hl.on_yank()
  end,
})
