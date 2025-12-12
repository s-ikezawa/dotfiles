return {
  init_options = {
    hostInfo = 'neovim',
    tsserver = {
      path = vim.env.HOME .. '/.local/share/mise/installs/npm-typescript/latest/lib/node_modules/typescript/lib/tsserver.js'
    }
  },
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact'
  }
}
