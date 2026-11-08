-- treesitter-textobjects: 関数・クラス・引数を単位にして選んだり（vaf・dif など）、移ったり（]f など）する。
-- 構文木を使うので、インデントや括弧の形に左右されない。パーサーは tree-sitter-manager で入れたものを使う。
-- キーは LazyVim に合わせる。
-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects

vim.pack.add({ { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'main' } }) -- リリースのタグがないので main を追う

require('nvim-treesitter-textobjects').setup({
  select = {
    lookahead = true, -- カーソルが対象の外にあれば、先にある次の対象を選ぶ
  },
  move = {
    set_jumps = true, -- 移る前の位置をジャンプリストに残す（<C-o> で戻る）
  },
})

local map = vim.keymap.set

-- 選ぶ（ビジュアルモードと、d・c・y などの後）
local objects = {
  f = { '@function', '関数' },
  c = { '@class', 'クラス' },
  a = { '@parameter', '引数' },
}
for key, o in pairs(objects) do
  local query, name = o[1], o[2]
  map({ 'x', 'o' }, 'a' .. key, function()
    require('nvim-treesitter-textobjects.select').select_textobject(query .. '.outer', 'textobjects')
  end, { desc = name .. '（全体）' })
  map({ 'x', 'o' }, 'i' .. key, function()
    require('nvim-treesitter-textobjects.select').select_textobject(query .. '.inner', 'textobjects')
  end, { desc = name .. '（中身）' })
end

-- 移る。小文字は始まりへ、大文字は終わりへ
local function move(fn, query, key)
  return function()
    -- 差分モードの ]c・[c は Neovim 標準の「次・前の変更へ」のまま使う
    if vim.wo.diff and key:find('[cC]') then return vim.cmd('normal! ' .. key) end
    require('nvim-treesitter-textobjects.move')[fn](query, 'textobjects')
  end
end
for key, o in pairs(objects) do
  local query, name = o[1] .. '.outer', o[2]
  map({ 'n', 'x', 'o' }, ']' .. key, move('goto_next_start', query, ']' .. key), { desc = '次の' .. name .. 'の始まりへ' })
  map({ 'n', 'x', 'o' }, '[' .. key, move('goto_previous_start', query, '[' .. key), { desc = '前の' .. name .. 'の始まりへ' })
  map({ 'n', 'x', 'o' }, ']' .. key:upper(), move('goto_next_end', query, ']' .. key:upper()), { desc = '次の' .. name .. 'の終わりへ' })
  map({ 'n', 'x', 'o' }, '[' .. key:upper(), move('goto_previous_end', query, '[' .. key:upper()), { desc = '前の' .. name .. 'の終わりへ' })
end
