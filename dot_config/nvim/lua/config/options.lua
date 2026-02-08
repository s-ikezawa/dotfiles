-- Provider settings (外部プロバイダーの無効化)
vim.g.loaded_python3_provider = 0 -- Python3プロバイダーを無効化（起動高速化）
vim.g.loaded_node_provider = 0 -- Node.jsプロバイダーを無効化（起動高速化）
vim.g.loaded_ruby_provider = 0 -- Rubyプロバイダーを無効化（起動高速化）
vim.g.loaded_perl_provider = 0 -- Perlプロバイダーを無効化（起動高速化）

-- Mapleader settings (リーダーキー設定)
vim.g.mapleader = "," -- リーダーキーをカンマに設定

-- Indentation (インデント設定)
vim.opt.tabstop = 2 -- タブ文字の表示幅を2スペースに設定
vim.opt.shiftwidth = 2 -- 自動インデントのスペース数を2に設定
vim.opt.softtabstop = 2 -- タブキー押下時に挿入されるスペース数を2に設定
vim.opt.expandtab = true -- タブ文字をスペースに変換する
vim.opt.smartindent = true -- 構文に応じた自動インデントを有効化
vim.opt.autoindent = true -- 前の行のインデントを引き継ぐ
vim.opt.shiftround = true -- インデントをshiftwidthの倍数に丸める

-- Search settings (検索設定)
vim.opt.ignorecase = true -- 検索時に大文字小文字を区別しない
vim.opt.smartcase = true -- 大文字を含む場合は大文字小文字を区別する
vim.opt.hlsearch = false -- 検索結果のハイライトを無効化
vim.opt.incsearch = true -- インクリメンタルサーチを有効化（入力中にリアルタイム検索）

-- Visual Settings (表示設定)
vim.opt.number = true -- 行番号を表示する
vim.opt.relativenumber = true -- 相対行番号を表示する（カーソル行からの距離）
vim.opt.wrap = true -- 長い行を折り返して表示する
vim.opt.breakindent = true -- 折り返し行でもインデントを維持する
vim.opt.linebreak = true -- 単語の途中で折り返さず、単語境界で折り返す
vim.opt.scrolloff = 10 -- カーソルの上下に常に10行分の余白を確保する
vim.opt.sidescrolloff = 8 -- カーソルの左右に常に8列分の余白を確保する
vim.opt.termguicolors = true -- 24bitカラー（TrueColor）を有効化
vim.opt.termsync = true -- ターミナルへの描画を同期的にまとめて送信する（ちらつき防止）
vim.opt.signcolumn = "yes" -- サイン列（Git差分やエラーマーク）を常に表示する
vim.opt.cursorline = true -- カーソル行をハイライトする
vim.opt.showmatch = true -- 対応する括弧を一瞬ハイライトする
vim.opt.matchtime = 2 -- 対応括弧のハイライト時間（0.2秒）
vim.opt.cmdheight = 1 -- コマンドラインの高さを1行に設定
vim.opt.showmode = false -- 現在のモード表示を非表示にする（ステータスライン側で表示する場合）
vim.opt.shortmess:append({
  W = true, -- 書き込み時の"written"メッセージを省略
  I = true, -- 起動時のイントロメッセージを非表示
  c = true, -- 補完メニューのメッセージを省略
  C = true, -- スキャン中のメッセージを省略
})
vim.opt.pumheight = 10 -- 補完メニューの最大表示行数を10に設定
vim.opt.pumblend = 0 -- 補完メニューの透過度（0=不透明、Zellij環境では0推奨）
vim.opt.winblend = 0 -- フローティングウィンドウの透過度（0=不透明）
vim.opt.completeopt = "menu,menuone,noselect,fuzzy,popup" -- 補完メニューの動作設定（メニュー表示、1件でも表示、自動選択なし、あいまい検索、ポップアップ）
vim.opt.winborder = "rounded" -- フローティングウィンドウの枠線を角丸にする
vim.opt.inccommand = "nosplit" -- 置換コマンドの結果をリアルタイムでプレビューする
vim.opt.conceallevel = 2 -- 構文隠蔽レベル（2=代替文字で置換して表示）
vim.opt.confirm = true -- 未保存の変更がある場合に確認ダイアログを表示する
vim.opt.concealcursor = "" -- カーソル行ではconceal（隠蔽）を解除して元のテキストを表示する
vim.opt.synmaxcol = 300 -- シンタックスハイライトを処理する最大列数（長い行の処理を制限して高速化）
vim.opt.ruler = false -- ルーラー（カーソル位置表示）を非表示にする
vim.opt.virtualedit = "block" -- ビジュアルブロックモードで文字がない位置にもカーソルを移動可能にする
vim.opt.winminwidth = 5 -- ウィンドウの最小幅を5列に設定
vim.opt.laststatus = 3 -- ステータスラインをグローバル表示（全ウィンドウで1本のみ）
vim.opt.fillchars = {
  foldopen = "", -- 展開中の折りたたみマーク
  foldclose = "", -- 折りたたまれたマーク
  fold = " ", -- 折りたたみの埋め文字
  diff = "╱", -- 差分表示の削除行の埋め文字
  eob = " ", -- バッファ末尾の「~」を非表示にする
}
vim.opt.list = true -- 不可視文字を可視化する
vim.opt.listchars = {
  tab = "→ ", -- タブ文字を「→ 」で表示
  --  space = "·", -- スペースを「·」で表示（無効）
  trail = "•", -- 行末の余分なスペースを「•」で表示
  --  eol = "↲", -- 改行を「↲」で表示（無効）
  nbsp = "␣", -- ノーブレークスペースを「␣」で表示
  extends = "›", -- 折り返しなしで右にはみ出す行の末尾に「›」を表示
  precedes = "‹", -- 折り返しなしで左にはみ出す行の先頭に「‹」を表示
}

