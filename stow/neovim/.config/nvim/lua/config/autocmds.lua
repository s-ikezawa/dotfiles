-- 自動コマンド設定

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ヤンク時のハイライト
augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
  group = 'YankHighlight',
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 })
  end,
})

-- ファイルタイプ別の設定
augroup('FileTypeSettings', { clear = true })
autocmd('FileType', {
  group = 'FileTypeSettings',
  pattern = { 'python' },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- 末尾の空白を自動削除
augroup('TrimWhitespace', { clear = true })
autocmd('BufWritePre', {
  group = 'TrimWhitespace',
  pattern = '*',
  callback = function()
    local save_cursor = vim.fn.getpos('.')
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos('.', save_cursor)
  end,
})

-- ターミナル設定
autocmd('TermOpen', {
  pattern = '*',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = 'no'
    vim.cmd('startinsert')
  end,
})

-- Neo-treeのGitステータス更新を高速化
augroup('NeoTreeGitStatus', { clear = true })
autocmd({ 'BufWritePost', 'FocusGained', 'CursorHold', 'CursorHoldI' }, {
  group = 'NeoTreeGitStatus',
  pattern = '*',
  callback = function()
    -- Neo-treeが開いている場合のみリフレッシュ
    if vim.fn.exists(':Neotree') > 0 then
      local neo_tree_win = nil
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buf_name = vim.api.nvim_buf_get_name(buf)
        if string.match(buf_name, 'neo%-tree') then
          neo_tree_win = win
          break
        end
      end
      
      if neo_tree_win then
        require("neo-tree.command").execute({ action = "refresh" })
      end
    end
  end,
})