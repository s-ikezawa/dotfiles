-- =============================================================================
-- folke/which-key.nvim
-- =============================================================================
-- prefix キー (例: <leader>) を押した時点で「次に押せるキー + 説明」を
-- ポップアップ表示するキーマップガイド。
--
-- 仕組み:
--   - vim.keymap.set の `desc` を読んで自動的に項目化する
--   - which-key.add() で「グループ名」(<leader>f = find 等) を登録できる
--   - snacks.picker / snacks.toggle と連携 (アイコン・トグル状態の反映)
--
-- preset:
--   "classic" (古典的な下部表示) | "modern" (中央寄りカード) | "helix" (右下浮動)
--   ベースは "helix" のコンパクトな幅 (min=30 max=60) を活かしつつ、
--   win.col / win.row を上書きしてポップアップを画面中央に出す。
--   merge 順は defaults → preset → user opts (deep extend) なので、
--   ここでの win 指定は preset の win に上書きされる。
-- =============================================================================

local wk = require("which-key")

wk.setup({
  preset = "helix",
  -- ポップアップ表示までの遅延 (ms)。0 でも体感は十分速い
  delay = 200,
  -- 旧 vim 標準キー (foo, gx, etc.) のヘルプも統合
  spec = {},
  -- 下段の prefix breadcrumb は title と重複するので非表示
  show_keys = false,
  -- 下段の "<esc> close <bs> back" 行も非表示。
  -- 当該機能 (esc で閉じる / bs で戻る) は help 表示の有無と無関係に動くので
  -- UI から省いてもユーザー体験に支障なし。border の余白が綺麗に揃う。
  show_help = false,
  icons = {
    -- mini.icons (web-devicons mock 経由) を使う
    mappings = true,
    -- title の breadcrumb (例: "<Space>" + " > " + "find") に出るキーアイコン。
    -- which-key のデフォルトは Nerd Font の縦長グリフ (例: Space = "󱁐") なので、
    -- 1 セル高の border 線に重ねると天面が切れて見える。短い ASCII / シンボル
    -- に置き換えて、border + title でも収まるようにする。
    keys = {
      Space = "SPC ",
      Up    = "↑ ",
      Down  = "↓ ",
      Left  = "← ",
      Right = "→ ",
      CR    = "↵ ",
      NL    = "↵ ",
      Tab   = "⇥ ",
      Esc   = "ESC ",
      BS    = "⌫ ",
      C     = "C-",
      M     = "M-",
      D     = "D-",
      S     = "S-",
    },
  },
  -- ----- ポップアップの位置 -------------------------------------------------
  -- 0 = 上端/左端, 0.5 = 中央, -1 = 下端/右端 (1 未満の小数は画面比率)
  -- ディスプレイが大きい環境を想定して中央に固定する
  win = {
    col = 0.5,
    row = 0.5,
    -- helix の幅は 30-60 列でコンパクト、大画面でも視線移動が少ない
    width  = { min = 40, max = 80 },
    height = { min = 4,  max = 0.6 },
    -- title 内のキーアイコンを ASCII (SPC, ESC 等) に置き換えたので、
    -- rounded でも天面切れせず違和感なく表示できる
    border = "rounded",
    title = true,
    title_pos = "center",
  },
})

-- ----- カテゴリ (グループ名) の登録 ----------------------------------------
-- keymaps.lua のカテゴリ規約に対応:
--   <leader>f* = find / <leader>s* = search / <leader>l* = LSP /
--   <leader>a* = AI   / <leader>b* = buffer
-- グループ名はポップアップでカテゴリ見出しとして表示される。
wk.add({
  { "<leader>f",  group = "find"   },
  { "<leader>s",  group = "search" },
  { "<leader>l",  group = "LSP"    },
  { "<leader>lc", group = "calls (incoming/outgoing)" },
  { "<leader>a",  group = "AI (sidekick)" },
  { "<leader>b",  group = "buffer" },
})
