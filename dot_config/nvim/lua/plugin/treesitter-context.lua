-- treesitter-context: カーソルのある関数やクラスなどの見出し行を、画面の上に固定して出す。
-- 長い関数の途中や差分の途中を読んでいても、どの関数の中かがわかる。
-- パーサーは tree-sitter-manager で入れたものを使う。:TSContext toggle で一時的に止められる。
-- 固定した行をクリックすると、その行へ移る（<C-o> で戻る）。
-- https://github.com/nvim-treesitter/nvim-treesitter-context

vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter-context' }) -- 最新のリリース（v1.0.0）が古いので既定のブランチを追う

require('treesitter-context').setup({
  max_lines = 3, -- 固定する行は 3 行まで（入れ子が深いときに本文が隠れすぎないように。外側から捨てる）
})

vim.keymap.set('n', '[x', function()
  require('treesitter-context').go_to_context(vim.v.count1)
end, { desc = '外側の見出し（関数・クラスなど）へ' }) -- README の [c は差分モードの「前の変更へ」とぶつかるので使わない
vim.keymap.set('n', '<leader>ut', '<cmd>TSContext toggle<cr>', { desc = '見出しの固定表示（treesitter-context）を切り替える' })
