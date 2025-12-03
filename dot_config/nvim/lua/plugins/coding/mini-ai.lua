return {
  'nvim-mini/mini.ai',
  version = '*',
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter', branch = 'main' },
    { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
  },
  config = function()
    require('mini.ai').setup({
      custom_textobjects = {
        o = require('mini.ai').gen_spec.treesitter({ -- code block
          a = { '@block.outer', '@conditional.outer', '@loop.outer' },
          i = { '@block.inner', '@conditional.inner', '@loop.inner' },
        }),
        f = require('mini.ai').gen_spec.treesitter({ -- function
          a = { '@function.outer' },
          i = { '@function.inner' },
        }),
        c = require('mini.ai').gen_spec.treesitter({ -- class
          a = { '@class.outer' },
          i = { '@class.inner' },
        }),
        t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
        d = { '%f[%d]%d+' }, -- digits
        e = { -- Word with case
          { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
          "^().*()$",
        }
      },
    })
  end,
}
