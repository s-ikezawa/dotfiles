return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  dependencies = {
    { "nvim-treesitter/nvim-treesitter" }
  },
  config = function()
    -- プラグインのセットアップ
    require("nvim-treesitter-textobjects").setup({
      select = {
        -- 自動的に次のテキストオブジェクトへジャンプ
        lookahead = true,
        -- テキストオブジェクトの選択モード
        selection_modes = {
          ["@parameter.outer"] = "v", -- 文字単位
          ["@function.outer"] = "V",  -- 行単位
          ["@class.outer"] = "V",     -- 行単位
        },
        -- 周囲の空白を含める
        include_surrounding_whitespace = true,
      },
      move = {
        -- ジャンプリストに追加
        set_jumps = true,
      },
    })

    -- テキストオブジェクトの選択キーマップ
    local select = require("nvim-treesitter-textobjects.select")

    -- 関数のテキストオブジェクト（メソッド含む）
    vim.keymap.set({ "x", "o" }, "af", function()
      select.select_textobject("@function.outer", "textobjects")
    end, { desc = "関数全体を選択" })
    vim.keymap.set({ "x", "o" }, "if", function()
      select.select_textobject("@function.inner", "textobjects")
    end, { desc = "関数の中身を選択" })

    -- クラスのテキストオブジェクト
    vim.keymap.set({ "x", "o" }, "ac", function()
      select.select_textobject("@class.outer", "textobjects")
    end, { desc = "クラス全体を選択" })
    vim.keymap.set({ "x", "o" }, "ic", function()
      select.select_textobject("@class.inner", "textobjects")
    end, { desc = "クラスの中身を選択" })

    -- パラメータのテキストオブジェクト
    vim.keymap.set({ "x", "o" }, "aa", function()
      select.select_textobject("@parameter.outer", "textobjects")
    end, { desc = "パラメータ全体を選択" })
    vim.keymap.set({ "x", "o" }, "ia", function()
      select.select_textobject("@parameter.inner", "textobjects")
    end, { desc = "パラメータの中身を選択" })

    -- コメントのテキストオブジェクト
    vim.keymap.set({ "x", "o" }, "a/", function()
      select.select_textobject("@comment.outer", "textobjects")
    end, { desc = "コメント全体を選択" })

    -- ブロックのテキストオブジェクト
    vim.keymap.set({ "x", "o" }, "ab", function()
      select.select_textobject("@block.outer", "textobjects")
    end, { desc = "ブロック全体を選択" })
    vim.keymap.set({ "x", "o" }, "ib", function()
      select.select_textobject("@block.inner", "textobjects")
    end, { desc = "ブロックの中身を選択" })

    -- 条件文のテキストオブジェクト
    vim.keymap.set({ "x", "o" }, "ai", function()
      select.select_textobject("@conditional.outer", "textobjects")
    end, { desc = "条件文全体を選択" })
    vim.keymap.set({ "x", "o" }, "ii", function()
      select.select_textobject("@conditional.inner", "textobjects")
    end, { desc = "条件文の中身を選択" })

    -- ループのテキストオブジェクト
    vim.keymap.set({ "x", "o" }, "al", function()
      select.select_textobject("@loop.outer", "textobjects")
    end, { desc = "ループ全体を選択" })
    vim.keymap.set({ "x", "o" }, "il", function()
      select.select_textobject("@loop.inner", "textobjects")
    end, { desc = "ループの中身を選択" })

    -- 関数呼び出しのテキストオブジェクト
    vim.keymap.set({ "x", "o" }, "aF", function()
      select.select_textobject("@call.outer", "textobjects")
    end, { desc = "関数呼び出し全体を選択" })
    vim.keymap.set({ "x", "o" }, "iF", function()
      select.select_textobject("@call.inner", "textobjects")
    end, { desc = "関数呼び出しの引数を選択" })

    -- テキストオブジェクト間の移動キーマップ
    local move = require("nvim-treesitter-textobjects.move")

    -- 次の開始位置へ移動
    vim.keymap.set({ "n", "x", "o" }, "]f", function()
      move.goto_next_start("@function.outer")
    end, { desc = "次の関数の開始へ" })
    vim.keymap.set({ "n", "x", "o" }, "]c", function()
      move.goto_next_start("@class.outer")
    end, { desc = "次のクラスの開始へ" })
    vim.keymap.set({ "n", "x", "o" }, "]a", function()
      move.goto_next_start("@parameter.inner")
    end, { desc = "次のパラメータへ" })
    vim.keymap.set({ "n", "x", "o" }, "]b", function()
      move.goto_next_start("@block.outer")
    end, { desc = "次のブロックへ" })

    -- 次の終了位置へ移動
    vim.keymap.set({ "n", "x", "o" }, "]F", function()
      move.goto_next_end("@function.outer")
    end, { desc = "次の関数の終了へ" })
    vim.keymap.set({ "n", "x", "o" }, "]C", function()
      move.goto_next_end("@class.outer")
    end, { desc = "次のクラスの終了へ" })
    vim.keymap.set({ "n", "x", "o" }, "]A", function()
      move.goto_next_end("@parameter.inner")
    end, { desc = "次のパラメータの終了へ" })
    vim.keymap.set({ "n", "x", "o" }, "]B", function()
      move.goto_next_end("@block.outer")
    end, { desc = "次のブロックの終了へ" })

    -- 前の開始位置へ移動
    vim.keymap.set({ "n", "x", "o" }, "[f", function()
      move.goto_previous_start("@function.outer")
    end, { desc = "前の関数の開始へ" })
    vim.keymap.set({ "n", "x", "o" }, "[c", function()
      move.goto_previous_start("@class.outer")
    end, { desc = "前のクラスの開始へ" })
    vim.keymap.set({ "n", "x", "o" }, "[a", function()
      move.goto_previous_start("@parameter.inner")
    end, { desc = "前のパラメータへ" })
    vim.keymap.set({ "n", "x", "o" }, "[b", function()
      move.goto_previous_start("@block.outer")
    end, { desc = "前のブロックへ" })

    -- 前の終了位置へ移動
    vim.keymap.set({ "n", "x", "o" }, "[F", function()
      move.goto_previous_end("@function.outer")
    end, { desc = "前の関数の終了へ" })
    vim.keymap.set({ "n", "x", "o" }, "[C", function()
      move.goto_previous_end("@class.outer")
    end, { desc = "前のクラスの終了へ" })
    vim.keymap.set({ "n", "x", "o" }, "[A", function()
      move.goto_previous_end("@parameter.inner")
    end, { desc = "前のパラメータの終了へ" })
    vim.keymap.set({ "n", "x", "o" }, "[B", function()
      move.goto_previous_end("@block.outer")
    end, { desc = "前のブロックの終了へ" })

    -- テキストオブジェクトの入れ替えキーマップ
    local swap = require("nvim-treesitter-textobjects.swap")

    vim.keymap.set("n", "<leader>xp", function()
      swap.swap_next("@parameter.inner")
    end, { desc = "次のパラメータと入れ替え" })
    vim.keymap.set("n", "<leader>xf", function()
      swap.swap_next("@function.outer")
    end, { desc = "次の関数と入れ替え" })
    vim.keymap.set("n", "<leader>xP", function()
      swap.swap_previous("@parameter.inner")
    end, { desc = "前のパラメータと入れ替え" })
    vim.keymap.set("n", "<leader>xF", function()
      swap.swap_previous("@function.outer")
    end, { desc = "前の関数と入れ替え" })
  end
}
