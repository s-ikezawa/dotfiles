return {
  'saghen/blink.cmp',
  dependencies = {
    { 'nvim-mini/mini.icons' }
  },
  version = '1.*',
  event = { 'InsertEnter' },
  opts = {
    keymap = { preset = 'super-tab' }, -- default, super-tab, enter, none
    appearance = {
      nerd_font_variant = 'mono',
    },
    completion = {
      documentation = { auto_show = false },
      menu = {
        draw = {
          columns = {
            { 'label', 'label_description', gap = 1 },
            { 'kind_icon', 'kind', gap = 1 }
          },
          components = {
            kind_icon = {
              text = function(ctx)
                local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                return kind_icon
              end,
              highlight = function(ctx)
                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                return hl
              end,
            },
            kind = {
              highlight = function(ctx)
                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                return hl
              end
            },
          },
        },
      },
    },
    sources = {
      default = { 'lsp', 'path', 'buffer'}
    },
    -- fuzzy = { implementation = 'prefer_fust_with_warning' }
  },
  opts_extend = { 'sources.default' }
}
