return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function()
    local wk = require("which-key")
    
    wk.setup({})
    
    wk.add({
      { "<leader>t", group = "タブ" },
      { "<leader>s", group = "分割" },
      { "<leader>n", group = "無効化" },
      { "<leader>e", group = "エクスプローラー" },
    })
  end,
}