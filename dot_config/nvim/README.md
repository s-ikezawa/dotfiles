# Neovim の設定

Claude Code が書き換えたコードを、じっくり読んでレビューするための Neovim の設定です（簡単な差分は hunk で見ます）。
Claude Code は Neovim の中ではなく herdr の別のペインで動かし、claudecode.nvim でつなぎます。

- Neovim 0.12 以降が前提です（プラグインは標準の `vim.pack` で入れます）。
- `<leader>` はスペース、`<localleader>` は `\` です。
- キーを途中まで押すと、続けて押せるキーの一覧が出ます（which-key）。`<leader>?` で、いまのバッファだけのキーを一覧できます。

## 目次

- [フォルダの構成](#フォルダの構成)
- [必要なもの](#必要なもの)
- [プラグインの入れ方・更新](#プラグインの入れ方更新)
- [プラグインの一覧](#プラグインの一覧)
- [やりたいこと別の使い方](#やりたいこと別の使い方)
- [キーマップ](#キーマップ)
- [プラグインを使わない工夫](#プラグインを使わない工夫)

## フォルダの構成

| 場所 | 中身 |
|---|---|
| `init.lua` | 入り口。`config/` を読み、`lua/plugin/` のファイルを名前順にすべて読む |
| `lua/config/options.lua` | エディタのオプション |
| `lua/config/keymaps.lua` | プラグインを使わないキーマップ |
| `lua/config/autocmds.lua` | 自動コマンド（外で書き換えられたファイルを読み直す） |
| `lua/config/lsp.lua` | LSP と診断の設定 |
| `lua/config/statuscolumn.lua` | 行番号の周りの列（git の印を行番号の右に出す） |
| `lua/config/repo_status.lua` | リポジトリ全体の変更の数（ステータスラインに出す） |
| `lua/config/lsp_progress.lua` | 言語サーバーの状態と進み具合（ステータスラインに出す） |
| `lua/config/indent.lua` | ファイルタイプごとのインデントを設定する関数（`after/ftplugin/` から呼ぶ） |
| `lua/plugin/<名前>.lua` | プラグインごとの設定。1 つのプラグインにつき 1 ファイル |
| `lsp/<名前>.lua` | 言語サーバーごとの設定（`vim.lsp.enable` で有効にする） |
| `after/ftplugin/<ファイルタイプ>.lua` | ファイルタイプごとの設定（Neovim に同梱の ftplugin のあとに読まれる） |

## 必要なもの

mise で入れるもの:

- 言語サーバー: lua-language-server、TypeScript 7（`npm:typescript`。`tsc --lsp` を使う）、gopls、kotlin-lsp
- tree-sitter CLI（パーサーのビルド用。C コンパイラとして Xcode も要る）
- ripgrep（`rg`）、ast-grep（grug-far と `:grep` で使う）

そのほか:

- Nerd Font（アイコンに使う）
- Ghostty（左の Option を Alt として使う設定。`<A-j>`・`<A-k>` で行を移すため）
- herdr（Claude Code を動かすペイン。Claude に送るキーで使う）

## プラグインの入れ方・更新

- Neovim を起動すると、`lua/plugin/` に書かれたプラグインが入っていなければ自動で入ります。
- 更新は `:lua vim.pack.update()` です。ロックファイル（`nvim-pack-lock.json`）は chezmoi で管理せず、マシンごとに任せます。
- 新しいプラグインを足すときは、`lua/plugin/<名前>.lua` を作るだけで読み込まれます。
- プラグインを入れたり消したりした直後の起動では、catppuccin の配色がまだそのプラグインに合っていません。もう一度起動すると合います。

## プラグインの一覧

### 見た目

| プラグイン | できること |
|---|---|
| [catppuccin](https://github.com/catppuccin/nvim) | カラースキーム（Mocha）。hunk・bat・delta と同じ配色にそろえる。入れたプラグインを見つけて、その配色も合わせる |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | ステータスライン。モード、ブランチ、**リポジトリ全体の変更の数**、ファイル名、そのファイルの差分の行数、**言語サーバーの状態と進み具合**、診断の数、ファイルタイプ、位置 |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | キーを途中まで押すと、続けて押せるキーと説明を一覧する |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | ファイルの種類ごとのアイコン（neo-tree・which-key・trouble などが使う） |

### ファイルを探す・開く

| プラグイン | できること |
|---|---|
| [fff](https://github.com/dmtrKovalenko/fff) | ファイル名と本文のあいまい検索。打ち間違いに強く、よく開くファイルや git で変更したファイルを上に出す。Claude が作ったファイルもすぐ候補に出る |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | ファイルのツリーをフローティングウィンドウで出す。git の状態も出る。Claude がファイルを足したり消したりすると自動で更新される |

### 差分を見る・git

| プラグイン | できること |
|---|---|
| [codediff.nvim](https://github.com/esmuellert/codediff.nvim) | VS Code のような差分ビューア。変更されたファイルの一覧（ツリー、増えた行と減った行の数つき）から選んで差分を見る。Claude が書き換えている間も自動で更新される。コミットの履歴も見られる |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | 変更した行に印を付け（行番号の右の縦線）、変更の固まり（hunk）ごとに移る・覗く・ステージする・戻す。blame も出せる |

### コードを読む

| プラグイン | できること |
|---|---|
| [tree-sitter-manager.nvim](https://github.com/romus204/tree-sitter-manager.nvim) | Tree-sitter のパーサーを入れて、構文に沿ったハイライトを有効にする。パーサーのない言語のファイルを開くと、その場で入れる。`:TSManager` で一覧から入れたり消したり、`:TSUpdate` で更新 |
| [nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context) | カーソルのある関数やクラスの見出し行を、画面の上に固定する（3 行まで）。長い関数や差分の途中でも、どこにいるかがわかる |
| [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) | 関数・クラス・引数を単位にして選んだり（`vaf`・`dif`・`yac` など）、移ったり（`]f`・`[c` など）する。構文木を使うので、インデントや括弧の形に左右されない |
| [glance.nvim](https://github.com/DNLHC/glance.nvim) | 定義・参照・実装・型定義を、その場のフローティングウィンドウで覗く（VS Code の Peek）。左にコードのプレビュー、右に見つかった場所の一覧が出て、ジャンプせずに読める。標準の `gd`・`grr`・`gri`・`grt` を置き換え、結果が 1 件なら直接移る |
| [aerial.nvim](https://github.com/stevearc/aerial.nvim) | 関数・クラス・メソッドなどのシンボルの一覧（アウトライン）を右のサイドバーに出す。カーソルを動かすと一覧の選択も付いてくる。シンボルは Tree-sitter から取り、取れない言語では LSP から取る。TSX・JSX では `div` などの要素も入れ子で出るので、幅は名前に合わせて最大「60 列」か「画面の 30%」の小さいほうまで広がる |
| [trouble.nvim](https://github.com/folke/trouble.nvim) | 診断・参照・定義・**呼び出し階層**・シンボル・quickfix を、ファイルごとにまとめたツリー状のリストで出す |

### chezmoi のソースを読む

| プラグイン | できること |
|---|---|
| [chezmoi.vim](https://github.com/alker0/chezmoi.vim) | chezmoi のソース（`~/.local/share/chezmoi`）のファイルタイプを、`dot_`・`executable_`・`run_once_` などの接頭辞と `.tmpl` を外して判定する（`dot_zshrc` → zsh、`dot_config/git/ignore` → gitignore）。テンプレート（`*.tmpl`・`.chezmoitemplates/`・`.chezmoiignore` など）は、中身の言語の色の上に `{{ }}` の Go テンプレートの色を重ねる。テンプレートだけは Tree-sitter を止めて、Vim の構文ハイライトで色を付ける |

### Markdown を読む

| プラグイン | できること |
|---|---|
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | Markdown をバッファの中で整えて見せる（見出しの色分け、表の罫線、コードブロックの背景、チェックボックスや箇条書きのアイコンなど）。カーソルのある行と挿入モードでは元の記号のまま出るので、そのまま編集できる。`<leader>um` で切り替え |

### 検索・置換

| プラグイン | できること |
|---|---|
| [grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim) | プロジェクト全体の検索と置換を 1 つのバッファで行う。rg と ast-grep（構文の形で探す）を切り替えられる。打つそばから結果と置換後の差分が出る。結果の行を書き換えて元のファイルに戻すこともできる（rg のときだけ） |

### Claude Code との連携

| プラグイン | できること |
|---|---|
| [claudecode.nvim](https://github.com/coder/claudecode.nvim) | Claude Code の IDE 連携。Claude Code で `/ide` を実行してつなぐと、開いているファイルと選んでいる範囲が自動で Claude に伝わる。Claude からは Neovim の LSP の診断も読める（`getDiagnostics`）。Claude の変更の提案を 1 列の差分で出し、受け入れる・断るを選べる |

## やりたいこと別の使い方

### Claude の変更をレビューする

1. `<leader>gd` で codediff を開く。左の一覧から変更されたファイルを選ぶ。
2. `]c`・`[c` で変更を、`]f`・`[f` でファイルを移る。`t` で 1 列の表示と左右に並べる表示を切り替える。
3. 気になるところは、ファイルを開いて `]h`・`[h` で変更の固まりを移りながら読む。`<leader>ghp` で変更前の内容をその場に出す。
4. 良ければ `<leader>ghs` でステージし、だめなら `<leader>ghr` で戻す。
5. 直してほしいところは、行や範囲を選んで `<leader>ap` を押し、指示を書いて Claude に送る。

### コードをたどる

- `gd` で定義へ、`gri` で実装へ、`grt` で型定義へ移る（`<C-o>` で戻る）。候補が複数あるときは glance が開き、選んでから移れる。
- `grr` で参照を glance で覗く。一覧の場所を選ぶと左のプレビューが変わるので、ジャンプせずに使われ方を読める。
- `<leader>cl` で、カーソルの語の定義・参照・実装などをまとめて右に出す（trouble）。
- `<leader>ci` でこの関数を呼んでいるところ、`<leader>co` でこの関数から呼んでいるものを一覧する。言語サーバーが対応していれば使える（gopls は使える。lua-language-server は対応していない）。
- `<leader>cs` で、このファイルのシンボル（関数・クラスなど）の一覧を右に出す（aerial）。`<leader>cS` では、階層ごとに並べたフローティングの一覧から選んで移る。
- 画面の上に固定された見出しで、いまどの関数の中かがわかる。`[x` でその見出しへ移る。
- `]f`・`[f` で次・前の関数へ、`]c`・`[c` で次・前のクラスへ移る。`vaf` で関数全体を、`vif` で中身を選ぶ。

### 診断を直す

- `]d`・`[d` で診断へ移る（`]e`・`[e` はエラーだけ、`]w`・`[w` は警告だけ）。`gl` で内容を出す。
- `<leader>xx` で、すべてのファイルの診断を一覧する（`<leader>xX` はこのファイルだけ）。
- Claude に直してもらうときは、Claude のペインで「Neovim の診断を見て直して」と頼めば、Claude が `getDiagnostics` で読む。

### プロジェクト全体を検索・置換する

- 探すだけなら `<leader>fg`（fff の grep）が速い。
- 置き換えるなら `<leader>sr`（rg）か `<leader>sa`（ast-grep）。ビジュアルモードで押すと、選んだ文字列が検索語に入る。
  - ast-grep では `$A` が 1 つのノード、`$$$` が 0 個以上のノードに当てはまる。例: 検索 `console.log($$$A)`、置換 `logger.debug($$$A)`。
  - 結果を確かめてから `\r` で置き換える。`\e` で rg と ast-grep を切り替える。

## キーマップ

標準のキーと違う動きにしたものや、足したものだけを書きます。

### 移動・ウィンドウ・バッファ・タブ

| キー | 動き |
|---|---|
| `j`・`k` | 回数を付けないときは、折り返した行も画面の 1 行ずつ上下する |
| `<C-h>`・`<C-j>`・`<C-k>`・`<C-l>` | 左・下・上・右のウィンドウへ（ターミナルの中からも） |
| `<C-Up>`・`<C-Down>`・`<C-Left>`・`<C-Right>` | ウィンドウの高さ・幅を変える |
| `<leader>-`・`<leader>\|` | ウィンドウを上下・左右に分ける |
| `<leader>wd` | ウィンドウを閉じる |
| `<S-h>`・`<S-l>`、`[b`・`]b` | 前・次のバッファへ |
| `<leader>bb`・`` <leader>` `` | 直前のバッファに切り替える |
| `<leader>bd` | バッファを閉じる |
| `<leader>fn` | 新しい空のバッファを開く |
| `<leader><tab><tab>` | 新しいタブを開く |
| `<leader><tab>d`・`<leader><tab>o` | タブを閉じる・ほかのタブを閉じる |
| `<leader><tab>]`・`<leader><tab>[`、`]t`・`[t` | 次・前のタブへ |
| `<leader><tab>f`・`<leader><tab>l` | 最初・最後のタブへ |

### 検索・編集・保存

| キー | 動き |
|---|---|
| `<Esc>` | 検索の強調を消す |
| `n`・`N` | `?` で検索したときも、常に下・上へ進む |
| `<A-j>`・`<A-k>` | 行（選んだ行）を下・上へ移す |
| `<`・`>`（ビジュアル） | 選んだままインデントを変える（`<S-Tab>`・`<Tab>` も同じ） |
| `gco`・`gcO` | 下・上にコメント行を足す |
| `<leader>/` | 行（選んだ範囲）のコメントを切り替える |
| `<C-c>` | ファイル全体をクリップボードにコピーする |
| `<C-s>` | 保存する |
| `<leader>qq` | すべて閉じて終了する |
| `<C-q>` | 保存せずにウィンドウを閉じる |
| `<Esc><Esc>`（ターミナル） | ターミナルモードを抜ける |

### ファイル（`<leader>f`・`<leader>e`）

| キー | 動き |
|---|---|
| `<leader><space>`・`<leader>ff` | ファイルを探す（fff） |
| `<leader>fg` | 本文を grep する（fff。`<S-Tab>` で正規表現・あいまいを切り替え） |
| `<leader>fz` | 本文をあいまいに grep する（fff） |
| `<leader>fw` | カーソルの語（選んだ範囲）で grep する（fff） |
| `<leader>e` | ファイルのツリーを開く・閉じる（neo-tree） |

fff の一覧では、`<C-n>`・`<C-p>` で選び、`<CR>` で開きます。`<Tab>` で複数選んで `<C-q>` を押すと quickfix へ送ります。`<Esc>` で閉じます。
neo-tree の中では `?` でキーの一覧が出ます。

### git（`<leader>g`）

| キー | 動き |
|---|---|
| `<leader>gd` | 作業ツリーの変更を差分ビューアで見る（codediff） |
| `<leader>gD` | ステージ済みの変更を差分ビューアで見る（codediff） |
| `<leader>gH` | コミットの履歴を差分ビューアで見る（codediff） |
| `<leader>gf` | このファイルの履歴を差分ビューアで見る（codediff） |
| `<leader>ge` | 変更されたファイルの一覧を開く・閉じる（neo-tree） |
| `]h`・`[h` | 次・前の変更の固まりへ（gitsigns） |
| `]H`・`[H` | 最後・最初の変更の固まりへ（gitsigns） |
| `<leader>ghp` | 変更前の内容をその場に出す |
| `<leader>ghP` | 変更前との差分をフローティングウィンドウで出す |
| `<leader>ghb` | この行を最後に変えたコミットを出す |
| `<leader>ghB` | ファイル全体の blame を出す |
| `<leader>ghd`・`<leader>ghD` | インデックス・直前のコミットとの差分を左右に並べる |
| `<leader>ghs` | この変更（選んだ行）をステージする・取り消す |
| `<leader>ghr` | この変更（選んだ行）を元に戻す |
| `<leader>ghS`・`<leader>ghR` | ファイル全体をステージする・元に戻す |
| `ih` | 変更の固まりを選ぶテキストオブジェクト（`vih`・`dih` など） |

codediff の差分の画面では、次のキーが使えます。`g?` を押すとキーの一覧が出ます。

| キー | 動き |
|---|---|
| `]c`・`[c` | 次・前の変更へ |
| `]f`・`[f` | 次・前のファイルへ |
| `t` | 1 列の表示と左右に並べる表示を切り替える |
| `i` | 一覧をツリーとリストで切り替える |
| `<leader>E` | 一覧を出す・隠す |
| `<leader>ghs`・`<leader>ghu`・`<leader>ghr` | この変更をステージする・ステージを取り消す・元に戻す |
| `q` | 閉じる |

### コード・LSP（`<leader>c`・`g`）

Neovim の標準のキー（言語サーバーがつながっているとき）:

| キー | 動き |
|---|---|
| `K` | ホバー（型やドキュメントを出す） |
| `grn` | 名前を変える |
| `gra` | コードアクション |
| `gO` | このファイルのシンボルの一覧 |
| `<C-s>`（挿入モード） | シグネチャを出す |

足したキー・置き換えたキー:

| キー | 動き |
|---|---|
| `gd` | 定義へ（複数なら glance で覗く） |
| `grr` | 参照を glance で覗く（標準の quickfix の代わり） |
| `gri` | 実装へ（複数なら glance で覗く） |
| `grt` | 型定義へ（複数なら glance で覗く） |
| `gD` | 宣言へ |
| `<leader>cl` | カーソルの語の定義・参照・実装などを右に一覧する（trouble） |
| `<leader>cs` | シンボルの一覧（アウトライン）を右に出す・閉じる（aerial。カーソルはコードに残る） |
| `<leader>cS` | シンボルを階層ごとに並べたフローティングの一覧から選んで移る（aerial） |
| `<leader>ci` | この関数を呼んでいるところを一覧する（trouble） |
| `<leader>co` | この関数から呼んでいるものを一覧する（trouble） |
| `[x` | 画面の上に固定された見出し（関数・クラスなど）へ移る（treesitter-context） |
| `<leader>K` | カーソルの語を `keywordprg` で調べる |

入力中は補完の候補が自動で出ます。

glance の一覧では、`j`・`k` で選び（左のプレビューが変わる）、`<CR>`・`o` で移ります。`v`・`s` で縦・横に分けて開き、`<Tab>`・`<S-Tab>` で次・前の場所へ移ります。`<C-q>` で一覧を trouble に送り、`<leader>l` でプレビューと一覧を行き来し、`q`・`<Esc>` で閉じます。プレビューの中ではそのまま編集できます。

aerial の一覧では、`<CR>` で移り、`p` でカーソルを一覧に残したままコードをその位置まで動かします。`{`・`}` で前・次のシンボルへ、`o`・`za` で畳む・開く、`q` で閉じます。`?` でキーの一覧が出ます。

### 関数・クラス・引数（treesitter-textobjects）

| キー | 動き |
|---|---|
| `af`・`if` | 関数の全体・中身を選ぶ（ビジュアルモードと、`d`・`c`・`y` などの後） |
| `ac`・`ic` | クラスの全体・中身を選ぶ |
| `aa`・`ia` | 引数の全体（前後のカンマを含む）・中身を選ぶ |
| `]f`・`[f` | 次・前の関数の始まりへ（`]F`・`[F` は終わりへ） |
| `]c`・`[c` | 次・前のクラスの始まりへ（`]C`・`[C` は終わりへ）。差分モードでは標準どおり次・前の変更へ |
| `]a`・`[a` | 次・前の引数の始まりへ（`]A`・`[A` は終わりへ） |

カーソルが対象の外にあるときは、先にある次の対象を選びます。移る前の位置はジャンプリストに残るので、`<C-o>` で戻れます。
codediff の差分の画面の中では、`]c`・`[c`・`]f`・`[f` は codediff のキー（変更・ファイルを移る）になります。

### 診断・リスト（`<leader>x`）

| キー | 動き |
|---|---|
| `]d`・`[d` | 次・前の診断へ |
| `]e`・`[e` | 次・前のエラーへ |
| `]w`・`[w` | 次・前の警告へ |
| `gl`・`<leader>cd` | カーソル行の診断を出す |
| `<leader>xx` | 診断の一覧（すべてのファイル）を開く・閉じる（trouble） |
| `<leader>xX` | 診断の一覧（このファイル）を開く・閉じる（trouble） |
| `<leader>xq`・`<leader>xl` | quickfix・ロケーションリストを開く・閉じる（標準の画面） |
| `<leader>xQ`・`<leader>xL` | quickfix・ロケーションリストを trouble で開く・閉じる |
| `]q`・`[q` | 次・前の項目へ（trouble の一覧が開いていればその項目、なければ quickfix） |

診断は、カーソル行以外では行末に 1 行で、カーソル行では行の下に全文を折り返して出ます（長い型エラーも切れずに読めます）。

trouble の一覧では、`<CR>` で開き、`p` でプレビュー、`o` で開いて一覧を閉じ、`q` で閉じます。`?` でキーの一覧が出ます。

### 検索・置換（`<leader>s`）

| キー | 動き |
|---|---|
| `<leader>sr` | プロジェクト全体を検索・置換する（grug-far の rg。ビジュアルモードなら選んだ文字列で） |
| `<leader>sa` | プロジェクト全体を構文の形で検索・置換する（grug-far の ast-grep） |

grug-far のバッファでは、次のキーが使えます。`g?` を押すとキーの一覧が出ます。

| キー | 動き |
|---|---|
| `\r` | 置き換える |
| `\e` | rg と ast-grep を切り替える |
| `\s` | 書き換えた結果の行を、元のファイルに戻す（rg のときだけ） |
| `\q` | 結果を quickfix に送る |
| `<CR>` | 結果の場所へ移る |

### Claude Code（`<leader>a`）

| キー | 動き |
|---|---|
| `<leader>ap` | この行（選んだ範囲）に指示を付けて Claude に送り、送信まで済ませる（herdr。`@<ファイル>#L<行> <指示>` の形で送る） |
| `<leader>as` | 選んだ範囲を Claude に送る（neo-tree の中では、カーソルのファイルを送る） |
| `<leader>ab` | このファイルを Claude に送る |
| `<leader>af` | Claude のペインへ移る（herdr） |
| `<leader>aS` | Claude との接続の状態を出す |
| `<leader>aa`・`<leader>ad` | Claude の変更の提案を受け入れる・断る |

範囲やファイルを送ると、続けて打ち込めるよう Claude のペインへ移ります。
`<leader>ap` と `<leader>af` は、herdr の同じタブ（なければ同じワークスペース）にいる Claude のペインに送ります。

### 表示の切り替え（`<leader>u`）

| キー | 動き |
|---|---|
| `<leader>us` | スペルチェック |
| `<leader>uw` | 折り返し |
| `<leader>ul`・`<leader>uL` | 行番号・相対行番号 |
| `<leader>uc` | 記号の隠し表示（conceal） |
| `<leader>ub` | 背景の明暗 |
| `<leader>ud` | 診断の表示 |
| `<leader>uh` | インレイヒント（LSP） |
| `<leader>ut` | 見出しの固定表示（treesitter-context） |
| `<leader>um` | Markdown の整形表示（render-markdown） |
| `<leader>ur` | 再描画（検索の強調を消し、差分を取り直す） |
| `<leader>ui` | カーソル位置のハイライトを調べる |
| `<leader>uI` | 構文木（Tree-sitter）を出す |
| `<leader>?` | このバッファのキーマップを一覧する（which-key） |

## プラグインを使わない工夫

- **外で書き換えられたファイルを読み直す**: Claude Code が開いているファイルを書き換えると、画面の内容も新しくなります。フォーカスが戻ったとき、手が止まったとき、2 秒ごとに確かめます。自分も編集していて保存していないバッファは、読み直さずにどうするか聞かれます。
- **git の印を行番号の右に出す**: VS Code のように、行番号の右に細い縦線で変更を示します（`lua/config/statuscolumn.lua`）。
- **リポジトリ全体の変更の数**: ステータスラインのブランチの隣に、変更・追加・削除・未追跡のファイルの数を出します。裏で 2 秒ごとに `git status` を実行します。
- **言語サーバーの進み具合**: ステータスラインの右側に、つながっている言語サーバーと、インデックス作業などの進み具合を出します。Kotlin のようにインデックスを作り終えるまで使えないサーバーで、待つ目安になります。
- **Markdown は折り返す**: ほかのファイルは長い行を折り返しませんが、Markdown は文章が多いので折り返します（`after/ftplugin/markdown.lua`。単語の切れ目で折り返し、インデントも揃える）。render-markdown で隠したリンクの URL なども折り返す位置の計算に入るので、リンクの多い行は少し早めに折り返されることがあります。`<leader>uw` で切り替えられます。
- **ファイルタイプごとのインデント**: `.editorconfig` の `indent_style`・`indent_size` にあたるものを、各言語のスタイルガイドに合わせて `after/ftplugin/<ファイルタイプ>.lua` に書いています（中身は `lua/config/indent.lua` の `spaces()`・`tabs()`）。プロジェクトに `.editorconfig` があれば、そちらが優先されます。タブの印（`»`）は、どのファイルタイプでもそろえて出します。

  | インデント | ファイルタイプ | 根拠 |
  |---|---|---|
  | スペース 2 | Lua | Neovim 本体の `.stylua.toml` |
  | スペース 2 | TypeScript・JavaScript（TSX・JSX も） | Google の JavaScript スタイルガイド、Prettier |
  | スペース 2 | JSON・JSONC | Prettier |
  | スペース 2 | YAML | Prettier（YAML の仕様はタブ禁止・幅は自由） |
  | スペース 2 | TOML | taplo |
  | スペース 2 | HTML・CSS・SCSS | Google の HTML/CSS スタイルガイド、Prettier |
  | スペース 2 | sh・bash・zsh | Google の Shell Style Guide |
  | スペース 4 | Kotlin | Kotlin のコーディング規約、Google の Android Kotlin スタイルガイド |
  | スペース 4 | Markdown | Google の Markdown スタイルガイド（入れ子のリストは 4） |
  | タブ（4 桁で表示） | Go | Effective Go（gofmt） |
  | タブ（4 桁で表示） | Makefile | GNU make（レシピの行はタブが必須） |
  | タブ（4 桁で表示） | gitconfig | `git config` が書き込む形 |

- **前回のカーソル位置に戻る**: ファイルを開き直すと、前に閉じたときの位置から始まります。Claude がファイルを書き換えて読み直したときは、カーソルを動かしません。コミットメッセージなどは先頭から始めます。
- **構文で折り畳む**: Tree-sitter のパーサーがあるファイルでは、関数・クラス・ブロックなどの単位で折り畳みます。パーサーのないファイル（zsh や chezmoi のテンプレートなど）はインデントで折り畳みます。開いたときは畳まれていないので、`zc`・`zo` で畳む・開く、`zM`・`zR` ですべて畳む・開く、`za` で切り替えます。
- **差分の取り方**: `histogram` で差分を取り、変更された行どうしを対応付けます（`linematch:60`）。
- **undo の履歴を残す**: 閉じたあとでも undo で戻せます。
