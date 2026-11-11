-- gitsigns: git の変更箇所に印を付け、変更の固まり（hunk）ごとに見たり、ステージしたり、戻したりする。
-- 印は VS Code のように行番号の右に色付きの縦線で出す（並びは lua/config/statuscolumn.lua）。
-- https://github.com/lewis6991/gitsigns.nvim

-- v3.0.0 が出るまでの間だけ main を追う。出たら vim.version.range('*')（最新のリリース）に戻す。
-- v2.1.0 には、外で git commit しても印が古いまま残る不具合がある。.git を見張るハンドル（uv_fs_event）の
-- 後片付けを GC に任せていて、リポジトリのバッファが全部閉じた直後に GC が走ると、見張りだけ止まった
-- リポジトリの情報がキャッシュに残り、同じリポジトリのファイルを開き直すとそれが使い回される。
-- 修正は main の c5480c0（GC に任せずに片付ける）と 1189caf（fs_event が失敗したら fs_poll に切り替える）。
-- リリースの PR（#1511）は 2026-11-11 の時点で未マージ。
-- version を変えただけでは入っている版は変わらないので、vim.pack.update({ 'gitsigns.nvim' }) で切り替える。
vim.pack.add({ { src = 'https://github.com/lewis6991/gitsigns.nvim', version = 'main' } })

local bar = '▎' -- 細い縦線

require('gitsigns').setup({
  signs = {               -- まだステージしていない変更の印
    add = { text = bar },          -- 追加した行
    change = { text = bar },       -- 変更した行
    delete = { text = '▁' },       -- この行の下で行を消した
    topdelete = { text = '▔' },    -- この行の上で行を消した（ファイルの先頭）
    changedelete = { text = bar }, -- 変更して、その下で行も消した
    untracked = { text = '┆' },    -- git に追加していないファイルの行
  },
  signs_staged = {        -- ステージ済みの変更の印（色はステージしていないものより薄い）
    add = { text = bar },
    change = { text = bar },
    delete = { text = '▁' },
    topdelete = { text = '▔' },
    changedelete = { text = bar },
    untracked = { text = '┆' },
  },
  attach_to_untracked = true, -- git に追加していない新しいファイルにも印を付ける（Claude が作ったファイルを見るため）

  on_attach = function(buf)
    local gs = require('gitsigns')
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
    end

    -- hunk の移動（差分モードでは Neovim 標準の ]c・[c のまま）
    map('n', ']h', function() gs.nav_hunk('next') end, '次の変更へ')
    map('n', '[h', function() gs.nav_hunk('prev') end, '前の変更へ')
    map('n', ']H', function() gs.nav_hunk('last') end, '最後の変更へ')
    map('n', '[H', function() gs.nav_hunk('first') end, '最初の変更へ')

    -- hunk の確認
    map('n', '<leader>ghp', gs.preview_hunk_inline, '変更前の内容をその場に出す')
    map('n', '<leader>ghP', gs.preview_hunk, '変更前との差分をフローティングで出す')
    map('n', '<leader>ghb', function() gs.blame_line({ full = true }) end, 'この行を最後に変えたコミットを出す')
    map('n', '<leader>ghB', gs.blame, 'ファイル全体の blame を出す')
    map('n', '<leader>ghd', gs.diffthis, 'インデックスとの差分を左右に並べる')
    map('n', '<leader>ghD', function() gs.diffthis('~') end, '直前のコミットとの差分を左右に並べる')

    -- hunk の操作
    map('n', '<leader>ghs', gs.stage_hunk, 'この変更をステージする・取り消す')
    map('n', '<leader>ghr', gs.reset_hunk, 'この変更を元に戻す')
    map('x', '<leader>ghs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, '選んだ行をステージする・取り消す')
    map('x', '<leader>ghr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, '選んだ行を元に戻す')
    map('n', '<leader>ghS', gs.stage_buffer, 'ファイル全体をステージする')
    map('n', '<leader>ghR', gs.reset_buffer, 'ファイル全体を元に戻す')

    -- hunk を選ぶテキストオブジェクト（vih で選ぶ、dih で消す など）
    map({ 'o', 'x' }, 'ih', gs.select_hunk, '変更の固まり')
  end,
})
