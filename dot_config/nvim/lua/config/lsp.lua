vim.lsp.enable({
  "emmylua_ls",
  "gopls",
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local buf = args.buf

    if client then
      if not pcall(require, "blink.cmp") and client:supports_method("textDocument/completion") then
        -- 全ての印字可能文字(ASCII 32-126)をトリガーに追加
        local chars = {}
        for i = 32, 126 do
          table.insert(chars, string.char(i))
        end

        local provider = client.server_capabilities and client.server_capabilities.completionProvider
        if provider then
          provider.triggerCharacters = chars
        end
        vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })
      end

      -- Inlay hints
      if client:supports_method("textDocument/inlayHint") then
        vim.lsp.inlay_hint.enable(true, { bufnr = buf })
      end
    end
  end,
})
