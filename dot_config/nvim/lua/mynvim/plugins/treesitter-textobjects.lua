return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  dependencies = {
    { "nvim-treesitter/nvim-treesitter" }
  },
  config = function()
    require("nvim-treesitter-textobjects").setup({})
  end
}
