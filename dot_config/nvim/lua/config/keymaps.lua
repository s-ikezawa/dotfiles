local keymap = vim.keymap

-- File Explorer
keymap.set("n", "<leader>ef", ":NvimTreeFocus<CR>", { desc = "[E]xplorer [F]ocus", noremap = true, silent = true  })
keymap.set("n", "<leader>et", ":NvimTreeToggle<CR>", { desc = "[E]xplorer [T]oggle", noremap = true, silent = true  })
keymap.set("n", "<leader>eo", ":NvimTreeOpen<CR>", { desc = "[E]xplorer [O]pen", noremap = true, silent = true  })
keymap.set("n", "<leader>ec", ":NvimTreeClose<CR>", { desc = "[E]xplorer [C]lose", noremap = true, silent = true  })
keymap.set("n", "<leader>er", ":NvimTreeRefresh<CR>", { desc = "[E]xplorer [R]efresh", noremap = true, silent = true  })

-- Pane Navigation
keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "[S]plit [V]ertically", noremap = true, silent = true  })
keymap.set("n", "<leader>sh", ":split<CR>", { desc = "[S]plit [H]orizontally", noremap = true, silent = true  })
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move left pane", noremap = true, silent = true  })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move bottom pane", noremap = true, silent = true  })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move up pane", noremap = true, silent = true  })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move right pane", noremap = true, silent = true  })

-- Indenting
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- Comments
vim.api.nvim_set_keymap("n", "<C-/>", "gcc", { desc = "Toggle Comment", noremap = false })
vim.api.nvim_set_keymap("v", "<C-/>", "gcc", { desc = "Toggle Comment", noremap = false })

