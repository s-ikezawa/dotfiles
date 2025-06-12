local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

autocmd("VimResized", {
  desc = "Resize splits if window got resized",
  group = vim.api.nvim_create_augroup("resize_splits", { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

autocmd("FileType", {
  desc = "Close some filetypes with <q>",
  group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

autocmd("BufReadPost", {
  desc = "Go to last loc when opening a buffer",
  group = vim.api.nvim_create_augroup("last_loc", { clear = true }),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
      return
    end
    vim.b[buf].last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Quickfixリストの自動更新
autocmd("DiagnosticChanged", {
  desc = "Auto-update quickfix list when diagnostics change",
  group = vim.api.nvim_create_augroup("diagnostic_quickfix", { clear = true }),
  callback = function()
    -- quickfixリストが開いている場合のみ更新
    if vim.fn.getqflist({winid = 0}).winid ~= 0 then
      vim.diagnostic.setqflist({ open = false })
    end
  end,
})

-- ファイル保存時とバッファ変更時にquickfixリストを更新
autocmd({ "BufWritePost", "InsertLeave" }, {
  desc = "Update quickfix list on file save and insert leave",
  group = vim.api.nvim_create_augroup("quickfix_update", { clear = true }),
  callback = function()
    vim.schedule(function()
      -- quickfixリストが開いている場合のみ更新
      if vim.fn.getqflist({winid = 0}).winid ~= 0 then
        vim.diagnostic.setqflist({ open = false })
      end
    end)
  end,
})