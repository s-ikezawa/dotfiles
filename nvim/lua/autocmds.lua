vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("MyLspAttach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: "..desc })
    end

    map("gd", vim.lsp.buf.definition, "Goto Definition")
    map("gr", vim.lsp.buf.references, "References")
    map("gI", vim.lsp.buf.implementation, "Goto Implementation")
    map("gy", vim.lsp.buf.type_definition, "Goto Type Definition")
    map("gD", vim.lsp.buf.declaration, "Goto Declaration")
    map("K", vim.lsp.buf.hover, "Hover")
    map("gs", vim.lsp.buf.signature_help, "Signature Help")
    map("gl", function()
      local float = vim.diagnostic.config().float
      if float then
        local config = type(float) == "table" and float or {}
        config.scope = "line"
        vim.diagnostic.open_float(config)
      end
    end, "Show line diagnostics")
    map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "v" })
    map("<leader>cc", vim.lsp.codelens.run, "Run Codelens", { "n", "v" })
    map("<leader>cC", vim.lsp.codelens.refresh, "Refresh & Display Codelens")
    map("<leader>cr", vim.lsp.buf.rename, "Rename")

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      map("<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, "Toggle Inlay Hints")
    end
  end
})
