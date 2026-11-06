-- キーマップ。
-- LazyVim・AstroNvim・NvChad・kickstart.nvim のキーマップから、プラグインなしで動くものを集めた。
-- キーの割り当てが食い違うところは LazyVim に合わせている（<leader> の後のキーで用途を分ける）。
--   <leader>b: バッファ  <leader>c: コード  <leader>f: ファイル  <leader>q: 終了
--   <leader>u: 表示の切り替え  <leader>w: ウィンドウ  <leader>x: リスト  <leader><tab>: タブ

local map = vim.keymap.set

-- ---------------------------------------------------------------------------
-- 移動
-- ---------------------------------------------------------------------------
-- 回数を付けないときは、折り返した行も画面の 1 行ずつ上下する（5j などは論理行で数える）
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = '下へ' })
map({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = '下へ' })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = '上へ' })
map({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = '上へ' })

-- ---------------------------------------------------------------------------
-- ウィンドウ
-- ---------------------------------------------------------------------------
map('n', '<C-h>', '<C-w>h', { desc = '左のウィンドウへ' })
map('n', '<C-j>', '<C-w>j', { desc = '下のウィンドウへ' })
map('n', '<C-k>', '<C-w>k', { desc = '上のウィンドウへ' })
map('n', '<C-l>', '<C-w>l', { desc = '右のウィンドウへ' })

