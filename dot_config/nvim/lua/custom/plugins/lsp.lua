return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      servers = {
        gopls = require("custom.lsp.gopls"),
        lua_ls = require("custom.lsp.lua_ls"),
      },
      capabilities = {},
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities() or {},
        require("blink.cmp").get_lsp_capabilities() or {},
        opts.capabilities or {}
      )
      -- LSP Hoverのデザイン変更
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

      for server, config in pairs(opts.servers) do
        local server_opts = vim.tbl_deep_extend("force", { capabilities = vim.deepcopy(capabilities) }, config)

        lspconfig[server].setup(server_opts)
      end

      -- LSPがattachされた時に反映する設定など
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("MyLspAttach", {}),
        callback = function(ev)
          -- keymaps
          local wk = require("which-key")
          local diagnostic_goto = function(next, severity)
            local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
            severity = severity and vim.diagnostic.severity[severity] or nil
            return function()
              go({ severity = severity })
            end
          end

          -- stylua: ignore start
          wk.add({
            { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
            --{ "gd", vim.lsp.buf.definition, desc = "Goto Definition" },
            { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition", },
            --{ "gr", vim.lsp.buf.references, desc = "Refrences", nowait = true },
            { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References", },
            --{ "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
            { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation", },
            --{ "gy", vim.lsp.buf.type_definition, desc = "Goto Type Definition" },
            { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto Type Definition", },
            --{ "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
            { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration", },
            { "K", vim.lsp.buf.hover, desc = "Hover" },
            { "gK", vim.lsp.buf.signature_help, desc = "Signature Help" },
            { "<c-k>", vim.lsp.buf.signature_help, desc = "Signature Help", mode = { "i" } },
            { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" } },
            { "<leader>cc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "v" } },
            { "<leader>cC", vim.lsp.codelens.refresh, desc = "Refresh Codelens", mode = { "n", "v" } },
            { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File", mode = { "n" }, },
            { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
            { "<leader>cA", vim.lsp.buf.code_action, desc = "Source Action" },
            { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", cond = function() return Snacks.words.is_enabled() end, },
            { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", cond = function() return Snacks.words.is_enabled() end, },
            { "<a-n>", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", cond = function() return Snacks.words.is_enabled() end, },
            { "<a-p>", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", cond = function() return Snacks.words.is_enabled() end, },
            { "]d", diagnostic_goto(true), desc = "Next Diagnostic" },
            { "[d", diagnostic_goto(false), desc = "Prev Diagnostic" },
            { "]e", diagnostic_goto(true, "ERROR"), desc = "Next Error" },
            { "[e", diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
            { "]w", diagnostic_goto(true, "ERROR"), desc = "Next Warning" },
            { "[w", diagnostic_goto(false, "ERROR"), desc = "Prev Warning" },
          })
          -- stylua: ignore end

          -- Golang Import and Formatting
          vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*.go",
            callback = function()
              local params = vim.lsp.util.make_range_params()
              params.context = { only = { "source.organizeImports" } }

              local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
              for cid, res in pairs(result or {}) do
                for _, r in pairs(res.result or {}) do
                  if r.edit then
                    local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                    vim.lsp.util.apply_workspace_edit(r.edit, enc)
                  end
                end
              end
            end,
          })

          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client == nil then
            return
          end

          -- Inlay Hint
          if client.supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
          end

          -- code lens
          if client.supports_method("textDocument/codeLens") then
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
              buffer = ev.buf,
              callback = vim.lsp.codelens.refresh,
            })
          end

          -- semantic token
          if not client.server_capabilities.semanticTokensProvider then
            local semantic = client.config.capabilities.textDocument.semanticTokens
            if semantic ~= nil then
              client.server_capabilities.semanticTokensProvider = {
                full = true,
                legend = {
                  tokenTypes = semantic.tokenTypes,
                  tokenModifiers = semantic.tokenModifiers,
                },
              }
            end
          end
        end,
      })

      -- Diagnosticの設定
      vim.diagnostic.config({
        float = {
          border = "rounded",
        },
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
      })

      -- LSP Progress
      local progress = vim.defaulttable()
      vim.api.nvim_create_autocmd("LspProgress", {
        ---@param ev { data: { client_id: integer, params: lsp.ProgressParams } }
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          local value = ev.data.params.value -- [ [@as { percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end" } ] ]
          if not client or type(value) ~= "table" then
            return
          end
          local p = progress[client.id]

          for i = 1, #p + 1 do
            if i == #p + 1 or p[i].token == ev.data.params.token then
              p[i] = {
                token = ev.data.params.token,
                msg = ("[%3d%%] %s%s"):format(
                  value.kind == "end" and 100 or value.percentage or 100,
                  value.title or "",
                  value.message and (" **%s**"):format(value.message) or ""
                ),
                done = value.kind == "end",
              }
              break
            end
          end

          local msg = {} ---@type string[]
          progress[client.id] = vim.tbl_filter(function(v)
            return table.insert(msg, v.msg) or not v.done
          end, p)

          local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
          vim.notify(table.concat(msg, "\n"), "info", {
            id = "lsp_progress",
            title = client.name,
            opts = function(notif)
              notif.icon = #progress[client.id] == 0 and " "
                or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
          })
        end,
      })
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "LazyVim", words = { "LazyVim" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "lazy.nvim", words = { "LazyVim" } },
      },
    },
  },
}
