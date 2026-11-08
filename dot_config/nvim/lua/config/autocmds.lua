-- 自動コマンド。

local function augroup(name)
  return vim.api.nvim_create_augroup('config_' .. name, { clear = true })
end

-- ---------------------------------------------------------------------------
-- 外で書き換えられたファイルを読み直す
-- ---------------------------------------------------------------------------
-- Claude Code などが開いているファイルを書き換えたら、画面の内容を新しくする。
-- autoread（options.lua）は :checktime が呼ばれたときにしか確かめないので、そのきっかけを作る。
-- 自分も編集していて保存していないバッファは読み直さず、どうするか聞かれる。
local function checktime()
  -- コマンドラインの入力中やコマンドラインウィンドウでは :checktime を呼べない
  if vim.fn.mode() == 'c' or vim.fn.getcmdwintype() ~= '' then return end
  vim.cmd('checktime')
end

vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI', 'TermClose', 'TermLeave' }, {
  group = augroup('checktime'),
  desc = 'フォーカスが戻ったときや、手が止まったときにファイルの変更を確かめる',
  callback = checktime,
})

-- 何も操作せずに眺めている間も気付けるよう、2 秒ごとにも確かめる
vim.uv.new_timer():start(2000, 2000, vim.schedule_wrap(checktime))

vim.api.nvim_create_autocmd('FileChangedShellPost', {
  group = augroup('file_changed'),
  desc = '読み直したことを知らせる',
  callback = function(args)
    vim.notify(('外で変更されたので読み直しました: %s'):format(vim.fn.fnamemodify(args.file, ':~:.')))
  end,
})

-- ---------------------------------------------------------------------------
-- 構文で折り畳む
-- ---------------------------------------------------------------------------
-- Tree-sitter のパーサーがあるファイルでは、関数・クラス・ブロックなどの構文の単位で折り畳む。
-- パーサーのないファイル（zsh や chezmoi のテンプレートなど）は、options.lua のインデントでの折り畳みのまま
-- （Tree-sitter の折り畳みにすると、まったく畳めなくなるため）。
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('treesitter_fold'),
  desc = 'Tree-sitter のパーサーがあれば構文で折り畳む',
  callback = function(args)
    if args.match:find('chezmoitmpl', 1, true) then return end -- テンプレートは {{ }} があってパーサーが正しく読めない
    local ok, parser = pcall(vim.treesitter.get_parser, args.buf) -- パーサーがないとエラーか nil になる
    if not ok or not parser then return end
    vim.opt_local.foldmethod = 'expr'
    vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  end,
})