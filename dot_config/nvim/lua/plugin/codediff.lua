-- codediff: VS Code のような差分ビューア。変更されたファイルの一覧から選んで、左右に並べて見る。
-- Claude Code が書き換えている間も、一覧と差分が自動で更新される。
-- 差分の計算に使うライブラリは、初めて使うときに GitHub のリリースから自動で落とす（:CodeDiff install）。
-- 差分の画面で g? を押すとキーの一覧が出る。]c・[c で変更、]f・[f でファイルを移り、q で閉じる。
-- https://github.com/esmuellert/codediff.nvim

vim.pack.add({ { src = 'https://github.com/esmuellert/codediff.nvim', version = vim.version.range('*') } }) -- 最新のリリースを追う

require('codediff').setup({
  diff = {
    -- 差分を 1 つのウィンドウに出し、消した行は仮想の行として重ねる。
    -- 左右に並べる表示だと、新しいファイルなどは 1 つのウィンドウになり、ファイルによって見た目が変わるため。
    -- 差分の画面で t を押すと左右に並べる表示と切り替えられる。
    layout = 'inline',
  },
  explorer = {
    view_mode = 'tree',              -- 変更されたファイルの一覧をツリーで出す（i で一覧と切り替え）
    line_stats = { enabled = true }, -- ファイルごとに増えた行と減った行の数（+12 -4）を出す
  },
  keymaps = {
    view = {
      toggle_explorer = '<leader>E',  -- 一覧の表示・非表示（既定の <leader>b はバッファのキーと重なるので変える）
      stage_hunk = '<leader>ghs',     -- この変更をステージする（gitsigns のキーと揃える）
      unstage_hunk = '<leader>ghu',   -- この変更のステージを取り消す
      discard_hunk = '<leader>ghr',   -- この変更を元に戻す
    },
  },
})

vim.keymap.set('n', '<leader>gd', '<cmd>CodeDiff<cr>', { desc = '変更（作業ツリー）を差分ビューアで見る' })
vim.keymap.set('n', '<leader>gD', '<cmd>CodeDiff --staged<cr>', { desc = 'ステージ済みの変更を差分ビューアで見る' })
vim.keymap.set('n', '<leader>gH', '<cmd>CodeDiff history<cr>', { desc = 'コミットの履歴を差分ビューアで見る' })
vim.keymap.set('n', '<leader>gf', '<cmd>CodeDiff history %<cr>', { desc = 'このファイルの履歴を差分ビューアで見る' })
