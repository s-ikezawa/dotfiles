-- ============================================================================
-- LSP 設定（Neovim 標準の vim.lsp、ネイティブ構成）
-- ============================================================================
-- nvim-lspconfig は使わない。各サーバの設定は runtimepath 上の lsp/<name>.lua
-- に置き（Neovim 0.11+ が自動で vim.lsp.config として読み込む）、ここでは
-- vim.lsp.enable で有効化するだけにする。
--   サーバ定義: lsp/kotlin_lsp.lua
--
-- キーマップは 0.11+ 組み込みの既定をそのまま使うため、ここでは定義しない:
--   K=hover, grn=rename, gra=code action, grr=references, gri=implementation,
--   gO=document symbol, [d/]d=診断移動, CTRL-S(挿入)=signature help

-- kotlin-lsp（設定は lsp/kotlin_lsp.lua）。未導入環境では有効化しない
-- （kotlin ファイルを開いた際の起動エラーを避ける）。
if vim.fn.executable("kotlin-lsp") == 1 then
  vim.lsp.enable("kotlin_lsp")
end

-- ----------------------------------------------------------------------------
-- LspAttach: サーバが対応している機能を自動で ON にする
-- ----------------------------------------------------------------------------
-- サーバが attach した時点で、ケイパビリティ(client:supports_method)を確認しながら
-- 各機能を有効化する。未対応サーバでは黙ってスキップされる（汎用なので将来サーバを
-- 増やしても安全）。kotlin-lsp の対応状況:
--   対応   : inlayHint / completion / signatureHelp / foldingRange
--   非対応 : documentHighlight / codeLens（=自動でスキップ）
-- semanticTokens は Neovim 0.11+ が対応サーバで既定 ON にするためここでは何もしない。
-- signature help は noice の lsp.signature.auto_open（既定 ON）が '(' ',' 入力時に
-- 自動表示する。二重化を避けここでは設定しない（挿入 CTRL-S の手動表示も従来どおり可）。
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    -- inlay hints: 起動時から ON にする（,uh の Snacks トグルで後から OFF/ON 可）
    if client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    -- 自動補完: 入力に応じてトリガ（組み込み補完。手動の <C-x><C-o> も併用可）
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    end

    -- シグネチャヘルプ（自前の自動表示）: トリガ文字('(' ',' 等)を入力した時に
    -- vim.lsp.buf.signature_help() を呼んでポップアップを出す実装。
    -- ▼ コメントアウトしている理由:
    --   noice の lsp.signature.auto_open（既定 ON）が "全く同じこと"（trigger 文字での
    --   自動表示）を既に行っている。両方を有効にすると signature ポップアップが二重に
    --   出る／ちらつくため、こちらは無効化して noice 側に一本化している。
    --   noice を外す、または noice 側の signature を無効化した場合に、このブロックの
    --   コメントを外して使う（挿入 CTRL-S の手動表示はどちらの構成でも使える）。
    -- if client:supports_method("textDocument/signatureHelp") then
    --   local triggers = vim.tbl_get(client.server_capabilities, "signatureHelpProvider", "triggerCharacters")
    --     or { "(", "," }
    --   local grp = vim.api.nvim_create_augroup("user_lsp_signature", { clear = false })
    --   vim.api.nvim_clear_autocmds({ group = grp, buffer = bufnr })
    --   vim.api.nvim_create_autocmd("InsertCharPre", {
    --     group = grp,
    --     buffer = bufnr,
    --     callback = function()
    --       if vim.tbl_contains(triggers, vim.v.char) then
    --         vim.schedule(vim.lsp.buf.signature_help) -- 文字が挿入された後に表示したいので次のループで呼ぶ
    --       end
    --     end,
    --   })
    -- end

    -- 参照ハイライト: カーソル下シンボルの使用箇所を強調（CursorHold で更新 / 移動で消去）
    -- ※ group は clear=false にし、バッファ単位でのみ古い autocmd を消す（他バッファを壊さない）
    if client:supports_method("textDocument/documentHighlight") then
      local grp = vim.api.nvim_create_augroup("user_lsp_doc_highlight", { clear = false })
      vim.api.nvim_clear_autocmds({ group = grp, buffer = bufnr })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = grp,
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        group = grp,
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
    end

    -- コードレンズ: 実行可能アクション等を行に表示（入場/保存後/CursorHold で更新）
    if client:supports_method("textDocument/codeLens") then
      local grp = vim.api.nvim_create_augroup("user_lsp_codelens", { clear = false })
      vim.api.nvim_clear_autocmds({ group = grp, buffer = bufnr })
      vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        group = grp,
        buffer = bufnr,
        callback = function()
          vim.lsp.codelens.refresh({ bufnr = bufnr })
        end,
      })
      vim.lsp.codelens.refresh({ bufnr = bufnr })
    end

    -- LSP ベースの折りたたみ（foldingRange 対応サーバ）。
    -- 開いた直後に畳まれないよう foldlevel を高く保つ（手動 za / zR / zM で操作）。
    if client:supports_method("textDocument/foldingRange") then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win].foldmethod = "expr"
      vim.wo[win].foldexpr = "v:lua.vim.lsp.foldexpr()"
      vim.wo[win].foldlevel = 99
    end
  end,
})

