return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "javascript",
        "typescript",
        "python",
        "go",
        "rust",
        "bash",
        "html",
        "css",
        "json",
        "yaml",
        "toml",
        "markdown",
        "markdown_inline",
        "latex",
        "norg",
        "scss",
        "svelte",
        "tsx",
        "typst",
        "vue",
        "regex"
      },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    })
  end,
}