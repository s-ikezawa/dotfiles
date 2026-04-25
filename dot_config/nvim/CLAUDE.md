# Neovim Config Notes

このディレクトリは Neovim 0.12.2 の個人設定です。Claude Code がこの設定を編集する際の参照情報をまとめます。

調査日: 2026-04-25

# このリポジトリでの設定スタイル

## ファイル構成と役割

```
~/.config/nvim/
├── init.lua              # leader 設定 + 各 config モジュールの require のみ
├── nvim-pack-lock.json   # vim.pack のロックファイル (git 管理対象)
├── lsp/                   # Neovim 0.12 ネイティブ runtime LSP 設定
│   └── lua_ls.lua         # 各サーバ設定は `lsp/<name>.lua` に return table で書く
└── lua/
    ├── config/
    │   ├── options.lua    # vim.o / vim.opt のグローバル設定 (キーマップは書かない)
    │   ├── providers.lua  # vim.g.loaded_*_provider の無効化
    │   ├── plugins.lua    # vim.pack.add 集約 + PackChanged フック + plugins.* require
    │   ├── lsp.lua        # vim.lsp.enable + 診断設定 + LspAttach バッファキー
    │   └── keymaps.lua    # 全キーマップ集約 (汎用 + プラグイン用)
    └── plugins/
        ├── colorscheme.lua  # catppuccin (mocha)
        ├── icons.lua         # mini.icons
        ├── snacks.lua        # folke/snacks.nvim
        ├── treesitter.lua    # nvim-treesitter (パーサ install + ハイライト起動)
        └── sidekick.lua      # folke/sidekick.nvim (AI CLI 統合)
```

**分離方針**:
- `options.lua` には `vim.o.*` / `vim.opt.*` のみ書く。キーマップは混ぜない (ユーザーの明示要望)
- `lua/plugins/<name>.lua` には `setup()` 等の **設定のみ**。キーマップは書かない
- キーマップは `lua/config/keymaps.lua` に集約。プラグイン依存のキーマップは lazy require でラップする
- `init.lua` は薄く保つ (leader + require だけ)

## init.lua の読み込み順 (重要)

```
1. vim.g.mapleader / maplocalleader  ← プラグインのキーマップ前に必須
2. config.options
3. config.providers
4. config.plugins        ← フック定義 → vim.pack.add → plugins.* setup
5. config.lsp            ← vim.lsp.enable は plugins より後・keymaps より前
6. config.keymaps        ← プラグインがロード済みであることが前提
```

`config.plugins` 内での setup 呼び出し順:
1. `colorscheme` (他プラグインのハイライトに影響するため最初)
2. `icons` (snacks 等が利用するため snacks より前)
3. `snacks` (`quickfile` を早めに発火)
4. `treesitter`
5. `sidekick`

## キーマップ規約

LazyVim 流のカテゴリ分けを採用:

| プレフィックス | 用途 |
| --- | --- |
| `<leader>f*` | find (files / buffers / recent / help / keymaps) |
| `<leader>s*` | search (grep 系) |
| `<leader>g*` | git (将来) |
| `<leader>l*` | LSP (definition / format / 診断 / workspace symbol 等) |
| `<leader>a*` | AI (sidekick.nvim) |
| `<leader>b*` | buffer |
| `<leader>w` / `<leader>q` / `<leader>Q` | save / close / quit-all |

Visual mode で利用するものは `map({"n", "v"}, ...)` で両モード登録するのが基本。AI 系は selection を送るためのキーは visual のみ。

## プラグインを追加する手順

1. `lua/config/plugins.lua` の `vim.pack.add({...})` テーブルに追加
   - 必要に応じて `name = "..."` (リポジトリ名と表示名がずれる場合)
   - `version = vim.version.range("X.x")` で semver 固定 (推奨)
2. `lua/plugins/<name>.lua` を新規作成し `setup()` 呼び出しのみ書く
3. `lua/config/plugins.lua` 末尾に `require("plugins.<name>")` を追加 (依存関係を考慮した順序で)
4. キーマップが必要なら `lua/config/keymaps.lua` の該当カテゴリに追加 (lazy require ヘルパでラップ)
5. ロックファイル `nvim-pack-lock.json` を git にコミット
6. ヘッドレスで動作確認

