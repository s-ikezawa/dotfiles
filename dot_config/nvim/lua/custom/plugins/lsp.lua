return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = "Replace",
              },
              doc = {
                privateName = { "^_" },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
        },
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

          wk.add({
            { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
            --{ "gd", vim.lsp.buf.definition, desc = "Goto Definition" },
            {
              "gd",
              function()
                Snacks.picker.lsp_definitions()
              end,
              desc = "Goto Definition",
            },
            --{ "gr", vim.lsp.buf.references, desc = "Refrences", nowait = true },
            {
              "gr",
              function()
                Snacks.picker.lsp_references()
              end,
              nowait = true,
              desc = "References",
            },
            --{ "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
            {
              "gI",
              function()
                Snacks.picker.lsp_implementations()
              end,
              desc = "Goto Implementation",
            },
            --{ "gy", vim.lsp.buf.type_definition, desc = "Goto Type Definition" },
            {
              "gy",
              function()
                Snacks.picker.lsp_type_definitions()
              end,
              desc = "Goto Type Definition",
            },
            --{ "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
            {
              "gD",
              function()
                Snacks.picker.lsp_declarations()
              end,
              desc = "Goto Declaration",
            },
            { "K", vim.lsp.buf.hover, desc = "Hover" },
            { "gK", vim.lsp.buf.signature_help, desc = "Signature Help" },
            { "<c-k>", vim.lsp.buf.signature_help, desc = "Signature Help", mode = { "i" } },
            { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" } },
            { "<leader>cc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "v" } },
            { "<leader>cC", vim.lsp.codelens.refresh, desc = "Refresh Codelens", mode = { "n", "v" } },
            {
              "<leader>cR",
              function()
                Snacks.rename.rename_file()
              end,
              desc = "Rename File",
              mode = { "n" },
            },
            { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
            { "<leader>cA", vim.lsp.buf.code_action, desc = "Source Action" },
            {
              "]]",
              function()
                Snacks.words.jump(vim.v.count1)
              end,
              desc = "Next Reference",
              cond = function()
                return Snacks.words.is_enabled()
              end,
            },
            {
              "[[",
              function()
                Snacks.words.jump(-vim.v.count1)
              end,
              desc = "Prev Reference",
              cond = function()
                return Snacks.words.is_enabled()
              end,
            },
            {
              "<a-n>",
              function()
                Snacks.words.jump(vim.v.count1)
              end,
              desc = "Next Reference",
              cond = function()
                return Snacks.words.is_enabled()
              end,
            },
            {
              "<a-p>",
              function()
                Snacks.words.jump(-vim.v.count1)
              end,
              desc = "Prev Reference",
              cond = function()
                return Snacks.words.is_enabled()
              end,
            },
            { "]d", diagnostic_goto(true), desc = "Next Diagnostic" },
            { "[d", diagnostic_goto(false), desc = "Prev Diagnostic" },
            { "]e", diagnostic_goto(true, "ERROR"), desc = "Next Error" },
            { "[e", diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
            { "]w", diagnostic_goto(true, "ERROR"), desc = "Next Warning" },
            { "[w", diagnostic_goto(false, "ERROR"), desc = "Prev Warning" },
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
        end,
      })

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
