return {
  settings = {
    Lua = {
      workspace = {
        library = vim.list_extend(
          {
            vim.env.VIMRUNTIME .. '/lua',
            "${3rd}/luv/library",
            "${3rd}/busted/library",
            "${3rd}/luassert/library"
          },
          vim.api.nvim_get_runtime_file("lua", true)
        )
      }
    }
  }
}
