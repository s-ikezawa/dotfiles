return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  dependencies = {
    "nvim-treesitter/nvim-treesitter"
  },
  event = { "BufReadPost", "BufNewFile" },
  init = function()
    vim.g.no_plugin_maps = true
  end,
  opts = {
    textobjects = {
      select = {
        lookahead = true, -- カーソルが対象の上になくても、前方の対象を探して選択
      },
    },
  },
  config = function(_, opts)
    require("nvim-treesitter-textobjects").setup({opts})

    local function ts_select(query, query_group)
      return function()
        require("nvim-treesitter-textobjects.select").select_textobject(query, query_group)
      end
    end

    local mappings = {
      ["af"] = { query = "@function.outer", desc = "関数全体を選択" },
      ["if"] = { query = "@function.inner", desc = "関数内部を選択" },
      ["ac"] = { query = "@class.outer", desc = "クラス全体を選択" },
      ["ic"] = { query = "@class.inner", desc = "クラス内部を選択" },
      ["ai"] = { query = "@conditional.outer", desc = "if/switch文全体を選択" },
      ["ii"] = { query = "@conditional.inner", desc = "if/switch文内部を選択" },
      ["al"] = { query = "@loop.outer", desc = "ループ全体を選択" },
      ["il"] = { query = "@loop.inner", desc = "ループ内部を選択" },
      ["aa"] = { query = "@parameter.outer", desc = "引数全体を選択" },
      ["ia"] = { query = "@parameter.inner", desc = "引数内部を選択" },
    }

    for key, query in pairs(mappings) do
      vim.keymap.set({ "x", "o" }, key, ts_select(query.query, "textobjects"), { desc = query.desc })
    end
  end,
}
