return {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = {
          "lua/?.lua",
          "lua/?/init.lua",
        },
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        checkThirdParty = false,
        library = (function()
          local lib = {
            vim.env.VIMRUNTIME,
            "${3rd}/luv/library",
          }
          local pack_dir = vim.fn.stdpath("data") .. "/site/pack"
          for _, path in ipairs(vim.fn.glob(pack_dir .. "/*/opt/*", false, true)) do
            lib[#lib + 1] = path
          end
          return lib
        end)(),
      },
    },
  },
}
