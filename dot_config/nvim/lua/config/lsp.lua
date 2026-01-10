vim.lsp.enable({
  "lua_ls",
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
  callback = function(args)
    -- SignatureHelp
    vim.keymap.set("i", "<C-k>", function()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local config = vim.api.nvim_win_get_config(win)
        if config.relative ~= "" then
          -- フローティングウィンドウが存在する場合
          vim.api.nvim_win_close(win, true)
          return
        end
      end

      -- 開いていなければシグネチャヘルプを表示
      vim.lsp.buf.signature_help({
        border = "rounded",
        focusable = false,
        close_events = { "InsertLeave", "BufHidden" },
      })
    end, { buffer = args.buf, desc = "シグネチャヘルプをトグル" })

    -- InlayHint
    vim.keymap.set("n", "<leader>th", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
    end, { buffer = args.buf, desc = "インレイヒントをトグル" })

    -- CodeAction
    vim.keymap.set(
      { "n", "v" },
      "<leader>ca",
      vim.lsp.buf.code_action,
      { buffer = args.buf, desc = "コードアクションを表示" }
    )

    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = args.buf, desc = "ホバー表示" })
    vim.keymap.set(
      "n",
      "<leader>x",
      vim.diagnostic.open_float,
      { buffer = args.buf, desc = "診断詳細をポップアップ" }
    )
    vim.keymap.set("n", "]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, { buffer = args.buf, desc = "次の診断へ" })
    vim.keymap.set("n", "[d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, { buffer = args.buf, desc = "前の診断へ" })
  end,
})
