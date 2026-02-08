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

      -- Inlay hints: コード中に型情報やパラメータ名を薄く表示する機能
      -- 例: local x = foo(a, b) → local x: int = foo(a: string, b: bool)
      if client:supports_method("textDocument/inlayHint") then
        vim.lsp.inlay_hint.enable(true, { bufnr = buf })
        vim.keymap.set("n", "<leader>uh", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
        end, { buffer = buf, desc = "Inlay hintsをトグル" })
      end

      -- Codelens: 関数の上部に参照数やテスト実行などのアクションを表示する機能
      -- 例: "3 references" や "run test" のようなリンクが関数定義の上に表示される
      if client:supports_method("textDocument/codeLens") then
        vim.lsp.codelens.enable(true, { bufnr = buf })
        vim.keymap.set("n", "<leader>uC", function()
          vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled({ bufnr = buf }), { bufnr = buf })
        end, { buffer = buf, desc = "Codelensをトグル" })
      end
    end

    -- Diagnostics（クライアント非依存）
    vim.keymap.set("n", "<leader>ud", function()
      vim.diagnostic.enable(not vim.diagnostic.is_enabled({ bufnr = buf }), { bufnr = buf })
    end, { buffer = buf, desc = "Diagnosticsをトグル" })
  end,
})
