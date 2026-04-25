-- =============================================================================
-- LSP (Neovim 0.12 ネイティブ)
-- =============================================================================
-- Neovim 0.11+ で導入された vim.lsp.config / vim.lsp.enable + `lsp/<name>.lua`
-- 配置による設定方式を採用 (nvim-lspconfig プラグイン不要)。
--
-- - サーバ定義は `~/.config/nvim/lsp/<name>.lua` に置く (return table)
-- - vim.lsp.enable('<name>') で filetypes に応じた自動 attach を有効化
-- - 0.11+ から多くの LSP キーマップがデフォルトで設定されるため、ここでは
--   重複しない補助的なキーのみ追加する。デフォルトの一覧は CLAUDE.md 参照。
-- =============================================================================

-- ----- サーバの有効化 -------------------------------------------------------
-- 各サーバの設定は ~/.config/nvim/lsp/<name>.lua を参照
vim.lsp.enable({
  "lua_ls",
})

-- ----- 診断 (diagnostics) の表示設定 ----------------------------------------
-- 仮想テキストの行末表示は冗長なので prefix のみにする。フロート/sign は維持。
vim.diagnostic.config({
  severity_sort = true,
  virtual_text = {
    prefix = "●",
    spacing = 2,
  },
  float = {
    border = "rounded",
    source = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = "󱩎 ",
    },
  },
})

-- ----- LspAttach: バッファローカルキーマップの追加 -------------------------
-- Neovim 0.11+ のデフォルトで以下は既に定義済みなのでここでは重複させない:
--   K (hover), gra (code_action), gri (implementation), grn (rename),
--   grr (references), grt (type_definition), gO (document_symbol),
--   <C-s> insert (signature_help), [d / ]d (diagnostic 移動)
--
-- 各種 LSP クエリ (definitions / references / symbols 等) は keymaps.lua の
-- `<leader>l*` (snacks.picker 経由) が引き受ける。ここではバッファコンテキスト
-- に依存する補助キーだけを追加する。
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user.lsp.attach", { clear = true }),
  callback = function(ev)
    local bufnr = ev.buf
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    -- フォーマット (gq でも可だが明示的なキー)
    map({ "n", "v" }, "<leader>lf", function()
      vim.lsp.buf.format({ async = true })
    end, "LSP: フォーマット")

    -- 診断 float をカーソル位置で表示
    map("n", "<leader>le", vim.diagnostic.open_float, "LSP: 診断を表示")
  end,
})
