return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-mini/mini.icons",
  },
  config = function()
    -- nvim-dev-iconsの代わりにmini.iconsを使う
    require("mini.icons").setup()
    require("mini.icons").mock_nvim_web_devicons()

    require("lualine").setup({
      sections = {
        lualine_x = {
          {
            function()
              local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
              if #buf_clients == 0 then
                return "No LSP"
              end

              local buf_client_names = {}
              for _, client in pairs(buf_clients) do
                table.insert(buf_client_names, client.name)
              end

              return "[" .. table.concat(buf_client_names, ", ") .. "]"
            end,
            icon = "",
            color = { gui = "bold" },
          },
          "encoding",
          "fileformat",
          "filetype",
        },
      },
    })
  end
}
