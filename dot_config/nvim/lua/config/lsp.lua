-- LSP と診断の設定。
-- 言語サーバーごとの設定は lsp/<名前>.lua に置き、ここで有効にする。
-- Neovim 0.11 以降の標準のキー: K（ホバー）、grn（名前の変更）、gra（コードアクション）、
-- grr（参照）、gri（実装）、grt（型定義）、gO（シンボルの一覧）、挿入モードの <C-s>（シグネチャ）。

vim.lsp.enable({
  'lua_ls', -- Lua（lsp/lua_ls.lua）
})

-- 診断の見た目
vim.diagnostic.config({
  virtual_text = true,  -- 診断の内容を行末に出す
  severity_sort = true, -- 同じ行に複数あるときは重いもの（エラー）を上にする
  float = { source = true }, -- フローティングウィンドウには、どのサーバーの診断かも出す
  signs = {
    text = { -- サインの列に出す印（既定の E・W・I・H の代わりに Nerd Font のアイコン）
      [vim.diagnostic.severity.ERROR] = '\u{f057}', -- エラー（nf-fa-circle_xmark）
      [vim.diagnostic.severity.WARN] = '\u{f071}',  -- 警告（nf-fa-triangle_exclamation）
      [vim.diagnostic.severity.INFO] = '\u{f05a}',  -- 情報（nf-fa-circle_info）
      [vim.diagnostic.severity.HINT] = '\u{f0eb}',  -- ヒント（nf-fa-lightbulb）
    },
  },
})

-- 言語サーバーがバッファにつながったときの設定
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('config_lsp_attach', { clear = true }),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local buf = args.buf

    -- 標準にない定義・宣言へのジャンプを足す
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = buf, desc = '定義へ移る（LSP）' })
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = buf, desc = '宣言へ移る（LSP）' })

    -- 入力中に補完の候補を自動で出す
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })
    end
  end,
})
