# Neovim Config Notes

このディレクトリは Neovim 0.12.2 の個人設定です。Claude Code がこの設定を編集する際の参照情報をまとめます。

調査日: 2026-04-25

# このリポジトリでの設定スタイル

## ファイル構成と役割

```
~/.config/nvim/
├── init.lua              # leader 設定 + 各 config モジュールの require のみ
├── nvim-pack-lock.json   # vim.pack のロックファイル (git 管理対象)
└── lua/
    ├── config/
    │   ├── options.lua    # vim.o / vim.opt のグローバル設定 (キーマップは書かない)
    │   ├── providers.lua  # vim.g.loaded_*_provider の無効化
    │   ├── plugins.lua    # vim.pack.add 集約 + PackChanged フック + plugins.* require
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
5. config.keymaps        ← プラグインがロード済みであることが前提
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
| `<leader>l*` | LSP (将来) |
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
