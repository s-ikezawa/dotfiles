vim.pack.add({
  "https://github.com/sindrets/diffview.nvim",
})

require("diffview").setup({
  use_icons = true,
  view = {
    default = { winbar_info = true },
  },
  file_panel = {
    win_config = {
      height = 20,
    },
  },
})

vim.keymap.set("n", "<leader>Do", function()
  vim.ui.input({ prompt = "Diff refs (ex. main..feature): " }, function(refs)
    if refs and refs:match("%S") then
      local safe = vim.fn.shellescape(refs, true)
      vim.cmd(("DiffviewOpen %s"):format(safe))
    else
      vim.cmd("DiffviewOpen")
    end
  end)
end, { desc = "Diffview: open(prompt for refs or default)" })

vim.keymap.set("n", "<leader>Dc", "<cmd>DiffviewClose<cr>", { desc = "Diffview: Close" })
vim.keymap.set("n", "<leader>Dt", "<cmd>DiffviewToggleFiles<cr>", { desc = "Diffview: Toggle file line" })
vim.keymap.set("n", "<leader>Dh", "<cmd>DiffviewFileHistory %<cr>", { desc = "Diffview: File history" })
vim.keymap.set("n", "<leader>DH", "<cmd>DiffviewFileHistory<cr>", { desc = "Diffview: Repo history" })