## 既知の制約とハマりどころ

- **nvim-treesitter は public archive (2026-04-03)**: main ブランチを使い、tree-sitter CLI が必須。CLI は **mise でインストール** する (`brew` ではなく)
- **sidekick.nvim は v2.x を使う**: v1.x には tmux 内で `select` を呼ぶと `duplicate session id` で落ちるバグがある (v2 で `feat(cli): deduplicate cli tool sessions` 修正)
- **mini.icons は web-devicons mock を必ず呼ぶ**: `MiniIcons.mock_nvim_web_devicons()` で旧プラグイン互換確保。lualine / neo-tree 等を将来追加した時の保険
- **PackChanged フックは vim.pack.add() より前に定義**: 初回 bootstrap でフック登録が間に合わないため

## 動作確認の慣習

ヘッドレス起動でテストするのが基本:

```bash
# 起動エラーチェック
nvim --headless -c 'qa' 2>&1

# 特定ファイルを開いてプラグインの状態を確認
nvim --headless <file> -c 'lua print(...)' -c 'qa' 2>&1 | tail -5

# 単一プラグインのみ更新
nvim --headless -c 'lua vim.pack.update({ "<name>" }, { force = true })' -c 'qa'
```

`vim.pack.update` を `force = true` で全体に対して呼ぶのは権限上ブロックされる。**個別プラグイン名を必ず指定**する。

## 関連メモリ (Claude Code 専用)

- 開発系 CLI ツールは **mise** でインストール (brew ではない)
- AI 支援は **CLI ベース + jj コミット単位** でのやり直し前提 (diff hunk accept/reject は使わない)

詳細は `~/.config/claude/projects/-Users-s-ikezawa--config-nvim/memory/` 配下を参照。

---

# vim.pack ベストプラクティス (調査ノート)


## 前提

- Neovim 0.12.0 は 2026-03-29 リリース。**`vim-plug` ではなく `vim.pack`** が公式組み込みプラグインマネージャとして追加された
- `:help vim.pack` で公式ドキュメント参照可。まだ "experimental" 表記だが日常使用に耐える品質
- Git リポジトリのみ対応 (LuaRocks 等は非対応)

## 設計思想

`vim.pack` は **フレームワークではなくライブラリ**。`lazy.nvim` のような宣言的スペックや lazy-loading 機構は内蔵されていない。`vim.pack.add()` は呼ばれた瞬間に Git clone と読み込みを実行する単純な関数として動作する。

## 推奨構成パターン

### パターン A: 単一の `vim.pack.add()` に集約 (公式推奨・最もロバスト)

```lua
-- 1) フックは vim.pack.add() より前に定義する
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    if ev.data.spec.name == "nvim-treesitter" and ev.data.kind ~= "delete" then
      if not ev.data.active then vim.cmd.packadd("nvim-treesitter") end
      vim.cmd("TSUpdate")
    end
  end,
})

-- 2) すべてのプラグインを 1 回でまとめて宣言
vim.pack.add({
  "https://github.com/nvim-mini/mini.nvim",
  { src = "https://github.com/neovim/nvim-lspconfig", version = "stable" },
  { src = "https://github.com/nvim-mini/mini.nvim", version = vim.version.range("2.x") },
  "https://github.com/nvim-treesitter/nvim-treesitter",
})

-- 3) この後で各プラグインの setup を呼ぶ
require("mini.basics").setup()
```

**利点**: ロックファイルからの bootstrap 時にフックが正しく走る。トラブルシュート時もプラグイン宣言が 1 箇所にまとまる。

### パターン B: `plugin/<name>.lua` に分割

Neovim が `plugin/` 配下を **アルファベット順** に自動 source する仕様を活かす:

```
~/.config/nvim/
├── init.lua
├── nvim-pack-lock.json     ← git 管理に入れる
├── lua/
│   └── config/
│       ├── options.lua
│       └── providers.lua
└── plugin/
    ├── 00-colorscheme.lua  ← 数字 prefix で読み込み順を制御
    ├── treesitter.lua
    ├── lspconfig.lua
    └── lualine.lua
```

