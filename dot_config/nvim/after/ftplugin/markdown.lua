-- Markdown のファイルの設定。Neovim に同梱の ftplugin のあとに読まれる（after/）。

-- 長い行を折り返す。文章が多く、横にスクロールするより読みやすいため（ほかのファイルは options.lua の wrap = false のまま）。
-- render-markdown で隠した記号（リンクの URL など）も折り返す位置の計算に入るので、
-- リンクの多い行は少し早めに折り返されることがある（Neovim の制約）。<leader>uw で切り替えられる。
vim.opt_local.wrap = true

-- ファイルタイプが変わったら、折り返しを元（グローバルの値）に戻す
vim.b.undo_ftplugin = (vim.b.undo_ftplugin and vim.b.undo_ftplugin .. ' | ' or '') .. 'setlocal wrap<'
