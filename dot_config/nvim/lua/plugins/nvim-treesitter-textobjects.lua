vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
    version = "main",
  },
})

-- Disable entire built-in ftplugin mappings to avoid conflicts.
-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
vim.g.no_plugin_maps = true

require("nvim-treesitter-textobjects").setup({
  select = {
    enable = true,
    -- Automatically jump forward to textobj, similar to targets.vim
    lookahead = true,
    -- You can choose the select mode (default is charwise 'v')
    --
    -- Can also be a function which gets passed a table with the keys
    -- * query_string: eg '@function.inner'
    -- * method: eg 'v' or 'o'
    -- and should return the mode ('v', 'V', or '<c-v>') or a table
    -- mapping query_strings to modes.
    selection_modes = {
      ["@parameter.outer"] = "v", -- charwise
      ["@function.outer"] = "V", -- linewise
      -- ['@class.outer'] = '<c-v>', -- blockwise
    },
    -- If you set this to `true` (default is `false`) then any textobject is
    -- extended to include preceding or succeeding whitespace. Succeeding
    -- whitespace has priority in order to act similarly to eg the built-in
    -- `ap`.
    --
    -- Can also be a function which gets passed a table with the keys
    -- * query_string: eg '@function.inner'
    -- * selection_mode: eg 'v'
    -- and should return true of false
    include_surrounding_whitespace = false,
  },
  move = {
    enable = true,
    set_jumps = true,
  },
})

local sel = require("nvim-treesitter-textobjects.select")
for _, map in ipairs({
  { { "x", "o" }, "af", "@function.outer" },
  { { "x", "o" }, "if", "@function.inner" },
  { { "x", "o" }, "ac", "@class.outer" },
  { { "x", "o" }, "ic", "@class.inner" },
  { { "x", "o" }, "ap", "@parameter.outer" },
  { { "x", "o" }, "ip", "@parameter.inner" },
  { { "x", "o" }, "aC", "@call.outer" },
  { { "x", "o" }, "iC", "@call.inner" },
  { { "x", "o" }, "ai", "@conditional.outer" },
  { { "x", "o" }, "ii", "@conditional.inner" },
  { { "x", "o" }, "al", "@loop.outer" },
  { { "x", "o" }, "il", "@loop.inner" },
  { { "x", "o" }, "a/", "@comment.outer" },
  { { "x", "o" }, "a=", "@assignment.outer" },
  { { "x", "o" }, "i=", "@assignment.inner" },
  { { "x", "o" }, "l=", "@assignment.lhs" },
  { { "x", "o" }, "r=", "@assignment.rhs" },
  { { "x", "o" }, "in", "@number.inner" },
}) do
  vim.keymap.set(map[1], map[2], function()
    sel.select_textobject(map[3], "textobjects")
  end, { desc = "Select " .. map[3] })
end

local mv = require("nvim-treesitter-textobjects.move")
for _, map in ipairs({
  { { "n", "x", "o" }, "]m", mv.goto_next_start, "@function.outer" },
  { { "n", "x", "o" }, "[m", mv.goto_previous_start, "@function.outer" },
  { { "n", "x", "o" }, "]M", mv.goto_next_end, "@function.outer" },
  { { "n", "x", "o" }, "[M", mv.goto_previous_end, "@function.outer" },
  { { "n", "x", "o" }, "]]", mv.goto_next_start, "@class.outer" },
  { { "n", "x", "o" }, "[[", mv.goto_previous_start, "@class.outer" },
  { { "n", "x", "o" }, "]o", mv.goto_next_start, { "@loop.inner", "@loop.outer" } },
  { { "n", "x", "o" }, "[o", mv.goto_previous_start, { "@loop.inner", "@loop.outer" } },
}) do
  local modes, lhs, fn, query = map[1], map[2], map[3], map[4]
  local qstr = (type(query) == "table") and table.concat(query, ",") or query
  vim.keymap.set(modes, lhs, function()
    fn(query, "textobjects")
  end, { desc = "Move to " .. qstr })
end
