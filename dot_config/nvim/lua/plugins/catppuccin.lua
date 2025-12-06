vim.pack.add({
  {
    src = "https://github.com/catppuccin/nvim",
    name = "catppuccin"
  }
})

require('catppuccin').setup({
  flavour = 'mocha', -- latte, frappe, macchiato, mocha
  custom_highlights = function(colors)
    return {
      Whitespace = { fg = '#4b4b4b' }, -- space, tab, trail, nbsp など
      NonText = { fg = '#4b4b4b' }, -- eol, extends, precedes など
    }
  end
})

vim.cmd[[colorscheme catppuccin]]
