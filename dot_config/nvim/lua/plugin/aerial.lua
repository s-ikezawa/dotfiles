-- aerial: 関数・クラス・メソッドなどのシンボルの一覧（アウトライン）を右のサイドバーに出す。
-- カーソルを動かすと一覧の選択も付いてくるので、大きいファイルの形と、いまどこにいるかがつかめる。
-- シンボルは Tree-sitter から取り、取れない言語では LSP から取る。
-- 一覧では <CR> で移り、p でカーソルを一覧に残したまま移る。o・za で畳む・開く、q で閉じる。? でキーの一覧。
-- https://github.com/stevearc/aerial.nvim

vim.pack.add({ { src = 'https://github.com/stevearc/aerial.nvim', version = vim.version.range('*') } }) -- 最新のリリースを追う

require('aerial').setup({
  show_guides = true, -- 入れ子のシンボルの前に罫線を引いて、階層を見やすくする
})

vim.keymap.set('n', '<leader>cs', '<cmd>AerialToggle!<cr>', { desc = 'シンボルの一覧（アウトライン）を開く・閉じる' }) -- ! でカーソルはコードに残す
vim.keymap.set('n', '<leader>cS', '<cmd>AerialNavToggle<cr>', { desc = 'シンボルを階層ごとに並べて選ぶ（フローティング）' })
