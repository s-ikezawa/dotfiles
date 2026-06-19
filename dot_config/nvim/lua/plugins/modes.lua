-- ============================================================================
-- modes.nvim - 現在のモードに応じて cursorline / 行番号を色付けする
-- https://github.com/mvllow/modes.nvim
-- ============================================================================
-- 挿入=緑 / ビジュアル=紫 / コピー(yank)=黄 / 削除=赤 のように、
-- モードを色で即座に判別できる。ステータスラインを非表示(laststatus=0)にし
-- showmode=false でモード文字も出さないこの構成では、モードの可視化を担う。
-- 依存: cursorline・termguicolors（options.lua で有効化済み）

-- 色は catppuccin の mocha パレットから取得し、テーマと配色を揃える。
-- （ハードコードせず get_palette を使うことで flavour 変更にも追従できる）
local mocha = require("catppuccin.palettes").get_palette("mocha")

require("modes").setup({
  -- モードごとの色を mocha のアクセントカラーに割り当てる
  colors = {
    insert  = mocha.green,  -- 挿入: 緑
    visual  = mocha.mauve,  -- ビジュアル: 紫
    copy    = mocha.yellow, -- コピー(yank): 黄
    delete  = mocha.red,    -- 削除: 赤
    replace = mocha.peach,  -- 置換: オレンジ
  },
  -- 行全体のハイライト濃度（0=透明〜1=不透明）。読む用途で主張しすぎないよう控えめに。
  line_opacity = 0.2,
  set_cursor = true,     -- カーソル自体の色もモード色に追従させる
  set_cursorline = true, -- cursorline をモード色で塗る
  set_number = true,     -- 現在行の行番号もモード色にする
})
