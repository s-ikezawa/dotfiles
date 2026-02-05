-- jk でノーマルモードに抜ける
vim.keymap.set({"n", "t"}, "jk", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- ウィンドウ移動: Ctrl + h/j/k/l (ノーマルモード・ターミナルモード両方)
vim.keymap.set({ "n", "t" }, "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Move to left window" })
vim.keymap.set({ "n", "t" }, "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Move to below window" })
vim.keymap.set({ "n", "t" }, "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Move to above window" })
vim.keymap.set({ "n", "t" }, "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Move to right window" })

-- ウィンドウリサイズモード
local resize_mode_active = false
local resize_keymaps = {}

local function exit_resize_mode()
  if not resize_mode_active then
    return
  end
  resize_mode_active = false
  for _, key in ipairs({ "h", "j", "k", "l", "=", "<Esc>", "q" }) do
    pcall(vim.keymap.del, "n", key, { buffer = 0 })
  end
  vim.notify("Resize mode: OFF", vim.log.levels.INFO)
end

local function enter_resize_mode()
  if resize_mode_active then
    return
  end
  resize_mode_active = true

  local opts = { buffer = 0, nowait = true }

  vim.keymap.set("n", "h", function()
    vim.cmd("vertical resize -2")
  end, vim.tbl_extend("force", opts, { desc = "Resize: decrease width" }))

  vim.keymap.set("n", "l", function()
    vim.cmd("vertical resize +2")
  end, vim.tbl_extend("force", opts, { desc = "Resize: increase width" }))

  vim.keymap.set("n", "j", function()
    vim.cmd("resize -2")
  end, vim.tbl_extend("force", opts, { desc = "Resize: decrease height" }))

  vim.keymap.set("n", "k", function()
    vim.cmd("resize +2")
  end, vim.tbl_extend("force", opts, { desc = "Resize: increase height" }))

  vim.keymap.set("n", "=", function()
    vim.cmd("wincmd =")
  end, vim.tbl_extend("force", opts, { desc = "Resize: equalize windows" }))

  vim.keymap.set("n", "<Esc>", exit_resize_mode, opts)
  vim.keymap.set("n", "q", exit_resize_mode, opts)

  vim.notify("Resize mode: ON (h/l=width, j/k=height, ==equalize, q/Esc=exit)", vim.log.levels.INFO)
end

vim.keymap.set("n", "<leader>wr", enter_resize_mode, { desc = "Enter window resize mode" })
