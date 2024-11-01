return {
  "luukvbaal/statuscol.nvim",
  event = "VeryLazy",
  config = function()
    local builtin = require("statuscol.builtin")
    require("statuscol").setup({
      bt_ignore = {
        "terminal",
        "nofile",
        "ddu-ff",
        "ddu-ff-filter",
      },
      relculright = true,
      segments = {
        { -- Diagnosticの表示
          sign = {
            namespace = { "diagnostic/signs" },
            maxwidth = 2,
          },
        },
        { -- 行番号の表示
          text = { builtin.lnumfunc },
        },
        { -- gitsignsの表示
          sign = {
            namespace = { "gitsigns" },
            maxwidth = 1,
            colwidth = 1,
            wrap = true,
          },
        },
      },
    })
  end
}
