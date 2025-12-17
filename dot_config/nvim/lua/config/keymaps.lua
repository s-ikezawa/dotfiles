if vim.g.vscode then
  local vscode = require('vscode')

  vim.keymap.set('n', 'za',
    function()
      vscode.call('editor.toggleFold')
    end,
    { noremap = true, silent = true }
  )
end

-- Terminal mode: jk to escape
vim.keymap.set('t', 'jk', '<C-\\><C-n>', { noremap = true, silent = true })
