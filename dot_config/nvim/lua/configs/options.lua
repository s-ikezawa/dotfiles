-- Neovim 本体のオプション。
--
-- 既定で足りているものは書かない。hlsearch / incsearch / autoindent / smarttab /
-- mouse は既定で有効、termguicolors は端末が対応していれば自動で有効になり、
-- undodir と backupdir は既定で ~/.local/state/nvim 配下（XDG）を指す。
-- 一覧は :help nvim-defaults。

-- キーマップの <leader>。Space はノーマルモードでは l と同じ（右へ 1 文字）
-- 挙動しか持たないので、潰しても失うものが無い。
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

-- 行番号。number と relativenumber を両方 on にすると、カーソル行だけが絶対番号で
-- 他は相対番号になる。5j や d3k の距離を数えずに済む。
opt.number = true
opt.relativenumber = true

-- サイン用の桁を常に空けておく。既定の "auto" はサインが出た瞬間に桁が生まれ、
-- 本文が横にずれる。
opt.signcolumn = "yes"

-- カーソル行に下線。ウィンドウを分割したとき、どれが入力先かを見失わないため。
opt.cursorline = true

-- カーソルの上下に 5 行残してスクロールする。
opt.scrolloff = 5

-- インデント。プロジェクトに .editorconfig があればそちらが勝つ（Nvim の
-- editorconfig プラグインは既定で有効）ので、ここはそれが無いときの値。
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2

-- 小文字だけで打った検索は大文字小文字を無視し、大文字を混ぜたときだけ区別する。
-- smartcase は ignorecase が on のときにしか効かないので 2 つで 1 組。
opt.ignorecase = true
opt.smartcase = true

-- 分割は右と下に開く。既定（左と上）は、開いた瞬間に元のウィンドウが動く。
opt.splitright = true
opt.splitbelow = true

-- アンドゥ履歴をファイルに残し、閉じた後も遡れるようにする。
-- 置き場は既定の ~/.local/state/nvim/undo で、Neovim が自動で作る。
opt.undofile = true

-- 空白・タブ・NBSP を可視化する。差分にだけ現れて画面では見えない、という状態を
-- 作らないため。
opt.list = true

-- 記号は VSCode の whitespace 描画に合わせる。VSCode はスペースを U+00B7
-- MIDDLE DOT、タブを U+2192 RIGHTWARDS ARROW で描き、タブの残り幅は空白で埋める
-- （microsoft/vscode の src/vs/editor/common/viewLayout/viewLineRenderer.ts）。
-- lcs-tab の "xy" は x を 1 つ置いてから y を入るだけ繰り返す形なので、"→ " で
-- VSCode と同じ「矢印のあと空白」になる。
--
-- trail を space と同じ文字で明示するのは、省略時の挙動がヘルプでは「blank」と
-- 読めるため。書いておけば space を上書きして必ず点が出る。
-- nbsp だけは VSCode の whitespace 描画に対応する記号が無い。見えないと混入に
-- 気づけないので Nvim の既定（+）を残す。
--
-- listchars に置ける文字は単一幅のものだけ（E1512）。U+00B7 も U+2192 も
-- East Asian Ambiguous なので、端末やフォントが全角で描くと列がずれる。
opt.listchars = { tab = "→ ", space = "·", trail = "·", nbsp = "+" }

-- ヤンクと削除をシステムのクリップボードと共有する（macOS では Neovim が
-- pbcopy / pbpaste を provider として使う）。x や d で消したものもクリップボードに
-- 入るので、貼るつもりで取っておいた内容は上書きされる。直前のヤンクだけを
-- 貼りたいときは "0p（レジスタ 0 は最後のヤンクだけが入る）。
opt.clipboard = "unnamedplus"
