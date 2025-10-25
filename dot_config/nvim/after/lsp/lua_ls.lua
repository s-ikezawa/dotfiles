---@type vim.lsp.Config
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
    '.git',
  },
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        pathStrict = true,
        path = {
          "lua/?.lua",
          "lua/?/init.lua",
        },
      },
      workspace = {
        checkThirdParty = false,
        library = vim.list_extend(
          {
            vim.env.VIMRUNTIME .. "/lua",
            "${3rd}/luv/library",
            "${3rd}/busted/library",
            "${3rd}/luassert/library",
            -- sidekick プラグインのパスを明示的に追加
            vim.fn.stdpath("data") .. "/lazy/sidekick.nvim/lua",
          },
          -- runtimepath にある全てのプラグインの lua ディレクトリを追加
          vim.api.nvim_get_runtime_file("lua", true)
        ),
      },
    },
  },
}
