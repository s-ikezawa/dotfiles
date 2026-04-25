-- =============================================================================
-- Plugins (vim.pack)
-- =============================================================================
-- Neovim 0.12 から組み込みの vim.pack でプラグインを管理する。
-- 公式推奨の "単一 vim.pack.add() に集約 + フック前置" パターンを採用。
-- 詳細は CLAUDE.md を参照。
-- =============================================================================

-- ----- インストール/アップデートフック ---------------------------------------
-- フックは vim.pack.add() より前に定義しないと、ロックファイルからの bootstrap 時に
-- 取りこぼす可能性があるため、必ず先に登録する。
vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("user.pack.hooks", { clear = true }),
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind -- 'install' | 'update' | 'delete'

    -- nvim-treesitter: プラグイン更新時にパーサも合わせて更新する
    if name == "nvim-treesitter" and kind ~= "delete" then
      if not ev.data.active then vim.cmd.packadd("nvim-treesitter") end
      pcall(function() require("nvim-treesitter").update() end)
    end
  end,
})

-- ----- プラグイン宣言 -------------------------------------------------------
vim.pack.add({
  -- ---------------------------------------------------------------------------
  -- nvim-treesitter (main ブランチ = Neovim 0.10+ 向けの新 API)
  --
  -- IMPORTANT: 2026-04-03 にこのリポジトリは public archive になった (read-only)。
  --
  -- アーカイブに至った経緯:
  --   - Neovim 0.10+ で Tree-sitter エンジン・ハイライト基盤・フォールド基盤が
  --     コアに統合済みとなり、本プラグインの責務は「パーサインストール」と
  --     「クエリ管理」に縮小していた
  --   - main ブランチへの破壊的アップグレード時のドラマもあり、メンテナのモチベーション
  --     維持が難しくなったため
  --
  -- 今後の議論 (進行中):
  --   - 残ったパーサ管理機能を Neovim 本体側に取り込む案が検討されている
  --     (nvim-lspconfig / vim.lsp.config のようなモジュラー方式での upstream 化)
  --   - 仮称 "nvim-treeconfig" のような形で再構成される可能性がある
  --   - コミュニティでは tree-sitter-manager.nvim などの軽量代替も登場
  --
  -- 当面の方針:
  --   - main ブランチは依然として動作する (公式 0.10+ API ベース)
  --   - 本体に upstream される機能が出てきたら段階的に移行する
  --
  -- 参照:
  --   - https://github.com/nvim-treesitter/nvim-treesitter (archived)
  --   - https://news.ycombinator.com/item?id=47636943
  --   - https://news.ycombinator.com/item?id=47644667
  -- ---------------------------------------------------------------------------
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },

  -- ---------------------------------------------------------------------------
  -- catppuccin/nvim: パステル調のカラースキーム
  --   - リポジトリ名が "nvim" のため、name を "catppuccin" に明示してディレクトリ名衝突を避ける
  --   - semver の安定版に固定 (1.x 系)
  -- ---------------------------------------------------------------------------
  {
    src = "https://github.com/catppuccin/nvim",
    name = "catppuccin",
    version = vim.version.range("1.x"),
  },

  -- ---------------------------------------------------------------------------
  -- nvim-mini/mini.icons: アイコンプロバイダ (Nerd Font ベース)
  --   - 2024-07 登場、2026 年時点の Neovim 界における事実上の新標準
  --   - キャッシュで高速、780+ filetype + vim.filetype.match() フォールバック
  --   - mock_nvim_web_devicons() で旧 nvim-web-devicons 前提プラグインとも互換
  --   - mini.nvim ファミリは 2025 年に組織を nvim-mini/* に移管
  --   - 表示には Nerd Font (Fira Code Nerd Font 等) がターミナルで必要
  -- ---------------------------------------------------------------------------
  {
    src = "https://github.com/nvim-mini/mini.icons",
    version = vim.version.range("0.x"),
  },

  -- ---------------------------------------------------------------------------
  -- folke/sidekick.nvim: AI CLI の統合ターミナル + Prompt Library
  --   - Claude Code / Gemini / Codex / Grok / Copilot CLI / Aider など多数の
  --     AI CLI を統一 UI でトグル・送信できる
  --   - API キーは不要、CLI 経由でサブスクリプション利用
  --   - NES (Next Edit Suggestions) は Copilot LSP + Copilot サブスクが必須なので
  --     ここでは無効化し、CLI 統合のみ使う
  --   - snacks.nvim と組み合わせるとピッカー UI が強化される (既に導入済み)
  -- ---------------------------------------------------------------------------
  {
    src = "https://github.com/folke/sidekick.nvim",
    -- v2.x で session dedup や mux 周りの修正が入っているため 2.x に固定
    version = vim.version.range("2.x"),
  },

  -- ---------------------------------------------------------------------------
  -- folke/snacks.nvim: オールインワンユーティリティ集
  --   - picker (Telescope 代替), bigfile, quickfile などを 1 プラグインで提供
  --   - 依存なし、起動高速、LazyVim 13 系で標準採用
  --   - quickfile は起動高速化のため早めに setup される必要があるが、
  --     vim.pack.add 直後に require("snacks").setup() を呼ぶ構成で十分間に合う
  -- ---------------------------------------------------------------------------
  {
    src = "https://github.com/folke/snacks.nvim",
    version = vim.version.range("2.x"),
  },

  -- ---------------------------------------------------------------------------
  -- folke/lazydev.nvim: Neovim 設定編集時に lua_ls の workspace.library を
  -- 必要なときだけ動的拡張する (neodev.nvim の後継)
  --   - 編集中バッファの require("X") を見て X のソースパスを library に追加
  --   - library.words パターンで「特定の単語が出現したら追加」も可能
  --     (MiniIcons / Snacks のようなプラグイン由来のグローバルを認識させる用途)
  --   - LspAttach フックで動くので vim.lsp.enable('lua_ls') より前に setup する
  -- ---------------------------------------------------------------------------
  {
    src = "https://github.com/folke/lazydev.nvim",
    version = vim.version.range("1.x"),
  },

  -- ---------------------------------------------------------------------------
  -- folke/which-key.nvim: prefix キー入力後に「次に押せるキー + 説明」を
  -- ポップアップ表示するキーマップガイド
  --   - vim.keymap.set の `desc` をそのまま辞書として活用できる
  --   - グループ名 (例: <leader>f = find) を登録して階層を可視化
  --   - snacks.picker の keymap 一覧にアイコンを供給する連携あり
  --   - snacks.toggle の ON/OFF 状態をポップアップに反映する連携あり
  -- ---------------------------------------------------------------------------
  {
    src = "https://github.com/folke/which-key.nvim",
    version = vim.version.range("3.x"),
  },

  -- ---------------------------------------------------------------------------
  -- MeanderingProgrammer/render-markdown.nvim: Markdown 装飾 (見出しアイコン /
  -- テーブル罫線 / checkbox / コードブロック装飾)
  --   - lukas-reineke/headlines.nvim の事実上の後継 (作者が推奨)
  --   - treesitter ベース、外部依存なし
  --   - 画像 / Mermaid のレンダリング自体は snacks.image 側で行う (役割分担)
  -- ---------------------------------------------------------------------------
  {
    src = "https://github.com/MeanderingProgrammer/render-markdown.nvim",
    version = vim.version.range("8.x"),
  },
})

-- ----- 各プラグインの設定 ---------------------------------------------------
-- カラースキームは他プラグインのハイライトに影響するため最初に読み込む
require("plugins.colorscheme")
-- アイコンプロバイダは他プラグイン (snacks 等) より前に setup する
require("plugins.icons")
-- snacks の quickfile は起動高速化用なので他プラグインより前に setup する
require("plugins.snacks")
require("plugins.treesitter")
require("plugins.sidekick")
-- lazydev は config.lsp の vim.lsp.enable('lua_ls') より前に setup する必要がある
require("plugins.lazydev")
-- which-key は config.keymaps より前に setup しておくとグループ登録のラグが無い
require("plugins.which-key")
-- markdown 装飾。treesitter のあとに setup される必要がある (依存)
require("plugins.render-markdown")
