-- ===================================
-- リーダーキー設定
-- ===================================
-- スペースキーをリーダーキーとして設定
vim.g.mapleader = ","
vim.g.localmapleader = ","

-- ===================================
-- クリップボード設定
-- ===================================
-- システムクリップボードとの連携を有効化
vim.opt.clipboard = "unnamedplus"
if not vim.g.vscode then
  -- OSC52を使用したクリップボード共有（SSHやTmux経由で便利）
  vim.g.clipboard = "osc52"
end

-- ===================================
-- 表示設定
-- ===================================
-- 行番号を表示
vim.opt.number = true
-- 相対行番号を表示（現在行からの相対位置）
vim.opt.relativenumber = true
-- 24bit RGBカラーを有効化
vim.opt.termguicolors = true
-- 現在のカーソル行をハイライト
vim.opt.cursorline = true
-- スクロール時に上下に余白を確保（カーソルが端に行かないようにする）
vim.opt.scrolloff = 8
-- 横スクロール時の余白
vim.opt.sidescrolloff = 8
-- コマンドラインの高さ
vim.opt.cmdheight = 1
-- 常にサインカラム（行番号の左側）を表示してレイアウトのずれを防ぐ
vim.opt.signcolumn = "yes"
-- 長い行を折り返す
vim.opt.wrap = true
-- 行の折り返し位置を単語の境界にする（wrapがtrueの場合に有効）
vim.opt.linebreak = true
-- LSPのhoverなどの罫線
vim.o.winborder = "double"

-- ===================================
-- インデント・タブ設定
-- ===================================
-- タブをスペースに展開
vim.opt.expandtab = true
-- シフト幅を2スペースに設定
vim.opt.shiftwidth = 2
-- タブ入力時のスペース数
vim.opt.softtabstop = 2
-- タブ文字の表示幅
vim.opt.tabstop = 2
-- インデント操作時にshiftwidthの倍数に丸める
vim.opt.shiftround = true
-- 自動インデントを有効化
vim.opt.autoindent = true
-- スマートインデント（プログラミング言語の構文に応じた自動インデント）
vim.opt.smartindent = true

-- ===================================
-- 検索設定
-- ===================================
-- 検索時に大文字小文字を区別しない
vim.opt.ignorecase = true
-- 検索パターンに大文字が含まれている場合は区別する
vim.opt.smartcase = true
-- 検索結果をハイライト
vim.opt.hlsearch = true
-- インクリメンタルサーチ（入力中に検索を開始）
vim.opt.incsearch = true

-- ===================================
-- ウィンドウ分割設定
-- ===================================
-- 縦分割時に右側に新しいウィンドウを開く
vim.opt.splitright = true
-- 横分割時に下側に新しいウィンドウを開く
vim.opt.splitbelow = true

-- ===================================
-- 補完設定
-- ===================================
-- 補完メニューの動作設定
vim.opt.completeopt = {
  "menu",     -- 補完メニューを使用
  "menuone",  -- 候補が1つでもメニューを表示
  "noinsert", -- 自動的に挿入しない
  "noselect", -- 自動的に選択しない
  "fuzzy"     -- ファジー検索を有効化
}

-- ===================================
-- ステータスライン設定
-- ===================================
-- グローバルステータスライン（全てのウィンドウで1つのステータスラインを共有）
vim.opt.laststatus = 3

-- ===================================
-- 特殊文字の可視化
-- ===================================
-- 不可視文字を表示
vim.opt.list = true
-- 不可視文字の表示記号を設定
vim.opt.listchars = {
  space = "·", -- スペースを点で表示
  tab = "→ ", -- タブを矢印で表示
  trail = "·", -- 行末のスペースを点で表示
  extends = "»", -- 画面右端を超える文字があることを示す
  precedes = "«", -- 画面左端を超える文字があることを示す
  nbsp = "␣" -- ノーブレークスペースを表示
}

-- ===================================
-- ファイル・バッファ設定
-- ===================================
-- ファイルの変更を自動的に読み込む
vim.opt.autoread = true
-- ファイルエンコーディングをUTF-8に設定
vim.opt.fileencoding = "utf-8"
-- 隠れバッファを許可（保存せずに他のバッファに移動可能）
vim.opt.hidden = true
-- スワップファイルを作成しない
vim.opt.swapfile = false
-- バックアップファイルを作成しない
vim.opt.backup = false
-- undoファイルを永続化
vim.opt.undofile = true
-- undoの保存ディレクトリ
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- ===================================
-- パフォーマンス・動作設定
-- ===================================
-- ファイル更新の検知を速くする（ミリ秒）
vim.opt.updatetime = 250
-- キーマッピングのタイムアウト時間（ミリ秒）
vim.opt.timeoutlen = 300
-- マウス操作を全モードで無効化
vim.opt.mouse = ""

-- ===================================
-- その他の便利な設定
-- ===================================
-- コマンドライン補完を強化
vim.opt.wildmenu = true
-- コマンドライン補完のモード
vim.opt.wildmode = { "longest:full", "full" }
-- 一部のファイルを補完候補から除外
vim.opt.wildignore = { "*.o", "*.obj", "*.pyc", "*.swp", "*.bak", "*~" }
-- ビジュアルモードで選択範囲を保持しながらインデント操作
vim.opt.virtualedit = "block"
-- 長い行のパフォーマンスを改善
vim.opt.synmaxcol = 300

-- ===================================
-- 折りたたみ設定
-- ===================================
-- 折りたたみを有効化
vim.opt.foldenable = true
-- ファイルを開いたときに折りたたまずに全て展開した状態にする
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
-- 折りたたみ列を表示（0で非表示、1以上で表示）
vim.opt.foldcolumn = "0"

-- ===================================
-- 環境変数設定
-- ===================================
-- mise shimsをPATHに追加（開発ツールのバージョン管理）
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH

