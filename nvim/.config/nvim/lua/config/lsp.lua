vim.lsp.enable({
  "gopls",
  "golangci_lint_ls",
  "lua_ls",
  "vtsls",
  -- "ts_ls",
})

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "", 
    },
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_keymaps", { clear = true }),
  callback = function(ev)
    local Snacks = require("snacks")
    local opts = function(desc) return { buffer = ev.buf, desc = desc } end
    vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, opts("定義へ移動"))
    vim.keymap.set("n", "gD", function() Snacks.picker.lsp_declarations() end, opts("宣言へ移動"))
    vim.keymap.set("n", "gi", function() Snacks.picker.lsp_implementations() end, opts("実装へ移動"))
    vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end, opts("参照一覧"))
    vim.keymap.set("n", "gy", function() Snacks.picker.lsp_type_definitions() end, opts("型定義へ移動"))
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("ホバー情報"))
    vim.keymap.set({ "n", "v" }, "<Leader>la", vim.lsp.buf.code_action, opts("コードアクション"))
    vim.keymap.set("n", "<Leader>lr", vim.lsp.buf.rename, opts("シンボルをリネーム"))
    vim.keymap.set("n", "<Leader>ls", function() Snacks.picker.lsp_symbols() end, opts("シンボル検索"))
  end,
})