各ファイルに `vim.pack.add({...})` と `setup` を併記する。**注意**: フックだけは `init.lua` に集約しないと bootstrap 時に取りこぼす可能性がある。

### 進化経路

- プラグインが少ない初期: パターン A (単一ファイル集約)
- プラグインが 10 個を超えてきたら: パターン B (`plugin/` 配下に分割)

## バージョン固定の書き方

```lua
vim.pack.add({
  -- デフォルトブランチを追従 (普通のユースケース)
  "https://github.com/user/repo",

  -- semver レンジで固定 (推奨: 破壊的変更を回避)
  { src = "https://github.com/nvim-mini/mini.nvim",
    version = vim.version.range("2.x") },  -- >= 2.0.0, < 3.0.0

  -- 特定ブランチに固定
  { src = "https://github.com/neovim/nvim-lspconfig", version = "stable" },

  -- 最新の semver タグを常に追う
  { src = "https://github.com/user/repo", version = vim.version.range("*") },

  -- ディレクトリ名を変える
  { src = "https://github.com/neovim/nvim-lspconfig", name = "lspconfig" },
})
```

## ロックファイル (`nvim-pack-lock.json`)

- 配置: `$XDG_CONFIG_HOME/nvim/nvim-pack-lock.json` (= `~/.config/nvim/`)
- **git にコミットする** → 別マシンで全く同じバージョンが復元される
- **手動編集禁止**
- 初回 `vim.pack.add()` 呼び出し時にロックファイルから bootstrap される
- 状態確認: `:checkhealth vim.pack`

## アップデート / 削除ワークフロー

```vim
:lua vim.pack.update()                              " 確認バッファ付きで全更新
:lua vim.pack.update({ 'mini.nvim' })               " 個別更新
:lua vim.pack.update(nil, { force = true })         " 確認スキップ
:lua vim.pack.update(nil, { target = 'lockfile' })  " ロックファイルの状態に戻す
:lua vim.pack.update(nil, { offline = true })       " fetch せず差分プレビュー

:lua vim.pack.del({ 'plugin-name' })                " 削除 (config 側からの削除も忘れずに)
```

確認バッファ:
- `[[` / `]]` でプラグイン間ジャンプ
- LSP hover で詳細表示
- code action で個別の skip/delete

ログ: `nvim-pack.log` (log standard path)

## ビルドフック (`build` 相当)

`lazy.nvim` の `build = "make"` / `build = ":TSUpdate"` 相当は `PackChanged` autocmd で実装:

```lua
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    -- ev.data.spec, ev.data.kind ('install'/'update'/'delete'),
    -- ev.data.path, ev.data.active が利用可能
    if ev.data.spec.name == "telescope-fzf-native.nvim"
       and ev.data.kind ~= "delete" then
      vim.system({ "make" }, { cwd = ev.data.path })
    end
  end,
})
```

## 遅延読み込みが必要な場合

`vim.pack` には lazy-loading が無いが、必要なら以下で代替:

```lua
-- (a) vim.schedule で起動後に遅延
vim.schedule(function()
  vim.pack.add({ "https://github.com/nvim-mini/mini.cmdline" })
  require("mini.cmdline").setup()
end)

-- (b) autocmd でイベント駆動
vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = function()
    vim.pack.add({ "https://github.com/nvim-mini/mini.completion" })
    require("mini.completion").setup()
  end,
})

-- (c) load フックで installed-but-not-loaded にする
vim.pack.add({ "https://github.com/some/plugin" }, { load = function() end })
-- 後で必要になったら :packadd some-plugin
```

公式ガイドは **「過度な lazy loading は認知負荷が高くなる」** と警告。Neovim 0.12 は LSP 周りが大幅高速化されているため、ほとんどのケースで eager load で十分快適。

## 既知の制約と注意点

- Git リポジトリのみ対応 (LuaRocks や zip 配布のプラグインは対象外)
- 手動でプラグインディレクトリを編集しない (`~/.local/share/nvim/site/pack/core/opt/`)
- インストールフックは `vim.pack.add()` より前に定義する (bootstrap 時に間に合わせるため)
- まだ "experimental" 表記なので、API が将来微調整される可能性あり
- ロックファイルを手で削除/編集すると整合性が崩れる

