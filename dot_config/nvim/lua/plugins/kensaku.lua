return {
  "lambdalisue/kensaku.vim",
  dependencies = {
    "vim-denops/denops.vim",
    "lambdalisue/kensaku-search.vim",
  },
  config = function()
    vim.keymap.set("c", "<CR>", "<Plug>(kensaku-search-replace)<CR>", { desc = "Search Japanese alphabetically" })
  end
}
