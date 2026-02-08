return {
  settings = {
    gopls = {
      -- NOTE: staticcheck は golangci-lint 経由で利用するため gopls 側では無効（重複回避）
      staticcheck = false,
      -- NOTE: gofumpt は conform.nvim 経由で利用するため gopls 側では無効（重複回避）
      gofumpt = false,

      -- ⭐⭐⭐⭐⭐ 追加の静的解析（デフォルトで無効なもののみ記載）
      analyses = {
        -- 変数シャドウイングの検出
        shadow = true,
        -- nil の冗長チェック・到達不能コードの検出
        nilness = true,
        -- 書き込み後に読まれないローカル変数への代入を検出
        unusedwrite = true,
        -- interface{} の代わりに any を使うよう提案
        useany = true,
      },

      -- ⭐⭐⭐⭐ 補完時に関数シグネチャのプレースホルダを挿入（デフォルト: false）
      usePlaceholders = true,

      -- ⭐⭐⭐⭐ inlay hints の表示内容（LspAttach で有効化済みだが表示項目はデフォルト全て false）
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },

      -- ⭐⭐⭐⭐ Code Lens（関数上部にテスト実行・依存関係操作等のアクションを表示）
      codelenses = {
        gc_details = true,
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
        test = true,
      },

      -- ⭐⭐⭐ セマンティックトークン（treesitter を補完してより正確なハイライト）
      semanticTokens = true,
    },
  },
}
