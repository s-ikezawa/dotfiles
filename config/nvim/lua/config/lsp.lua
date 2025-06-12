-- LSP設定
local M = {}

function M.setup()
  -- 診断表示の設定
  vim.diagnostic.config({
    virtual_text = {
      prefix = "●",
      spacing = 4,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = " ",
        },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  })

  -- Neovim v0.11以降: 全ての浮動ウィンドウに丸角ボーダーを設定
  vim.o.winborder = "rounded"

  -- LSPサーバーが接続されたときの設定
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
      local opts = { buffer = ev.buf }
      
      -- キーマッピング
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "宣言へ移動" })
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "定義へ移動" })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "ホバー情報" })
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = ev.buf, desc = "実装へ移動" })
      vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "シグネチャヘルプ" })
      vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { buffer = ev.buf, desc = "ワークスペース追加" })
      vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { buffer = ev.buf, desc = "ワークスペース削除" })
      vim.keymap.set("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, { buffer = ev.buf, desc = "ワークスペース一覧" })
      vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, { buffer = ev.buf, desc = "型定義へ移動" })
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "リネーム" })
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "コードアクション" })
      vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = ev.buf, desc = "参照一覧" })
      vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format { async = true }
      end, { buffer = ev.buf, desc = "フォーマット" })
      
      -- 診断関連のキーマッピング
      vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { buffer = ev.buf, desc = "診断を表示" })
      vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { buffer = ev.buf, desc = "前の診断へ" })
      vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { buffer = ev.buf, desc = "次の診断へ" })
      vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { buffer = ev.buf, desc = "診断をリストへ" })
    end,
  })

  -- LSPサーバー設定を読み込み
  require("config.lsp.servers.lua_ls").setup()
end

return M
