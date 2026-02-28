vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
})

require("nvim-treesitter-textobjects").setup({
  select = {
    lookahead = true,
  },
  move = {
    set_jumps = true,
  },
})

local select = function(capture)
  return function()
    require("nvim-treesitter-textobjects.select").select_textobject(capture, "textobjects")
  end
end

local next_start = function(capture)
  return function()
    require("nvim-treesitter-textobjects.move").goto_next_start(capture, "textobjects")
  end
end

local next_end = function(capture)
  return function()
    require("nvim-treesitter-textobjects.move").goto_next_end(capture, "textobjects")
  end
end

local prev_start = function(capture)
  return function()
    require("nvim-treesitter-textobjects.move").goto_previous_start(capture, "textobjects")
  end
end

local prev_end = function(capture)
  return function()
    require("nvim-treesitter-textobjects.move").goto_previous_end(capture, "textobjects")
  end
end

-- Select
vim.keymap.set({ "x", "o" }, "af", select("@function.outer"), { desc = "関数の外側を選択" })
vim.keymap.set({ "x", "o" }, "if", select("@function.inner"), { desc = "関数の内側を選択" })
vim.keymap.set({ "x", "o" }, "ac", select("@class.outer"), { desc = "クラスの外側を選択" })
vim.keymap.set({ "x", "o" }, "ic", select("@class.inner"), { desc = "クラスの内側を選択" })
vim.keymap.set({ "x", "o" }, "aa", select("@parameter.outer"), { desc = "引数の外側を選択" })
vim.keymap.set({ "x", "o" }, "ia", select("@parameter.inner"), { desc = "引数の内側を選択" })
vim.keymap.set({ "x", "o" }, "al", select("@loop.outer"), { desc = "ループの外側を選択" })
vim.keymap.set({ "x", "o" }, "il", select("@loop.inner"), { desc = "ループの内側を選択" })
vim.keymap.set({ "x", "o" }, "ao", select("@conditional.outer"), { desc = "条件分岐の外側を選択" })
vim.keymap.set({ "x", "o" }, "io", select("@conditional.inner"), { desc = "条件分岐の内側を選択" })
vim.keymap.set({ "x", "o" }, "ar", select("@return.outer"), { desc = "return文の外側を選択" })
vim.keymap.set({ "x", "o" }, "ir", select("@return.inner"), { desc = "return文の内側を選択" })
vim.keymap.set({ "x", "o" }, "a=", select("@assignment.outer"), { desc = "代入の外側を選択" })
vim.keymap.set({ "x", "o" }, "i=", select("@assignment.inner"), { desc = "代入の内側を選択" })
vim.keymap.set({ "x", "o" }, "l=", select("@assignment.lhs"), { desc = "代入の左辺を選択" })
vim.keymap.set({ "x", "o" }, "r=", select("@assignment.rhs"), { desc = "代入の右辺を選択" })
vim.keymap.set({ "x", "o" }, "an", select("@number.inner"), { desc = "数値を選択" })

-- Move
vim.keymap.set({ "n", "x", "o" }, "]m", next_start("@function.outer"), { desc = "次の関数の先頭へ移動" })
vim.keymap.set({ "n", "x", "o" }, "]M", next_end("@function.outer"), { desc = "次の関数の末尾へ移動" })
vim.keymap.set({ "n", "x", "o" }, "[m", prev_start("@function.outer"), { desc = "前の関数の先頭へ移動" })
vim.keymap.set({ "n", "x", "o" }, "[M", prev_end("@function.outer"), { desc = "前の関数の末尾へ移動" })
vim.keymap.set({ "n", "x", "o" }, "]]", next_start("@class.outer"), { desc = "次のクラスの先頭へ移動" })
vim.keymap.set({ "n", "x", "o" }, "][", next_end("@class.outer"), { desc = "次のクラスの末尾へ移動" })
vim.keymap.set({ "n", "x", "o" }, "[[", prev_start("@class.outer"), { desc = "前のクラスの先頭へ移動" })
vim.keymap.set({ "n", "x", "o" }, "[]", prev_end("@class.outer"), { desc = "前のクラスの末尾へ移動" })
vim.keymap.set({ "n", "x", "o" }, "]l", next_start("@loop.outer"), { desc = "次のループの先頭へ移動" })
vim.keymap.set({ "n", "x", "o" }, "]L", next_end("@loop.outer"), { desc = "次のループの末尾へ移動" })
vim.keymap.set({ "n", "x", "o" }, "[l", prev_start("@loop.outer"), { desc = "前のループの先頭へ移動" })
vim.keymap.set({ "n", "x", "o" }, "[L", prev_end("@loop.outer"), { desc = "前のループの末尾へ移動" })
vim.keymap.set({ "n", "x", "o" }, "]o", next_start("@conditional.outer"), { desc = "次の条件分岐の先頭へ移動" })
vim.keymap.set({ "n", "x", "o" }, "]O", next_end("@conditional.outer"), { desc = "次の条件分岐の末尾へ移動" })
vim.keymap.set({ "n", "x", "o" }, "[o", prev_start("@conditional.outer"), { desc = "前の条件分岐の先頭へ移動" })
vim.keymap.set({ "n", "x", "o" }, "[O", prev_end("@conditional.outer"), { desc = "前の条件分岐の末尾へ移動" })

-- Swap
vim.keymap.set("n", "<leader>a", function()
  require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
end, { desc = "次の引数と入れ替え" })
vim.keymap.set("n", "<leader>A", function()
  require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
end, { desc = "前の引数と入れ替え" })
