-- Normal
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = "左のウィンドウへ移動" })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = "下のウィンドウへ移動" })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = "上のウィンドウへ移動" })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = "右のウィンドウへ移動" })

-- ウィンドウをhjkl連打で調整できるようにする
-- Esc or Enterでモードを抜ける
local function resize_mode()
  while true do
    local char = vim.fn.getcharstr()
    if char == "h" then
      vim.cmd("vertical resize -2")
    elseif char == "l" then
      vim.cmd("vertical resize +2")
    elseif char == "k" then
      vim.cmd("resize +2")
    elseif char == "j" then
      vim.cmd("resize -2")
    elseif char == "s" then
      vim.cmd("wincmd x")
    elseif char == "=" then
      vim.cmd("wincmd =")
    elseif char == "\27" or char == "\13" or char == "q" then
      -- ESC("\27") or Enter("\13") or q が押されたら終了
      break
    end

    vim.cmd("redraw")
  end
end
vim.keymap.set('n', '<leader>wr', resize_mode, { desc = "ウィンドウのリサイズ" })

-- Terminal
vim.keymap.set('t', '<Esc><Esc>', [[<C-\><C-n>]], { desc = "ターミナルモードを抜ける" })
vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]], { desc = "左のウィンドウへ" })
vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]], { desc = "下のウィンドウへ" })
vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]], { desc = "上のウィンドウへ" })
vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]], { desc = "右のウィンドウへ" })

