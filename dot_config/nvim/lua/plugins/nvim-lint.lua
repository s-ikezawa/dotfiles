vim.pack.add({
  "https://github.com/mfussenegger/nvim-lint",
})

require("lint").linters_by_ft = {
  go = { "golangcilint" },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  group = vim.api.nvim_create_augroup("user_nvim_lint", { clear = true }),
  callback = function()
    require("lint").try_lint()
  end,
})
