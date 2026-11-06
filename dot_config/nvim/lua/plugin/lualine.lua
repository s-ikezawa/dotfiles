-- lualine: ステータスライン。モード、git のブランチとリポジトリ全体の変更の数、ファイル名、
-- そのファイルの差分の行数、言語サーバーの状態、診断の数、ファイルタイプ、カーソル位置を出す。
-- https://github.com/nvim-lualine/lualine.nvim

vim.pack.add({ 'https://github.com/nvim-lualine/lualine.nvim' }) -- リリースのタグがないので既定のブランチを追う

local repo_status = require('config.repo_status')
repo_status.setup({
  -- 数が変わったらすぐ描き直す（lualine は描き直しを予約して、決まった間隔でしか描かないため）
  on_change = function() require('lualine').refresh({ force = true, place = { 'statusline' } }) end,
})

local lsp_progress = require('config.lsp_progress')
lsp_progress.setup({
  on_change = function() require('lualine').refresh({ force = true, place = { 'statusline' } }) end,
})

vim.o.showmode = false -- モードは lualine に出すので、コマンドラインには出さない

require('lualine').setup({
  options = {
    theme = 'catppuccin-mocha', -- catppuccin に同梱の配色
    globalstatus = true,        -- ステータスラインを画面全体で 1 本にする（options.lua の laststatus = 3 と同じ）
  },
  sections = {
    lualine_a = { 'mode' },     -- モード（NORMAL・INSERT など）
    lualine_b = {
      {
        'branch',               -- git のブランチ
        separator = '',         -- 後ろの変更の数とひと続きに見えるよう、間に区切りを入れない
      },
      {
        repo_status.text,       -- リポジトリ全体で変更されたファイルの数（変更・追加・削除・未追跡のアイコンと数）
        -- 文字の色だけ変えて目立たせる（背景はブランチと同じ枠のものを使う）
        color = { fg = require('catppuccin.palettes').get_palette('mocha').yellow },
        padding = { left = 0, right = 1 }, -- ブランチの右の空白とで 1 つになるよう、左の空白はなくす
      },
    },
    lualine_c = {
      { 'filename', path = 1 }, -- ファイル名（いまのフォルダからの相対パス）
      {
        'diff',                 -- このファイルの差分の行数（gitsigns の数を使う）
        symbols = {             -- アイコンはリポジトリ全体の数と揃える
          added = repo_status.icons.added,
          modified = repo_status.icons.modified,
          removed = repo_status.icons.deleted,
        },
        source = function()
          local s = vim.b.gitsigns_status_dict
          if s then return { added = s.added, modified = s.changed, removed = s.removed } end
        end,
      },
    },
    lualine_x = {
      lsp_progress.text,        -- 言語サーバーの名前と、インデックス作業などの進み具合
      {
        'diagnostics',          -- このファイルの診断の数（アイコンは lsp.lua のサインと揃える）
        symbols = { error = '\u{f057} ', warn = '\u{f071} ', info = '\u{f05a} ', hint = '\u{f0eb} ' },
      },
      'filetype',               -- ファイルタイプ
    },
    lualine_y = { 'progress' }, -- ファイルの中の位置（%）
    lualine_z = { 'location' }, -- カーソルの行と列
  },
})
