-- Markdown のファイルの設定。Neovim に同梱の ftplugin のあとに読まれる（after/）。

-- スペース 4 つでインデントする（Google の Markdown スタイルガイド「When nesting lists, use a 4-space indent
-- for both numbered and bulleted lists」。- の後ろは空白 3 つ、1. の後ろは空白 2 つにして、本文を 4 列目にそろえる）。
-- CommonMark では「記号の幅 + 空白」（- なら 2、1. なら 3）以上あれば入れ子になるので、4 なら箇条書きでも
-- 番号付きでも >> 1 回で必ず入れ子になる。Prettier・Claude が書く 2 のリストもそのまま正しく読める。
-- options.lua の markdown_recommended_style = 0 で同梱の ftplugin の設定は止めているので、ここで決める
require('config.indent').spaces(4)

-- 長い行を折り返す。文章が多く、横にスクロールするより読みやすいため（ほかのファイルは options.lua の wrap = false のまま）。
-- render-markdown で隠した記号（リンクの URL など）も折り返す位置の計算に入るので、
-- リンクの多い行は少し早めに折り返されることがある（Neovim の制約）。<leader>uw で切り替えられる。
vim.opt_local.wrap = true
vim.b.undo_ftplugin = vim.b.undo_ftplugin .. ' | setlocal wrap<' -- ファイルタイプが変わったら元に戻す