-- File handling (ファイル管理設定)
vim.opt.backup = false -- バックアップファイルを作成しない
vim.opt.writebackup = false -- 書き込み時のバックアップを作成しない
vim.opt.swapfile = false -- スワップファイルを作成しない
vim.opt.undofile = true -- アンドゥ履歴をファイルに保存する（Neovim再起動後も元に戻せる）
vim.opt.undolevels = 10000 -- アンドゥ履歴の最大数を10000に設定
vim.opt.undodir = vim.fn.expand("~/.local/share/nvim/undo") -- アンドゥファイルの保存先ディレクトリ
vim.opt.updatetime = 300 -- スワップファイル書き込みやCursorHold発火までの待機時間（300ミリ秒）
vim.opt.timeoutlen = 300 -- キーマッピングの入力待ち時間（300ミリ秒）
vim.opt.ttimeoutlen = 0 -- ターミナルのキーコード入力待ち時間（0=即座に処理）
vim.opt.autoread = true -- 外部でファイルが変更されたら自動的に再読み込みする
vim.opt.autowrite = true -- バッファ切り替え時に変更を自動保存する

-- Behavior settings (動作設定)
vim.opt.hidden = true -- 未保存のバッファを隠しバッファとして保持できるようにする
vim.opt.errorbells = false -- エラー時のビープ音を無効化
vim.opt.backspace = "indent,eol,start" -- バックスペースでインデント・改行・挿入開始位置を削除可能にする
vim.opt.autochdir = false -- カレントディレクトリを自動変更しない
vim.opt.iskeyword:append("-") -- ハイフンを単語の一部として扱う（w移動やciw等に影響）
vim.opt.path:append("**") -- ファイル検索パスにサブディレクトリを再帰的に追加する
vim.opt.selection = "exclusive" -- ビジュアル選択の末尾をカーソル位置の手前までにする
vim.opt.mouse = "" -- マウス操作を無効化する
vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- クリップボード連携（SSH時は無効、ローカルではシステムクリップボードを使用）
vim.opt.modifiable = true -- バッファの編集を許可する
vim.opt.encoding = "UTF-8" -- 内部エンコーディングをUTF-8に設定
vim.opt.jumpoptions = "view" -- ジャンプ時にスクロール位置を維持する
vim.opt.spelllang = { "en", "cjk" } -- スペルチェックの対象言語（cjkで日本語を除外）

-- Folding settings (折りたたみ設定)
vim.opt.foldenable = true -- コードの折りたたみを有効化する
vim.opt.smoothscroll = true -- スムーズスクロールを有効化する（折りたたみ行も滑らかに移動）
vim.opt.foldmethod = "expr" -- 折りたたみ方法を式（Treesitter等）に設定する
vim.opt.foldlevel = 99 -- 初期の折りたたみレベル（99=起動時にすべて展開した状態）
vim.opt.formatoptions = "jcroqlnt" -- テキスト整形オプション（コメント連結、自動改行、リスト認識など）
vim.opt.grepformat = "%f:%l:%c:%m" -- grepの出力フォーマット（ファイル名:行:列:メッセージ）
vim.opt.grepprg = "rg --vimgrep" -- grepコマンドとしてripgrepを使用する
vim.opt.foldcolumn = "0" -- 折りたたみ列を非表示にする

-- Split behavior (画面分割設定)
vim.opt.splitbelow = true -- 水平分割時に新しいウィンドウを下に開く
vim.opt.splitright = true -- 垂直分割時に新しいウィンドウを右に開く
vim.opt.splitkeep = "screen" -- 分割時にスクリーン上のテキスト位置を維持する

-- Command-line completion (コマンドライン補完設定)
vim.opt.wildmenu = true -- コマンドライン補完メニューを有効化する
vim.opt.wildmode = "longest:full,full" -- 補完モード（最長一致→完全一致の順で補完）
vim.opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar" }) -- 補完候補から除外するファイルパターン

-- Better diff options (差分表示の改善)
vim.opt.diffopt:append("linematch:60") -- 行内差分のマッチング精度を向上させる（最大60行まで比較）

-- Performance improvements (パフォーマンス改善)
vim.opt.redrawtime = 10000 -- 画面再描画の最大処理時間（10秒、大きなファイルのハイライト用）
vim.opt.maxmempattern = 20000 -- 正規表現パターンマッチングの最大メモリ使用量（KB）

-- Create undo directory if it doesn't exist (アンドゥディレクトリがなければ作成)
local undodir = vim.fn.expand("~/.local/share/nvim/undo")
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end

-- カスタムファイルタイプの追加定義
vim.filetype.add({
  extension = {
    env = "dotenv", -- .env拡張子をdotenvファイルタイプとして認識
  },
  filename = {
    [".env"] = "dotenv", -- .envファイルをdotenvとして認識
    ["env"] = "dotenv", -- envファイルをdotenvとして認識
  },
  pattern = {
    ["[jt]sconfig.*.json"] = "jsonc", -- tsconfig/jsconfig系のJSONをJSONC（コメント付きJSON）として認識
    ["%.env%.[%w_.-]+"] = "dotenv", -- .env.local等のファイルをdotenvとして認識
  },
})
