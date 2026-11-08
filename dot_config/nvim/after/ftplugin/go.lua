-- Go のファイルの設定。Neovim に同梱の ftplugin のあとに読まれる（after/）。

-- インデントはタブ（gofmt と同じ）。同梱の ftplugin も同じ設定をするが、ここで確かめられるように書いておく
vim.opt_local.expandtab = false -- <Tab> でスペースではなくタブ文字を入れる
vim.opt_local.shiftwidth = 0    -- >> や自動インデントの幅を tabstop に合わせる
vim.opt_local.softtabstop = 0   -- <Tab>・<BS> でタブ 1 文字ずつ動く

-- タブを 4 桁で表示する（VS Code の Go と同じ。options.lua の全体の値 2 だとインデントが浅く見える）
vim.opt_local.tabstop = 4

-- タブの印（options.lua の listchars の »）を出さない。Go はすべてのインデントがタブなので、印だらけになるため。
-- 行末の空白（·）とノーブレークスペース（␣）の印はそのまま出す
vim.opt_local.listchars:append({ tab = '  ' })

-- ファイルタイプが変わったら、上の設定を元（グローバルの値）に戻す
vim.b.undo_ftplugin = (vim.b.undo_ftplugin and vim.b.undo_ftplugin .. ' | ' or '') .. 'setlocal et< sw< sts< ts< lcs<'
