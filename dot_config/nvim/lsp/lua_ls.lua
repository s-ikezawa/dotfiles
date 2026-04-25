-- =============================================================================
-- lua-language-server (lua_ls)
-- =============================================================================
-- Neovim 0.12 のネイティブ runtime パス読み込み機構で利用される設定ファイル。
-- このファイルは `lsp/<name>.lua` という配置だと vim.lsp.enable('<name>') で
-- 自動的に読まれる (lspconfig プラグイン不要)。
--
-- バイナリは mise でインストール:
--   mise use -g lua-language-server@latest
-- =============================================================================

return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  -- Files that share a root_marker reuse the same LSP server connection.
  -- 内側のテーブルは同じ優先度を意味する (どれが見つかっても OK)。
  root_markers = {
    { ".luarc.json", ".luarc.jsonc" },
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    -- Neovim 設定ディレクトリ (git 管理外でも root として認識させる)
    "init.lua",
    "nvim-pack-lock.json",
    ".git",
  },
  settings = {
    Lua = {
      runtime = {
        -- Neovim 本体の Lua は LuaJIT
        version = "LuaJIT",
      },
      workspace = {
        -- サードパーティライブラリの検出ダイアログを抑止
        checkThirdParty = false,
        -- Neovim ランタイム (vim.* API) と libuv (vim.uv) の型定義を読み込ませる
        library = {
          vim.env.VIMRUNTIME,
          "${3rd}/luv/library",
        },
      },
      diagnostics = {
        -- `vim` グローバルを未定義扱いにしない
        globals = { "vim" },
      },
      telemetry = { enable = false },
      -- vim.* の補完で hover シグネチャを優先表示する
      hint = { enable = true },
    },
  },
}
