return {
  'saghen/blink.cmp',
  version = '1.*',
  event = { 'InsertEnter' },
  opts = {
    keymap = { preset = 'super-tab' }, -- default, super-tab, enter, none
    sources = {
      default = { 'lsp', 'path', 'buffer'}
    }
  },
}
