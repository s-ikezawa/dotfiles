return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  config = function()
    require("lualine").setup({
      options = {
        theme = "catppuccin",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { 
          -- LSPクライアント状態表示
          {
            function()
              local bufnr = vim.api.nvim_get_current_buf()
              local clients = vim.lsp.get_clients({ bufnr = bufnr })
              
              if not clients or #clients == 0 then
                return "󰅖 No LSP"
              end
              
              local client_names = {}
              for _, client in ipairs(clients) do
                if client and client.name then
                  table.insert(client_names, client.name)
                end
              end
              
              if #client_names == 0 then
                return "󰅖 No LSP"
              end
              
              return " " .. table.concat(client_names, ", ")
            end,
            color = function()
              local bufnr = vim.api.nvim_get_current_buf()
              local clients = vim.lsp.get_clients({ bufnr = bufnr })
              if not clients or #clients == 0 then
                return { fg = "#f38ba8" } -- catppuccin red
              else
                return { fg = "#a6e3a1" } -- catppuccin green
              end
            end,
          },
          "encoding", 
          "fileformat", 
          "filetype" 
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    })
  end,
}
