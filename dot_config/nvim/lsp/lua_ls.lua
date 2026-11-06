-- Lua の言語サーバー（lua-language-server。mise で導入）の設定。
-- Neovim は runtimepath の lsp/<名前>.lua を読み、vim.lsp.enable('<名前>') で有効にする。

---@type vim.lsp.Config
return {
  cmd = { 'lua-language-server' },                   -- 起動するコマンド
  filetypes = { 'lua' },                             -- このファイルタイプのバッファで動かす
  root_markers = {                                   -- 上の階層へ探して、最初に見つかった場所をプロジェクトのルートにする
    { '.luarc.json', '.luarc.jsonc' },               -- lua-language-server の設定ファイル
    { '.stylua.toml', 'stylua.toml' },               -- フォーマッタ（StyLua）の設定ファイル
    '.git',
  },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },              -- Neovim が使う Lua の処理系
      workspace = {
        checkThirdParty = false,                     -- サードパーティのライブラリ設定を勧める通知を出さない
        library = {                                  -- 型の情報を読む場所
          vim.env.VIMRUNTIME,                        -- Neovim 本体（vim.api などの補完と型チェック）
          '${3rd}/luv/library',                      -- vim.uv（libuv）の型
        },
      },
      diagnostics = { globals = { 'vim' } },         -- vim をグローバル変数として扱い、未定義の警告を出さない
      telemetry = { enable = false },                -- 使用状況を送らない
    },
  },
}
