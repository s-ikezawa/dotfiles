-- Go の言語サーバー（gopls。mise で導入）の設定。

---@type vim.lsp.Config
return {
  cmd = { 'gopls' },                                  -- 起動するコマンド
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },  -- このファイルタイプのバッファで動かす
  root_markers = {                                    -- 上の階層へ探して、最初に見つかった場所をプロジェクトのルートにする
    'go.work',                                        -- 複数のモジュールをまとめたワークスペース
    'go.mod',                                         -- モジュール
    '.git',
  },
  settings = {
    gopls = {
      staticcheck = true,      -- staticcheck の検査も診断に出す
      usePlaceholders = true,  -- 関数を補完したとき、引数の名前を仮に入れる
      hints = {                -- インレイヒント（<leader>uh で表示を切り替える）
        assignVariableTypes = true,    -- := で作った変数の型
        compositeLiteralFields = true, -- 構造体リテラルのフィールド名
        functionTypeParameters = true, -- 型引数
        parameterNames = true,         -- 呼び出しの引数の名前
        rangeVariableTypes = true,     -- range の変数の型
      },
    },
  },
}
