vim.pack.add({
  "https://github.com/sindrets/diffview.nvim",
})

require("diffview").setup()

vim.keymap.set("n", "<Leader>gd", "<Cmd>DiffviewOpen<CR>", { desc = "Diffview: Open" })
vim.keymap.set("n", "<Leader>gD", "<Cmd>DiffviewFileHistory %<CR>", { desc = "Diffview: File history" })
vim.keymap.set("n", "<Leader>gq", "<Cmd>DiffviewClose<CR>", { desc = "Diffview: Close" })
