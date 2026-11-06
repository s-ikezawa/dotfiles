-- エディタのオプション。
-- LazyVim・AstroNvim・NvChad・kickstart.nvim の options から、プラグインなしで意味のあるものを集めた。

-- ---------------------------------------------------------------------------
-- グローバル変数
-- ---------------------------------------------------------------------------
vim.g.mapleader = ' '                -- <leader> をスペースにする
vim.g.maplocalleader = '\\'          -- <localleader>（ファイルタイプごとのマッピング用）を \ にする
vim.g.markdown_recommended_style = 0 -- Markdown の ftplugin がインデントを 4 に変えないようにする
vim.g.loaded_node_provider = 0       -- Node.js のプロバイダを読まない（使わないので起動と :checkhealth を軽くする）
vim.g.loaded_python3_provider = 0    -- Python 3 のプロバイダを読まない
vim.g.loaded_perl_provider = 0       -- Perl のプロバイダを読まない
vim.g.loaded_ruby_provider = 0       -- Ruby のプロバイダを読まない

-- ---------------------------------------------------------------------------
-- 表示
-- ---------------------------------------------------------------------------
vim.o.number = true                  -- 行番号を出す
vim.o.relativenumber = true          -- 行番号をカーソルからの相対値で出す（5j などの移動に使う）
vim.o.numberwidth = 2                -- 行番号の列の最小幅
vim.o.signcolumn = 'yes'             -- サインの列を常に出す（印が付くたびに本文が左右にずれないように）
vim.o.cursorline = true              -- カーソル行を強調する
vim.o.scrolloff = 5                  -- カーソルの上下に最低 5 行を残してスクロールする
vim.o.sidescrolloff = 8              -- カーソルの左右に最低 8 列を残して横にスクロールする
vim.o.smoothscroll = true            -- 折り返した行を画面の行単位でなめらかにスクロールする
vim.o.wrap = false                   -- 長い行を折り返さない
vim.o.linebreak = true               -- 折り返すときは単語の切れ目で折り返す（:set wrap にしたとき用）
vim.o.breakindent = true             -- 折り返した行を元の行のインデントに揃える
vim.o.list = true                    -- タブや行末の空白などを見えるようにする
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' } -- list で使う記号（タブ・行末の空白・ノーブレークスペース）
vim.opt.fillchars = {
  foldopen = '\u{f47c}',             -- 開いた折り畳みの印（foldcolumn を出したとき。Nerd Font の記号）
  foldclose = '\u{f460}',            -- 閉じた折り畳みの印
  fold = ' ',                        -- 閉じた折り畳みの行を埋める文字
  foldsep = ' ',                     -- foldcolumn の区切り
  diff = '╱',                        -- 差分で片側にしかない行を埋める文字
  eob = ' ',                         -- ファイルの末尾より後の行に ~ を出さない
}
vim.o.termguicolors = true           -- 24 ビットカラーを使う
vim.o.pumblend = 10                  -- 補完メニューを少し透過させる
vim.o.pumheight = 10                 -- 補完メニューに一度に出す候補の数
vim.o.winborder = 'rounded'          -- フローティングウィンドウの枠を角丸にする
vim.o.laststatus = 3                 -- ステータスラインを画面全体で 1 本にする
vim.o.title = true                   -- ターミナルのタイトルをファイル名にする
vim.o.winminwidth = 5                -- ウィンドウの最小幅

-- ---------------------------------------------------------------------------
-- 折り畳み
-- ---------------------------------------------------------------------------
vim.o.foldmethod = 'indent'          -- インデントで折り畳む
vim.o.foldlevel = 99                 -- 開いたときは折り畳まない（zc などで必要なところだけ畳む）
vim.o.foldtext = ''                  -- 閉じた折り畳みには最初の行を色付きのまま出す

-- ---------------------------------------------------------------------------
-- 差分
-- ---------------------------------------------------------------------------
vim.opt.diffopt:remove('linematch:40')                            -- 既定の linematch を外す（下の 60 と重複しないように）
vim.opt.diffopt:append({ 'algorithm:histogram', 'linematch:60' }) -- 差分を histogram で取り、変更された行どうしを対応付ける

