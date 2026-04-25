-- =============================================================================
-- Keymaps
-- =============================================================================
-- :help vim.keymap.set
-- 第 1 引数 mode: 'n'(normal) 'i'(insert) 'v'(visual+select) 'x'(visual)
--                 's'(select) 't'(terminal) 'c'(command) ''(normal+visual+op)
--
-- leader キー自体は init.lua で設定 (require より前に確定させる必要があるため)
-- =============================================================================

local map = vim.keymap.set

-- =============================================================================
-- 汎用 (プラグイン非依存)
-- =============================================================================

-- 検索ハイライトを <Esc> で解除
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "検索ハイライトを解除" })

-- ----- ウィンドウ移動 -------------------------------------------------------
-- Ctrl+hjkl で隣のウィンドウに移動 (<C-w>hjkl の短縮)
map("n", "<C-h>", "<C-w>h", { desc = "左のウィンドウへ移動" })
map("n", "<C-j>", "<C-w>j", { desc = "下のウィンドウへ移動" })
map("n", "<C-k>", "<C-w>k", { desc = "上のウィンドウへ移動" })
map("n", "<C-l>", "<C-w>l", { desc = "右のウィンドウへ移動" })

-- ----- バッファ移動 ---------------------------------------------------------
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "前のバッファへ" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "次のバッファへ" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "バッファを閉じる" })

-- ----- 編集系 ---------------------------------------------------------------
-- visual モードで選択行を上下移動 (J/K で選択ブロックごと動かす)
-- :m '>+1 で選択末尾の次の行へ移動、gv=gv で再選択 + 自動インデント
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "選択行を下へ移動" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "選択行を上へ移動" })

-- インデント操作後も選択を保持する (連続インデントを楽にする)
map("v", "<", "<gv", { desc = "左インデント (選択維持)" })
map("v", ">", ">gv", { desc = "右インデント (選択維持)" })

-- ----- 視認性向上 -----------------------------------------------------------
-- 検索ジャンプ後にカーソルを画面中央へ寄せる
map("n", "n", "nzzzv", { desc = "次の検索結果 (中央寄せ)" })
map("n", "N", "Nzzzv", { desc = "前の検索結果 (中央寄せ)" })

-- 半画面スクロール後にカーソルを画面中央へ寄せる
map("n", "<C-d>", "<C-d>zz", { desc = "半画面下スクロール (中央寄せ)" })
map("n", "<C-u>", "<C-u>zz", { desc = "半画面上スクロール (中央寄せ)" })

-- ----- ファイル操作 ---------------------------------------------------------
map("n", "<leader>w", "<cmd>write<CR>", { desc = "ファイル保存" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "ウィンドウを閉じる" })
map("n", "<leader>Q", "<cmd>quitall<CR>", { desc = "Neovim 終了" })

-- ----- ターミナル -----------------------------------------------------------
-- terminal mode から normal mode へ抜ける (<C-\><C-n> の短縮)
-- sidekick の CLI バッファでは normal mode に入ると自動で scrollback が開く
map("t", "<C-q>", [[<C-\><C-n>]], { desc = "Terminal: Normal mode へ抜ける" })

-- =============================================================================
-- Snacks Picker (Telescope 相当)
-- =============================================================================
-- LazyVim 流のカテゴリ分け:
--   <leader>f* = find   (ファイル/バッファ/履歴を探す)
--   <leader>s* = search (grep / 診断 一覧)
--   <leader>g* = git    (将来)
--   <leader>l* = LSP    (snacks picker 経由の各種クエリ)
--   <leader>a* = AI     (sidekick.nvim, 後段セクション)
--
-- 各 picker は遅延的にラップして、起動時の require コストを避ける

local picker = function(name, opts)
  return function() require("snacks").picker[name](opts) end
end

-- ----- Find (ファイル/バッファ系) -------------------------------------------
-- LazyVim 流の "smart" は recent + buffers + files をフレーシー順で混ぜたピッカー
map("n", "<leader><space>", picker("smart"), { desc = "Find: smart (recent+buffers+files)" })
map("n", "<leader>ff", picker("files"), { desc = "Find: files" })
map("n", "<leader>fb", picker("buffers"), { desc = "Find: buffers" })
map("n", "<leader>fr", picker("recent"), { desc = "Find: recent files" })
map("n", "<leader>fc", picker("files", { cwd = vim.fn.stdpath("config") }),
  { desc = "Find: Neovim 設定ファイル" })
map("n", "<leader>fh", picker("help"), { desc = "Find: ヘルプタグ" })
map("n", "<leader>fk", picker("keymaps"), { desc = "Find: キーマップ" })

