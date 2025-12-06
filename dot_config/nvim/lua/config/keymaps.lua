if vim.g.vscode then
  local vscode = require('vscode')

  vim.keymap.set('n', 'za',
    function()
      vscode.call('editor.toggleFold')
    end,
    { noremap = true, silent = true }
  )
end
