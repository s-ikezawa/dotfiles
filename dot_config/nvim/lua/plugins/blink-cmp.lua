vim.pack.add({
  {
    src = "https://github.com/saghen/blink.cmp",
    version = vim.version.range("^1"),
  },
  {
    src = "https://github.com/rafamadriz/friendly-snippets",
    version = "main",
  },
})

local opts = {
  keymap = {
    preset = "super-tab",
  },
  appearance = {
    nerd_font_variant = "mono",
    use_nvim_as_default = true,
  },
  completion = {
    documentation = { auto_show = true },
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  fuzzy = {
    implementation = "prefer_rust_with_warning",
  },
}

vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  group = vim.api.nvim_create_augroup("BlinkCmpLazyLoad", { clear = true }),
  once = true,
  callback = function()
    require("blink.cmp").setup(opts)
  end,
})
