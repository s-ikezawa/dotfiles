return {
  "nvim-mini/mini.ai",
  event = { "BufReadPost", "BufNewFile" },
  opts = function()
    local ai = require("mini.ai")
    return {
      n_lines = 500, -- 検索範囲を広げて大きな関数もカバーする
      custom_textobjects = {
        a = ai.gen_spec.argument({ separator = "," }),
        -- コードブロック(Treesitterの関数やクラスを統合)
        o = ai.gen_spec.treesitter({
          a = { "@function.outer", "@class.outer" },
          i = { "@function.inner", "@class.inner" },
        }),
        -- 関数呼び出し(mini.ai)
        f = ai.gen_spec.treesitter({
          a = "@call.outer",
          i = "@call.inner",
        }),
        -- コメントブロック
        c = ai.gen_spec.treesitter({
          a = "@comment.outer",
          i = "@comment.inner",
        }),
        -- 数値(digit): AIに定数を修正させるときに便利
        d = { "%d+" },
        -- 拡張された引数(引数、キー/値など)
        e = {
          { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
          '^().*()$',
        },
      },
      mappings = {
        arround_next = "an",
        inside_next = "in",
        arround_last = "al",
        inside_last = "il",
      },
    }
  end,
}
