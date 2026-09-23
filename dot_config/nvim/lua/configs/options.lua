-- Neovim 自体のオプション。
--
-- 既定値と違うものだけを書く(既定値は 0.12.5 の `nvim --clean` で確認した)。
-- ファイルタイプごとの設定は ftplugin と .editorconfig(0.9 以降は Neovim 本体が読む)が
-- 後から上書きするので、ここに書くのは全体の既定として扱う。

local o = vim.o

-- 行番号 ---------------------------------------------------------------------
o.number = true
o.relativenumber = true -- 相対行番号。10j のような移動の行数を数えやすい

-- 画面 -----------------------------------------------------------------------
o.cursorline = true
o.signcolumn = "yes"    -- 既定の auto は診断やサインが出た瞬間に桁がずれるので常時出す
o.scrolloff = 8         -- カーソルの上下に最低 8 行残す
o.sidescrolloff = 8
o.wrap = false          -- 長い行を折り返さない
o.laststatus = 3        -- ステータスラインをウィンドウごとではなく画面下に 1 本だけ出す
o.winborder = "rounded" -- LSP のホバーなどフロートウィンドウの枠(0.11 で追加されたオプション)
o.pumheight = 10        -- 補完候補ウィンドウの高さの上限

-- 空白の可視化 ---------------------------------------------------------------
o.list = true
-- listchars は key=value の集合なので vim.o ではなく vim.opt で書く。
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- インデント -----------------------------------------------------------------
o.expandtab = true -- タブキーでスペースを入れる
o.shiftwidth = 2   -- 自動インデントの幅(既定 8)
o.tabstop = 2      -- タブ文字の表示幅
-- smartindent は入れない。言語ごとのインデントは ftplugin と treesitter が持っていて、
-- smartindent が効くとそちらと衝突する(Python の # で桁が飛ぶのが有名な例)。

-- 検索 -----------------------------------------------------------------------
o.ignorecase = true
o.smartcase = true     -- 検索語に大文字が入っていたときだけ大小を区別する
o.inccommand = "split" -- :s の結果をプレビューする。既定の nosplit は行内だけ、split は別窓にも出す

-- 折り畳み -------------------------------------------------------------------
-- ファイルを開いた時点では折り畳みを全部開いておく(既定 -1 は foldlevel 0 のままで全部閉じる)。
-- ftplugin が foldmethod を expr や syntax にする言語でも、開いた直後は中身が見える。
-- ファイル内のモードラインの foldlevel と diff モードはこれより優先される。
o.foldlevelstart = 99

-- ウィンドウ分割 -------------------------------------------------------------
o.splitright = true -- 縦分割は右に開く
o.splitbelow = true -- 横分割は下に開く

-- ファイルと履歴 -------------------------------------------------------------
o.undofile = true   -- アンドゥ履歴をファイルに残し、閉じた後も元に戻せるようにする
o.undolevels = 10000
o.confirm = true    -- 未保存のまま閉じようとしたとき、エラーで失敗させず保存するか尋ねる

-- 操作 -----------------------------------------------------------------------
o.clipboard = "unnamedplus" -- y / p を OS のクリップボードと共有する(macOS は pbcopy/pbpaste 経由)
o.timeoutlen = 300          -- マッピングの続きを待つ時間(既定 1000)
o.updatetime = 250          -- CursorHold の発火とスワップ書き出しの間隔(既定 4000)
o.virtualedit = "block"     -- 矩形選択のときだけ行末より先にカーソルを置ける

-- grep -----------------------------------------------------------------------
-- :grep / :vimgrep の外部コマンドを ripgrep にする。--vimgrep が file:line:col:text で出すので
-- grepformat もそれに合わせる。
o.grepprg = "rg --vimgrep"
o.grepformat = "%f:%l:%c:%m"

-- ここで設定していないもの
--   termguicolors  対応端末なら Neovim が起動時に判定して有効にする(0.12.5 + Ghostty で確認)
--   mouse          既定の "nvi" で通常・挿入・ビジュアルでは既に有効
--   hlsearch       既定で有効
