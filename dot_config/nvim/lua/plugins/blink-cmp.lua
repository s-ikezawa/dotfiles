vim.pack.add({
  {
    src = 'https://github.com/saghen/blink.cmp',
    version = 'v1.8.0'
  },
  {
    src = 'https://github.com/rafamadriz/friendly-snippets',
    version = 'main',
  },
})

require('blink.cmp').setup({
  appearance = {
    nerd_font_variant = 'mono',
  },
  completion = {
    documentation = {
      auto_show = true,
    },
    menu = {
      border = "rounded",
      draw = {
        columns = {
          { 'label', 'label_description' },
          { 'kind_icon', 'kind', gap = 1 },
        },
        components = {
          kind_icon = {
            text = function(ctx)
              local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
              return kind_icon
            end,
            -- (optional) use highlights from mini.icons
            highlight = function(ctx)
              local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
              return hl
            end
          },
          kind = {
            -- (optional) use highlights from mini.icons
            highlight = function(ctx)
              local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
              return hl
            end
          },
        },
        treesitter = { 'lsp' },
      },
    },
  },
  keymap = {
    preset = 'enter', -- default or super-tab or enter or none
  },
  signature = {
    enabled = true,
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
})
