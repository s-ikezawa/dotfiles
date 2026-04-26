-- =============================================================================
-- nvim-treesitter
-- =============================================================================
-- Tree-sitter ベースの構文ハイライト/フォールドを有効化する。
--
-- IMPORTANT (2026-04-03 時点):
--   - nvim-treesitter リポジトリは public archive になった (read-only)
--   - Tree-sitter エンジン本体・ハイライト基盤・フォールド基盤は Neovim 0.10+ で
--     コアに統合済み。本プラグインの責務はパーサ/クエリ管理のみ
--   - パーサ管理機能を Neovim 本体に upstream する議論が進行中
--     (nvim-lspconfig のようなモジュラー方式での取り込みが有力)
--   - 当面は main ブランチ (新 API) を利用する。プラグインは動作するが新機能は
--     入らないため、上流の動向を見て移行を検討する
--
-- main ブランチでの新 API:
--   - 旧来の require("nvim-treesitter.configs").setup({...}) は廃止
--   - 代わりに require("nvim-treesitter").install({...}) でパーサを非同期インストール
--   - ハイライト起動はユーザー側で vim.treesitter.start() を呼ぶ
--   - インデント/フォールドは Neovim コアの API を使う
--
-- 必要なシステム依存:
--   - tree-sitter CLI (パーサのソースビルドに必須。旧 master ブランチと違い prebuilt は無い)
--   - C コンパイラ (cc, macOS なら Xcode CLT で OK)
--   インストール例: `mise use -g tree-sitter@latest`
-- =============================================================================

-- ----- インストールするパーサ ------------------------------------------------
-- 必要に応じて追加する。:lua require("nvim-treesitter").install({ "<lang>" }) で
-- 後から追加することも可能。:TSInstall <lang> も使える。
local parsers = {
  -- 設定/ドキュメント
  "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline",
  -- 文書フォーマット (snacks.image が画像 / 数式レンダリング時に利用)
  -- - latex : Markdown 内の LaTeX 数式ブロック
  -- - typst : Typst 形式
  -- norg は nvim-treesitter (archived) のレジストリに無い (nvim-neorg 側で管理)
  -- ため snacks.image の警告は出るが現時点では追加しない
  "latex", "typst",
  -- データフォーマット
  "json", "yaml", "toml",
  -- シェル
  "bash",
  -- Web フロントエンド
  "html", "css", "scss", "javascript", "typescript", "tsx",
  "svelte", "vue",
  -- バックエンド言語
  "go", "gomod", "gosum", "gowork",
  "rust",
  "python",
  "ruby",
  "java",
  "kotlin",
  "php",
  "c", "cpp",
  "c_sharp",
  "scala",
  "elixir",
  -- DB / API スキーマ
  "sql",
  "proto",
  "graphql",
  -- インフラ
  "dockerfile",
  "terraform", "hcl",
  -- Git
  "gitcommit", "gitignore", "git_rebase", "diff",
  -- その他
  "regex",
}

require("nvim-treesitter").install(parsers)

-- ----- ハイライト/フォールドの起動 -------------------------------------------
-- main ブランチでは setup() で全自動起動する仕組みは無く、ユーザーが FileType で
-- vim.treesitter.start() を呼ぶ構成になっている。
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user.treesitter", { clear = true }),
  callback = function(args)
    local buf = args.buf
    local ft = vim.bo[buf].filetype
    local lang = vim.treesitter.language.get_lang(ft)
    if not lang then return end

    -- ハイライト開始 (パーサ未インストール時は失敗するので pcall)
    if not pcall(vim.treesitter.start, buf, lang) then return end

    -- Tree-sitter ベースのフォールド (Neovim コアの機能)
    -- options.lua の foldlevelstart=99 と組み合わせて、ファイルを開いた直後は
    -- 全展開された状態になる (zc/zM などで手動で折りたためる)
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo.foldmethod = "expr"
  end,
})
