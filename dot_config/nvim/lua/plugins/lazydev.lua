return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      -- lazy.nvimのパスをライブラリに追加することでLazyPlugin型を認識させる
      "lazy.nvim",
      -- 推奨されるlibvu(vim.uv)の型定義もいれる
      { path = "${3rd}/luv/library", words = { "vim%.uv", "vim%.loop" } },
    },
  },
}