map('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'ウィンドウを高くする' })
map('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'ウィンドウを低くする' })
map('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'ウィンドウを狭くする' })
map('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'ウィンドウを広くする' })

map('n', '<leader>-', '<C-w>s', { desc = 'ウィンドウを上下に分ける' })
map('n', '<leader>|', '<C-w>v', { desc = 'ウィンドウを左右に分ける' })
map('n', '<leader>wd', '<C-w>c', { desc = 'ウィンドウを閉じる' })

-- ---------------------------------------------------------------------------
-- バッファ
-- ---------------------------------------------------------------------------
map('n', '<S-h>', '<cmd>bprevious<cr>', { desc = '前のバッファへ' })
map('n', '<S-l>', '<cmd>bnext<cr>', { desc = '次のバッファへ' })
map('n', '[b', '<cmd>bprevious<cr>', { desc = '前のバッファへ' })
map('n', ']b', '<cmd>bnext<cr>', { desc = '次のバッファへ' })
map('n', '<leader>bb', '<cmd>e #<cr>', { desc = '直前のバッファに切り替える' })
map('n', '<leader>`', '<cmd>e #<cr>', { desc = '直前のバッファに切り替える' })
map('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = 'バッファを閉じる' })
map('n', '<leader>fn', '<cmd>enew<cr>', { desc = '新しい空のバッファを開く' })

-- ---------------------------------------------------------------------------
-- タブ
-- ---------------------------------------------------------------------------
map('n', '<leader><tab><tab>', '<cmd>tabnew<cr>', { desc = '新しいタブを開く' })
map('n', '<leader><tab>d', '<cmd>tabclose<cr>', { desc = 'タブを閉じる' })
map('n', '<leader><tab>o', '<cmd>tabonly<cr>', { desc = 'ほかのタブを閉じる' })
map('n', '<leader><tab>]', '<cmd>tabnext<cr>', { desc = '次のタブへ' })
map('n', '<leader><tab>[', '<cmd>tabprevious<cr>', { desc = '前のタブへ' })
map('n', '<leader><tab>f', '<cmd>tabfirst<cr>', { desc = '最初のタブへ' })
map('n', '<leader><tab>l', '<cmd>tablast<cr>', { desc = '最後のタブへ' })
map('n', ']t', '<cmd>tabnext<cr>', { desc = '次のタブへ' })
map('n', '[t', '<cmd>tabprevious<cr>', { desc = '前のタブへ' })

-- ---------------------------------------------------------------------------
-- 検索
-- ---------------------------------------------------------------------------
-- <Esc> で検索の強調を消す（ノーマル・挿入・選択モード）
map({ 'n', 'i', 's' }, '<Esc>', function()
  vim.cmd('nohlsearch')
  return '<Esc>'
end, { expr = true, desc = '検索の強調を消して <Esc>' })

-- n は ? で検索したときも常に下へ、N は常に上へ進む。見つかった行の折り畳みは開く
map('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = '次の検索結果へ' })
map({ 'x', 'o' }, 'n', "'Nn'[v:searchforward]", { expr = true, desc = '次の検索結果へ' })
map('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = '前の検索結果へ' })
map({ 'x', 'o' }, 'N', "'nN'[v:searchforward]", { expr = true, desc = '前の検索結果へ' })

map('n', '<leader>ur', '<cmd>nohlsearch<bar>diffupdate<bar>normal! <C-l><cr>', { desc = '再描画（検索の強調を消し、差分を取り直す）' })

-- ---------------------------------------------------------------------------
-- 編集
-- ---------------------------------------------------------------------------
-- 行を上下に入れ替える（左の Option が Alt として効く Ghostty の設定が前提）
map('n', '<A-j>', "<cmd>execute 'move .+' . v:count1<cr>==", { desc = '行を下へ移す' })
map('n', '<A-k>', "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = '行を上へ移す' })
map('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = '行を下へ移す' })
map('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = '行を上へ移す' })
map('v', '<A-j>', ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = '選択した行を下へ移す' })
map('v', '<A-k>', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = '選択した行を上へ移す' })

-- 選択したままインデントを続けて変える
map('x', '<', '<gv', { desc = 'インデントを減らす（選択を保つ）' })
map('x', '>', '>gv', { desc = 'インデントを増やす（選択を保つ）' })
map('x', '<S-Tab>', '<gv', { desc = 'インデントを減らす（選択を保つ）' })
map('x', '<Tab>', '>gv', { desc = 'インデントを増やす（選択を保つ）' })

-- 句読点を打つたびに undo の区切りを入れる（u で一度に戻りすぎないように）
map('i', ',', ',<C-g>u', { desc = ', で undo を区切る' })
map('i', '.', '.<C-g>u', { desc = '. で undo を区切る' })
map('i', ';', ';<C-g>u', { desc = '; で undo を区切る' })

-- コメント（gc・gcc は Neovim の標準）
map('n', 'gco', 'o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = '下にコメント行を足す' })
map('n', 'gcO', 'O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = '上にコメント行を足す' })
map('n', '<leader>/', 'gcc', { remap = true, desc = '行のコメントを切り替える' })
map('x', '<leader>/', 'gc', { remap = true, desc = '選択範囲のコメントを切り替える' })

map('n', '<C-c>', '<cmd>%y+<cr>', { desc = 'ファイル全体をクリップボードにコピーする' })

-- ---------------------------------------------------------------------------
-- 保存・終了
-- ---------------------------------------------------------------------------
map({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = '保存する' })
map('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'すべて閉じて終了する' })
map('n', '<C-q>', '<cmd>q!<cr>', { desc = '保存せずにウィンドウを閉じる' })

-- ---------------------------------------------------------------------------
-- 診断・リスト
-- ---------------------------------------------------------------------------
-- 診断へ移り、内容をフローティングウィンドウで出す
local function diagnostic_goto(next, severity)
  return function()
    vim.diagnostic.jump({
      count = (next and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    })
  end
end
map('n', ']d', diagnostic_goto(true), { desc = '次の診断へ' })
map('n', '[d', diagnostic_goto(false), { desc = '前の診断へ' })
map('n', ']e', diagnostic_goto(true, 'ERROR'), { desc = '次のエラーへ' })
map('n', '[e', diagnostic_goto(false, 'ERROR'), { desc = '前のエラーへ' })
map('n', ']w', diagnostic_goto(true, 'WARN'), { desc = '次の警告へ' })
map('n', '[w', diagnostic_goto(false, 'WARN'), { desc = '前の警告へ' })
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'カーソル行の診断を出す' })
map('n', 'gl', vim.diagnostic.open_float, { desc = 'カーソル行の診断を出す' })

-- quickfix・ロケーションリストを開いていれば閉じ、閉じていれば開く
local function toggle_list(is_open, close, open)
  return function()
    local ok, err = pcall(is_open() and close or open)
    if not ok and err then vim.notify(err, vim.log.levels.ERROR) end
  end
end
map('n', '<leader>xq', toggle_list(function() return vim.fn.getqflist({ winid = 0 }).winid ~= 0 end, vim.cmd.cclose, vim.cmd.copen), { desc = 'quickfix リストを開く・閉じる' })
map('n', '<leader>xl', toggle_list(function() return vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 end, vim.cmd.lclose, vim.cmd.lopen), { desc = 'ロケーションリストを開く・閉じる' })
map('n', ']q', vim.cmd.cnext, { desc = '次の quickfix へ' })
map('n', '[q', vim.cmd.cprev, { desc = '前の quickfix へ' })

-- ---------------------------------------------------------------------------
-- 表示の切り替え
-- ---------------------------------------------------------------------------
-- オプションを切り替えて、新しい値を通知する
local function toggle(option, off, on)
  return function()
    local value = vim.o[option]
    if off == nil then
      vim.o[option] = not value
    else
      vim.o[option] = value == on and off or on
    end
    vim.notify(('%s = %s'):format(option, tostring(vim.o[option])))
  end
end
map('n', '<leader>us', toggle('spell'), { desc = 'スペルチェックを切り替える' })
map('n', '<leader>uw', toggle('wrap'), { desc = '折り返しを切り替える' })
map('n', '<leader>ul', toggle('number'), { desc = '行番号を切り替える' })
map('n', '<leader>uL', toggle('relativenumber'), { desc = '相対行番号を切り替える' })
map('n', '<leader>uc', toggle('conceallevel', 0, 2), { desc = '記号の隠し表示（conceal）を切り替える' })
map('n', '<leader>ub', toggle('background', 'light', 'dark'), { desc = '背景の明暗を切り替える' })
map('n', '<leader>ud', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = '診断の表示を切り替える' })
map('n', '<leader>uh', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = 'インレイヒント（LSP）を切り替える' })
map('n', '<leader>ui', vim.show_pos, { desc = 'カーソル位置のハイライトを調べる' })
map('n', '<leader>uI', function()
  vim.treesitter.inspect_tree()
  vim.api.nvim_input('I')
end, { desc = '構文木（treesitter）を出す' })

-- ---------------------------------------------------------------------------
-- その他
-- ---------------------------------------------------------------------------
map('n', '<leader>K', '<cmd>norm! K<cr>', { desc = 'カーソル位置の語を keywordprg で調べる' })

-- ターミナル
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'ターミナルモードを抜ける' })
-- ターミナルからもウィンドウを移る（フローティングウィンドウではキーをそのまま送る）
local function term_nav(dir)
  return function()
    if vim.api.nvim_win_get_config(0).zindex then
      vim.api.nvim_feedkeys(vim.keycode('<C-' .. dir .. '>'), 'n', false)
    else
      vim.cmd.wincmd(dir)
    end
  end
end
map('t', '<C-h>', term_nav('h'), { desc = '左のウィンドウへ' })
map('t', '<C-j>', term_nav('j'), { desc = '下のウィンドウへ' })
map('t', '<C-k>', term_nav('k'), { desc = '上のウィンドウへ' })
map('t', '<C-l>', term_nav('l'), { desc = '右のウィンドウへ' })