-- ---------------------------------------------------------------------------
-- 検索・置換
-- ---------------------------------------------------------------------------
vim.o.ignorecase = true              -- 大文字と小文字を区別せずに検索する
vim.o.smartcase = true               -- 検索語に大文字を含むときだけ区別する
vim.o.inccommand = 'split'           -- :s の置換結果を入力中に表示し、画面外の分は下に一覧する
vim.o.grepprg = 'rg --vimgrep'       -- :grep に ripgrep を使う
vim.o.grepformat = '%f:%l:%c:%m'     -- rg --vimgrep の出力（ファイル:行:列:本文）を読む書式

-- ---------------------------------------------------------------------------
-- 編集
-- ---------------------------------------------------------------------------
vim.o.expandtab = true               -- タブの代わりにスペースを入れる
vim.o.tabstop = 2                    -- タブ文字を 2 桁で表示する
vim.o.softtabstop = 2                -- <Tab> や <BS> で 2 桁ずつ動く
vim.o.shiftwidth = 2                 -- >> や自動インデントの幅
vim.o.shiftround = true              -- > や < でインデントを shiftwidth の倍数に揃える
vim.o.smartindent = true             -- 改行したときに構文に合わせてインデントする
vim.o.copyindent = true              -- 自動インデントで前の行のインデントの文字（タブかスペースか）を写す
vim.o.preserveindent = true          -- インデントを変えるときに元の文字をできるだけ残す
vim.opt.backspace:append('nostop')   -- <BS> でインデントや挿入の開始位置で止まらない
vim.opt.whichwrap:append('<>[]hl')   -- h・l・← → で行頭・行末から前後の行へ移る
vim.o.virtualedit = 'block'          -- 矩形選択では文字のないところにもカーソルを置ける
vim.o.formatoptions = 'jcroqlnt'     -- 自動整形の方法（コメントの継続、番号付きリストの整形、行の結合でコメント記号を消すなど）
vim.o.completeopt = 'menu,menuone,noselect' -- 候補が 1 つでもメニューを出し、最初の候補を勝手に選ばない
vim.o.infercase = true               -- キーワード補完で入力した大文字・小文字に合わせる
vim.o.wildmode = 'longest:full,full' -- コマンドラインの補完で、まず共通部分まで補ってから候補を順に出す
vim.opt.spelllang = { 'en', 'cjk' }  -- スペルチェックは英語。日本語などの CJK 文字は対象外にする

-- ---------------------------------------------------------------------------
-- ウィンドウ・タブ
-- ---------------------------------------------------------------------------
vim.o.splitright = true              -- 縦に分けたウィンドウを右に開く
vim.o.splitbelow = true              -- 横に分けたウィンドウを下に開く
vim.o.splitkeep = 'screen'           -- ウィンドウを分けても本文が上下に動かないようにする
vim.o.tabclose = 'uselast'           -- タブを閉じたら直前に使っていたタブへ移る
vim.opt.jumpoptions:append('view')   -- <C-o> などで戻ったとき、画面の位置も元に戻す

-- ---------------------------------------------------------------------------
-- ファイル・システム
-- ---------------------------------------------------------------------------
vim.o.clipboard = vim.env.SSH_CONNECTION and '' or 'unnamedplus' -- ヤンクを macOS のクリップボードと共有する（SSH 中は OSC 52 に任せる）
vim.o.mouse = 'a'                    -- すべてのモードでマウスを使う
vim.o.autoread = true                -- 外で書き換えられたファイルを読み直す（Neovim の既定。確かめるきっかけは autocmds.lua）
vim.o.undofile = true                -- undo の履歴をファイルに残し、閉じても戻せるようにする
vim.o.undolevels = 10000             -- undo できる回数
vim.o.confirm = true                 -- 保存していないバッファを閉じるとき、エラーにせず保存するか聞く
vim.o.autowrite = true               -- :make や別のファイルへの移動の前に自動で保存する
vim.o.writebackup = false            -- 上書きの前にバックアップを作らない
vim.o.updatetime = 250               -- 入力が止まってからスワップを書き、CursorHold を起こすまでの時間（ミリ秒）
vim.o.timeoutlen = 500               -- <leader> などの複数キーのマッピングを待つ時間（ミリ秒）
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true }) -- 保存時・起動画面・補完中のメッセージを出さない
vim.opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp', 'folds' } -- :mksession で保存する内容
