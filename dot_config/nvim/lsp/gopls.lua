-- ~/.config/nvim/lsp/gopls.lua
-- gopls (Go 公式 language server) のサーバー定義。
-- runtimepath 上の lsp/<name>.lua は、設定テーブルを return すると
-- vim.lsp.enable("<name>") 時に自動的にそのサーバー定義として使われる
-- (Neovim 0.11+ の標準的な置き場所)。
-- 本体は手動 (mise / go install 等) で導入し PATH を通す前提。

return {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  -- Go モジュール / ワークスペースのルートを判定する
  root_markers = { "go.work", "go.mod", ".git" },
  settings = {
    gopls = {
      gofumpt = true, -- gofumpt 準拠の整形を有効化
      analyses = {
        unusedparams = true,  -- 未使用の関数引数を検出
        unusedwrite = true,   -- 無駄な書き込みを検出
        nilness = true,       -- nil 由来のバグを検出
        shadow = true,        -- 変数シャドーイングを検出
        useany = true,        -- interface{} より any を推奨
      },
      staticcheck = true, -- staticcheck 由来の追加診断を有効化
      hints = {           -- インレイヒント (型・引数名など)
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      usePlaceholders = true,          -- 補完時に引数プレースホルダを挿入
      completeUnimported = true,       -- 未 import パッケージも補完候補に含める
      semanticTokens = true,           -- セマンティックハイライトを有効化
      directoryFilters = { "-.git", "-node_modules" }, -- 巡回除外
    },
  },
}
