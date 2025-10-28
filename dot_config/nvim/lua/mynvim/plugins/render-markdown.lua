return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-mini/mini.icons",
  },
  ft = { "markdown" },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    -- カーソル行のみレンダリングしない。カーソル行以外はレンダリングする
    render_modes = true,
    completions = {
      lsp = { enabled = true }
    },
    code = {
      border = "thick",
    },
    html = {
      comment = {
        conceal = false,
      }
    }
  },
}