## 他マネージャからの移行ヒント

| 移行元 | キーポイント |
| --- | --- |
| lazy.nvim | `lua/plugins/*.lua` の spec を `vim.pack.add()` 呼び出しに置き換え。`build` → `PackChanged` autocmd。lazy-load は基本捨てる |
| mini.deps | `source` → `src`, `checkout` → `version`, hook を autocmd に変換、`site/pack/deps` を削除 |
| vim-plug / packer | プラグインリストを `vim.pack.add()` に書き換え。各々の `setup` 呼び出しはそのまま使える |

## 設定対象の判断基準

- 新規ユーザー / 設定をシンプルに保ちたい: `vim.pack` で十分
- プラグイン 100+ 規模で起動 50ms 以下を狙う: 当面 `lazy.nvim` のほうが機能豊富
- 学習コストを抑えて公式機能を使いたい: `vim.pack`

## 参考資料

- [A Guide to vim.pack (Evgeni Chasnovski)](https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack)
- [Neovim 0.12 公式ドキュメント (`:help vim.pack`)](https://neovim.io/doc/user/pack/)
- [From lazy.nvim to vim.pack (Fredrik Averpil)](https://fredrikaverpil.github.io/blog/2026/04/15/from-lazy.nvim-to-vim.pack/)
- [Migrating to Neovim's new built-in plugin manager (bower.sh)](https://bower.sh/nvim-builtin-plugin-mgr)
- [Refreshing your Neovim config for 0.12.0 (justinhj)](http://justinhj.github.io/2026/04/06/refreshing-your-neovim-config-for-0-12-0.html)
- [What's New in Neovim 0.12 (Adib Hanna)](https://dotfiles.substack.com/p/whats-new-in-neovim-012)
- [Neovim 0.12 release news (AlternativeTo)](https://alternativeto.net/news/2026/3/neovim-0-12-has-been-released-with-a-built-in-plugin-manager-major-lsp-and-ui-upgrades/)

---

# LSP ネイティブ設定 (Neovim 0.11+ / 0.12) 調査ノート

## 前提と全体像

Neovim 0.11 で `vim.lsp.config()` / `vim.lsp.enable()` API と `lsp/<name>.lua` の
runtime 自動読み込みが追加され、**`nvim-lspconfig` プラグイン無しでネイティブに
LSP を構成できる** ようになった。0.12 でも同じ API が継続。

本リポジトリではプラグイン非依存のネイティブ方式を採用している。

## 設計方針

| 役割 | 場所 |
| --- | --- |
| サーバ別の設定 (cmd/filetypes/root_markers/settings) | `lsp/<server>.lua` (return table) |
| 有効化・診断設定・LspAttach キーマップ | `lua/config/lsp.lua` |
| バイナリのインストール | **mise** (brew ではない) |

`lsp/<name>.lua` は `runtimepath` 上のディレクトリから自動で読まれるので、
`vim.lsp.enable('<name>')` を呼ぶだけで設定が適用される。`vim.lsp.config()` を
明示的に呼ぶ必要は無い (ファイル方式で十分)。

## サーバ追加手順

1. `lsp/<server>.lua` を作成し設定 table を `return` する
   - `cmd` / `filetypes` / `root_markers` / `settings` を指定
   - `root_markers` の **入れ子テーブルは同じ優先度** を意味する
     (例: `{ ".luarc.json", ".luarc.jsonc" }` はどちらか見つかれば OK)
2. `lua/config/lsp.lua` の `vim.lsp.enable({...})` リストに名前を追加
3. バイナリは mise でインストール: `mise use -g <tool>@latest`
4. ヘッドレスで attach 確認:
   ```bash
   nvim --headless <file> \
     -c 'lua vim.defer_fn(function()
       print(#vim.lsp.get_clients({ bufnr = 0 }))
       vim.cmd("qa")
     end, 3000)' 2>&1
   ```
5. 実 nvim 内では `:checkhealth vim.lsp` / `:lsp` (= `:LspInfo` 相当) で確認

## Neovim 0.11+ のデフォルトキーマップ (LSP attach 時)

**重要**: 以下は LSP attach で自動的に有効化されるので **再定義しない**。

| キー | 動作 |
| --- | --- |
| `K` | `vim.lsp.buf.hover()` (`keywordprg` が default の場合のみ) |
| `gra` | `vim.lsp.buf.code_action()` (Normal + Visual) |
| `gri` | `vim.lsp.buf.implementation()` |
| `grn` | `vim.lsp.buf.rename()` |
| `grr` | `vim.lsp.buf.references()` |
| `grt` | `vim.lsp.buf.type_definition()` |
| `grx` | `vim.lsp.codelens.run()` |
| `gO` | `vim.lsp.buf.document_symbol()` (バッファ内のみ) |
| `<C-s>` (insert) | `vim.lsp.buf.signature_help()` |
| `[d` / `]d` | 診断間移動 (`vim.diagnostic`) |
| `gx` | `textDocument/documentLink` も処理 |
| `gq` | `vim.lsp.formatexpr()` でフォーマット |
| `CTRL-]` 等 | `vim.lsp.tagfunc()` で go-to-definition |

omnifunc も `vim.lsp.omnifunc()` に設定されるので `<C-x><C-o>` で補完可能。

`<leader>l*` 系には **重複しない補助キー** だけ追加する規約 (例: `<leader>lf`
フォーマット、`<leader>le` 診断 float 表示、`<leader>lS` ワークスペースシンボル)。

## デフォルトで有効な機能 / 自分で有効化する機能

LSP attach で自動 ON:
- 診断 (`vim.diagnostic`)
- `workspace/didChangeWatchedFiles` (Linux 以外)
- ドキュメントカラー

明示的な ON が必要 (`:help` 参照):
- `lsp-codelens` / `lsp-linked_editing_range` / `lsp-inlay_hint` /
  `lsp-inline_completion`

## 既知の落とし穴

- **`~/.config/nvim` は git 管理外なので `.git` だけでは root_dir を検出できない**。
  `lsp/lua_ls.lua` の `root_markers` には `init.lua` と `nvim-pack-lock.json` を
  含めて nvim 設定ディレクトリ自体を root として認識させている
- `vim.lsp.config()` は **マージ先**。`vim.lsp.config('*', {...})` で全サーバ共通の
  capabilities を上書きできる
- `lsp/` ディレクトリは **複数の runtimepath** から読まれる。プラグイン側が同名の
  `lsp/<server>.lua` を提供している場合、`vim.lsp.config()` でローカル上書きが必要
- `lsp/<server>.lua` のファイル名 (`.lua` 抜き) と `vim.lsp.enable()` に渡す名前は
  一致させる必要がある (例: `lsp/lua_ls.lua` ↔ `vim.lsp.enable('lua_ls')`)

## lua_ls 固有の事情

- `settings.Lua.workspace.library` に `vim.env.VIMRUNTIME` と `${3rd}/luv/library`
  を入れることで `vim` グローバルと `vim.uv` の型補完が効く
- `diagnostics.globals = { "vim" }` を入れないと `vim` 未定義警告が出る
- `checkThirdParty = false` で「サードパーティライブラリ検出」のダイアログを抑止
- バイナリは mise: `mise use -g lua-language-server@latest`
  実体は `~/.local/share/mise/installs/lua-language-server/<ver>/bin/lua-language-server`、
  shim 経由で nvim の `vim.fn.exepath()` から見える

## 参考資料

- [`:help lsp-quickstart`](https://neovim.io/doc/user/lsp.html#lsp-quickstart) (本体ヘルプ)
- [`:help lsp-defaults`](https://neovim.io/doc/user/lsp.html#lsp-defaults) (デフォルトキーマップ一覧)
- [Native LSP in Neovim 0.12 (.dotfiles)](https://dotfiles.substack.com/p/native-lsp-in-neovim-012)
- [neovim/nvim-lspconfig (各サーバ設定の参照実装)](https://github.com/neovim/nvim-lspconfig/tree/master/lsp)
- [How to use new vim.lsp.config approach to load LSP on demand? (#33978)](https://github.com/neovim/neovim/discussions/33978)
