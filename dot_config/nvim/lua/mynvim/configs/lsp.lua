vim.lsp.enable({
  "lua_ls"
})

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
  },
  virtual_lines = {
    current_line = true,
  },
  -- 診断を即座に更新
  update_in_insert = false, -- 挿入モードでは更新しない（パフォーマンス向上）
  severity_sort = true,     -- 重要度順にソート
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("MyLsp", {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local buf = args.buf

    -- descriptionを追加するヘルパー関数
    local function desc(description)
      return { buffer = buf, silent = true, desc = description }
    end

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, desc("定義へジャンプ"))
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, desc("宣言へジャンプ"))
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, desc("実装へジャンプ"))
    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, desc("型定義へジャンプ"))
    vim.keymap.set("n", "gr", vim.lsp.buf.references, desc("参照を表示"))
    vim.keymap.set("n", "K", vim.lsp.buf.hover, desc("ホバー情報を表示"))
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, desc("シグネチャヘルプを表示"))
    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, desc("シンボルをリネーム"))
    vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, desc("コードアクション"))
    vim.keymap.set("n", "<leader>le", vim.diagnostic.open_float, desc("診断情報を表示"))
    vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, desc("次の診断へ移動"))
    vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, desc("前の診断へ移動"))

    -- 補完機能の有効化 (Ctrl+Space)
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })
      vim.keymap.set("i", "<C-Space>", function()
        vim.lsp.completion.get()
      end)
    end

    -- 保存時のフォーマット
    if client:supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("MyLspFormat", {}),
        buffer = buf,
        callback = function()
          -- Golang OrganizeImports
          if vim.bo[buf].filetype == "go" and client:supports_method("textDocument/codeAction") then
            local enc = client.offset_encoding or "utf-16"
            local range_params = vim.lsp.util.make_range_params(nil, enc)
            local params = vim.tbl_extend("force", range_params, {
              context = { only = { "source.organizeImports" } }
            })

            local result = vim.lsp.buf_request_sync(buf, "textDocument/codeAction", params, 3000)
            for _, res in pairs(result or {}) do
              for _, r in pairs(res.result or {}) do
                if r.edit then
                  vim.lsp.util.apply_workspace_edit(r.edit, enc)
                end
              end
            end
          end

          -- Format
          vim.lsp.buf.format({
            bufnr = buf,
            id = client.id,
            async = false,
            timeout_ms = 3000
          })
        end
      })
    end
  end
})