-- バッファ即時オープン (LazyVim と同じ <leader>,)
map("n", "<leader>,", picker("buffers"), { desc = "Buffers" })

-- ----- Search (grep 系) ------------------------------------------------------
-- ワークスペース全体に対する live grep
map("n", "<leader>/", picker("grep"), { desc = "Grep (workspace)" })
map("n", "<leader>sg", picker("grep"), { desc = "Search: grep (workspace)" })

-- 現在開いているバッファの行内検索
map("n", "<leader>sb", picker("lines"), { desc = "Search: 現在のバッファ行" })

-- カーソル下の単語をワークスペースから検索
map({ "n", "x" }, "<leader>sw", picker("grep_word"),
  { desc = "Search: カーソル下の単語" })

-- 診断 (LSP/linter) の一覧。workspace 全体 / 現在バッファのみ
map("n", "<leader>sd", picker("diagnostics"), { desc = "Search: 診断 (workspace)" })
map("n", "<leader>sD", picker("diagnostics_buffer"), { desc = "Search: 診断 (buffer)" })

-- ----- LSP (snacks picker 経由) ---------------------------------------------
-- vim.lsp.buf.* の結果を quickfix に流す代わりに snacks picker で一覧する。
-- LSP が attach されていなければ "no results" になるだけなのでグローバルでよい。
-- 単一結果の場合 picker は自動でジャンプする (jump_one_result の挙動)。
map("n", "<leader>ld", picker("lsp_definitions"),       { desc = "LSP: 定義へ" })
map("n", "<leader>lD", picker("lsp_declarations"),      { desc = "LSP: 宣言へ" })
map("n", "<leader>lr", picker("lsp_references"),        { desc = "LSP: 参照" })
map("n", "<leader>li", picker("lsp_implementations"),   { desc = "LSP: 実装" })
map("n", "<leader>ly", picker("lsp_type_definitions"),  { desc = "LSP: 型定義" })
map("n", "<leader>ls", picker("lsp_symbols"),           { desc = "LSP: ドキュメントシンボル" })
map("n", "<leader>lS", picker("lsp_workspace_symbols"), { desc = "LSP: ワークスペースシンボル" })
map("n", "<leader>lci", picker("lsp_incoming_calls"),   { desc = "LSP: 呼び出し元 (incoming)" })
map("n", "<leader>lco", picker("lsp_outgoing_calls"),   { desc = "LSP: 呼び出し先 (outgoing)" })

-- ----- 履歴 -----------------------------------------------------------------
map("n", "<leader>:", picker("command_history"), { desc = "Command history" })

-- =============================================================================
-- AI (sidekick.nvim)
-- =============================================================================
-- Claude Code / Gemini / Codex / Grok など各種 AI CLI を統一 UI で扱う。
-- API キーは使わず CLI 経由のサブスクリプション利用が前提。

local sidekick_cli = function(fn, opts)
  return function() require("sidekick.cli")[fn](opts) end
end

map({ "n", "v" }, "<leader>aa", sidekick_cli("toggle"),
  { desc = "AI: 直前の CLI をトグル" })
map({ "n", "v" }, "<leader>as", sidekick_cli("select"),
  { desc = "AI: CLI を選択して開く" })
map({ "n", "v" }, "<leader>ap", sidekick_cli("select_prompt"),
  { desc = "AI: Prompt Library から実行" })
map({ "n", "v" }, "<leader>aA", sidekick_cli("ask"),
  { desc = "AI: プロンプトを入力して送信" })
map("v",          "<leader>av", sidekick_cli("send"),
  { desc = "AI: 選択範囲を CLI に送信" })
map({ "n", "v" }, "<leader>af", sidekick_cli("focus"),
  { desc = "AI: 既存 CLI にフォーカス" })
map({ "n", "v" }, "<leader>ax", sidekick_cli("close"),
  { desc = "AI: CLI を閉じる" })

-- Claude Code を直接トグル (常用なので専用ショートカット)
map({ "n", "v" }, "<leader>ac",
  function() require("sidekick.cli").toggle({ name = "claude" }) end,
  { desc = "AI: Claude Code をトグル" })

-- 現在の file:line:col を CLI のプロンプトに挿入する (送信せず入力欄に置く)
-- sidekick の Context プレースホルダ: {position}, {file}, {line}, {selection},
--   {buffers}, {diagnostics}, {quickfix}, {function}, {class} など
map("n", "<leader>al", function()
  require("sidekick.cli").send({ msg = "{position} " })
end, { desc = "AI: 現在の file:line を CLI に挿入" })

-- ファイル参照のみを送信したい場合
map("n", "<leader>aL", function()
  require("sidekick.cli").send({ msg = "{file} " })
end, { desc = "AI: 現在のファイル名だけを CLI に挿入" })
