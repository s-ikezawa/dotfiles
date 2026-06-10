-- ~/.config/nvim/lsp/lua_ls.lua
-- lua_ls (lua-language-server) のサーバー定義。
-- runtimepath 上の lsp/<name>.lua は、設定テーブルを return すると
-- vim.lsp.enable("<name>") 時に自動的にそのサーバー定義として使われる
-- (Neovim 0.11+ の標準的な置き場所)。
-- 本体は手動 (mise / brew 等) で導入し PATH を通す前提。

return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  -- プロジェクトルートの判定材料。見つからなければ単一ファイルモードで起動する
  root_markers = {
    ".luarc.json", ".luarc.jsonc",
    ".stylua.toml", "stylua.toml",
    ".luacheckrc",
    ".git",
  },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" }, -- Neovim の Lua は LuaJIT
      diagnostics = {
        globals = { "vim", "Snacks" }, -- vim / Snacks グローバルを未定義警告から除外
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true), -- Neovim API を補完対象に含める
        checkThirdParty = false,                            -- サードパーティ確認ダイアログを抑制
      },
      telemetry = { enable = false }, -- テレメトリ送信を無効化
    },
  },
}
