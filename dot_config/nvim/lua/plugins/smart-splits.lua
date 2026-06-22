-- ============================================================================
-- smart-splits.nvim（nvim ウィンドウ ⇄ tmux ペインのシームレス移動 / リサイズ）
-- ============================================================================
-- tmux の M-hjkl（ペイン移動）/ M-S-HJKL（リサイズ）と同じキーで nvim 内の
-- ウィンドウも操作できるようにし、tmux と操作感を統一する。nvim の端のウィンドウ
-- まで来たら、自動で隣の tmux ペインへ越境する（全体を 1 つのグリッドとして扱える）。
--
-- 連携には tmux.conf 側の vim-aware 化が必須：フォーカス中のペインが (n)vim なら
-- M-hjkl / M-S-HJKL を内側へ素通しさせ、ここの smart-splits に処理させる。
-- 端で nvim にウィンドウが無い方向は、smart-splits が `tmux select-pane` を実行して
-- ペインを移る。判定（is_vim）と if-shell の設定は ~/.config/tmux/tmux.conf を参照。

local ss = require("smart-splits")

ss.setup({
  -- nvim の端で、その方向に tmux ペインも無い場合の挙動。
  -- "stop" = その場で止まる（"wrap" の反対端ワープは混乱するため使わない）。
  -- 端に tmux ペインがある場合は at_edge より優先して tmux 側へ越境する。
  at_edge = "stop",
  -- multiplexer は $TMUX から自動検出（tmux）。明示指定も可能だが既定の auto に任せる。
})

-- normal + terminal の両モードに割り当てる。terminal モードでも先にここで横取りするので、
-- ターミナルウィンドウ（:terminal 等）からも M-hjkl で抜けられる。
local map = vim.keymap.set

-- 移動（tmux の `bind -n M-hjkl select-pane` と同じキー）
map({ "n", "t" }, "<M-h>", ss.move_cursor_left,  { desc = "smart-splits: 左のウィンドウ/ペインへ" })
map({ "n", "t" }, "<M-j>", ss.move_cursor_down,  { desc = "smart-splits: 下のウィンドウ/ペインへ" })
map({ "n", "t" }, "<M-k>", ss.move_cursor_up,    { desc = "smart-splits: 上のウィンドウ/ペインへ" })
map({ "n", "t" }, "<M-l>", ss.move_cursor_right, { desc = "smart-splits: 右のウィンドウ/ペインへ" })

-- リサイズ（tmux の `bind -n M-S-HJKL resize-pane` と同じキー。量は smart-splits 既定）
map({ "n", "t" }, "<M-H>", ss.resize_left,  { desc = "smart-splits: 左へリサイズ" })
map({ "n", "t" }, "<M-J>", ss.resize_down,  { desc = "smart-splits: 下へリサイズ" })
map({ "n", "t" }, "<M-K>", ss.resize_up,    { desc = "smart-splits: 上へリサイズ" })
map({ "n", "t" }, "<M-L>", ss.resize_right, { desc = "smart-splits: 右へリサイズ" })
