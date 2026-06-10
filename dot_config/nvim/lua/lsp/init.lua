-- ~/.config/nvim/lua/lsp/init.lua
-- LSP 設定 (Neovim 0.12 ネイティブ API)  ※ require("lsp") のエントリ
-- =============================================================================
-- nvim-lspconfig を使わず、Neovim 0.12 ネイティブ API で各サーバーを手書きする。
-- サーバー本体は手動 (mise / brew 等) で導入し PATH を通す前提。
-- 補完は 0.12 標準の vim.lsp.completion (autotrigger) を使う。
--
-- 構成:
--   lua/lsp/init.lua    ... 全サーバー共通の設定 (診断・LspAttach) と enable 一覧 (本ファイル)
--   lua/lsp/progress.lua ... LSP 作業進捗 ($/progress) の nvim-notify 表示
--   lsp/<name>.lua      ... 各サーバー定義 (※ runtimepath 直下の特別ディレクトリ。
--                           lua/lsp/ とは別物。設定テーブルを return すると
--                           vim.lsp.enable 時に自動的に使われる)
--
-- サーバーを増やす時は:
--   1. 本体を導入し PATH を通す
--   2. lsp/<name>.lua を作成し、設定テーブルを return する
--   3. 下部の vim.lsp.enable({ ... }) に名前を追加する
-- =============================================================================

local icons = require("icons")

-- ============================================================
-- 診断表示 (Diagnostics)
-- ============================================================
vim.diagnostic.config({
  virtual_text = true,    -- 行末にインラインで診断メッセージを表示
  severity_sort = true,   -- 深刻度順に並べる
  float = { border = "rounded" }, -- フロート診断の枠線を丸める
  -- 診断箇所へジャンプした時にカーソル位置の診断をフロート表示する。
  -- 0.12 で jump.float = true は非推奨になったため on_jump で代替する。
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
    end,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnostics.ERROR,
      [vim.diagnostic.severity.WARN] = icons.diagnostics.WARN,
      [vim.diagnostic.severity.INFO] = icons.diagnostics.INFO,
      [vim.diagnostic.severity.HINT] = icons.diagnostics.HINT,
    },
  },
})

-- ============================================================
-- LspAttach: サーバー接続時の共通処理 (補完有効化 + キーマップ)
-- ============================================================
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local buf = args.buf

    -- ネイティブ補完 (0.12) を有効化する。
    -- autotrigger はサーバーのトリガー文字 (lua_ls なら "." ":" 等) でのみ
    -- 自動発火するため、通常の単語入力では補完が出ない。そこで識別子文字を
    -- 打った時にも補完を要求する TextChangedI を追加し、打鍵ごとに表示させる。
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })

      -- 単語入力中も補完を自動表示する (補完メニュー非表示かつ直前が識別子文字の時)
      vim.api.nvim_create_autocmd("TextChangedI", {
        buffer = buf,
        group = vim.api.nvim_create_augroup("user_lsp_completion_" .. buf, { clear = true }),
        callback = function()
          if vim.fn.pumvisible() == 1 then return end -- 表示中はネイティブの絞り込みに任せる
          local col = vim.fn.col(".") - 1
          local line = vim.api.nvim_get_current_line()
          if col > 0 and line:sub(col, col):match("[%w_]") then
            vim.lsp.completion.get()
          end
        end,
      })

      -- 手動トリガー (insert モードで <C-Space>)
      vim.keymap.set("i", "<C-Space>", function() vim.lsp.completion.get() end,
        { buffer = buf, desc = "LSP 補完を表示" })

      -- 補完確定: 候補を選択中の時だけ <CR> で確定し、改行は挿入しない。
      -- これで snippet 候補も CompleteDone 経由で正しく展開され (vim.snippet)、
      -- 確定後に行末へ改行が入ってカーソルが飛ぶ問題を防ぐ。
      vim.keymap.set("i", "<CR>", function()
        if vim.fn.pumvisible() == 1 and vim.fn.complete_info().selected ~= -1 then
          return "<C-y>" -- 選択中の候補を確定 (改行なし)
        end
        return "<CR>"    -- それ以外は通常の改行
      end, { buffer = buf, expr = true, desc = "補完を確定 / 改行" })

      -- snippet のプレースホルダ間を <Tab>/<S-Tab> で移動する (vim.snippet, 標準機能)
      vim.keymap.set({ "i", "s" }, "<Tab>", function()
        if vim.snippet.active({ direction = 1 }) then
          return "<Cmd>lua vim.snippet.jump(1)<CR>"
        end
        return "<Tab>"
      end, { buffer = buf, expr = true, desc = "snippet 次へ / Tab" })
      vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
        if vim.snippet.active({ direction = -1 }) then
          return "<Cmd>lua vim.snippet.jump(-1)<CR>"
        end
        return "<S-Tab>"
      end, { buffer = buf, expr = true, desc = "snippet 前へ / S-Tab" })
    end

    -- バッファローカルなキーマップ
    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
    end
    -- ジャンプ/一覧系は snacks の picker に連携 (フローティング一覧 UI で表示)
    map("gd", function() Snacks.picker.lsp_definitions() end, "定義へ移動")
    map("gD", function() Snacks.picker.lsp_declarations() end, "宣言へ移動")
    map("gr", function() Snacks.picker.lsp_references() end, "参照一覧")
    map("gi", function() Snacks.picker.lsp_implementations() end, "実装へ移動")
    map("gy", function() Snacks.picker.lsp_type_definitions() end, "型定義へ移動")
    map("<leader>ds", function() Snacks.picker.lsp_symbols() end, "ドキュメントシンボル")
    map("<leader>ws", function() Snacks.picker.lsp_workspace_symbols() end, "ワークスペースシンボル")
    map("<leader>fd", function() Snacks.picker.diagnostics_buffer() end, "バッファ診断一覧")
    map("<leader>fD", function() Snacks.picker.diagnostics() end, "全体の診断一覧")
    -- hover/rename/code_action は snacks に該当が無いためネイティブのまま
    map("K", function() vim.lsp.buf.hover({ border = "rounded" }) end, "ホバー情報を表示")
    map("<leader>rn", vim.lsp.buf.rename, "シンボルをリネーム")
    map("<leader>ca", vim.lsp.buf.code_action, "コードアクション")
    map("[d", function() vim.diagnostic.jump({ count = -1 }) end, "前の診断へ")
    map("]d", function() vim.diagnostic.jump({ count = 1 }) end, "次の診断へ")
  end,
})

-- ============================================================
-- サーバーの有効化 (定義は lsp/<name>.lua)
-- ============================================================
vim.lsp.enable({ "lua_ls", "kotlin_lsp", "gopls" })

-- LSP 作業進捗 ($/progress) を nvim-notify で表示する
require("lsp.progress")
