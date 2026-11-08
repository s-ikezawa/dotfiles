-- chezmoi.vim: chezmoi のソースのファイル（このリポジトリ）のファイルタイプを正しく判定し、テンプレートにも色を付ける。
-- dot_・executable_・private_・run_once_ などの接頭辞と .tmpl を外して、本来のファイルタイプを判定する
-- （dot_zshrc → zsh、dot_config/git/ignore → gitignore、run_once_before_02-homebrew.sh.tmpl → sh）。
-- テンプレート（*.tmpl と .chezmoitemplates/ の中）は「sh.chezmoitmpl」のようなファイルタイプになり、
-- 中身の言語の色の上に {{ }} の Go テンプレートの色を重ねる。
-- テンプレートだけは Tree-sitter ではなく Vim の構文ハイライトで色を付ける（{{ }} が混ざると中身の言語のパーサーが読めないため）。
-- https://github.com/alker0/chezmoi.vim

-- 一時バッファを使って判定する。これがあれば、読み込む順番（filetype on より前か、ほかのプラグインより前か）を気にしなくてよい。
-- Neovim のプラグイン管理では README でもこれを勧めている。vim.pack.add（読み込み）より前に設定する
vim.g['chezmoi#use_tmp_buffer'] = 1

vim.pack.add({ 'https://github.com/alker0/chezmoi.vim' }) -- リリースのタグがないので既定のブランチを追う

-- テンプレートでは Tree-sitter を止め、Vim の構文ハイライト（中身の言語 + {{ }}）に切り替える。
-- tree-sitter-manager は「sh.chezmoitmpl」の先頭の sh から bash のパーサーを見つけて始めてしまい、
-- {{ }} に色が付かず、パーサーも {{ }} を読めずに色が崩れるため。
-- tree-sitter-manager の FileType の処理が終わってから止めるよう、vim.schedule で遅らせる
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('config_chezmoi_template', { clear = true }),
  pattern = '*chezmoitmpl',
  desc = 'chezmoi のテンプレートでは Tree-sitter を止めて Vim の構文ハイライトを使う',
  callback = function(args)
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(args.buf) then return end
      vim.treesitter.stop(args.buf)
      vim.bo[args.buf].syntax = vim.bo[args.buf].filetype -- 例: sh.chezmoitmpl → syntax/sh.vim と syntax/chezmoitmpl.vim
    end)
  end,
})
