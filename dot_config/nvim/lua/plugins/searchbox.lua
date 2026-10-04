-- searchbox.nvim。ノーマルモードの / と ? を、フロートの検索欄に置き換える。
-- 入力に合わせて一番近い一致へカーソルを動かす(incsearch)。確定すると検索レジスタ(@/)に
-- 入るので、n / N、:s//置換後/、cgn は普段どおり使える。
--
-- 標準の / は cmdheight = 0 だとコマンドラインの行を出すために cmdheight を 1 に戻し、
-- 本文が 1 行ずれる(lua/plugins/tiny-cmdline.lua)。searchbox はコマンドラインを使わないので
-- ずれない。
--
-- 検索欄は nui.nvim のフロートで出す。nui.nvim は 0.4.0(2025-05)の後も main に修正が
-- 入っているので、searchbox(タグなし)と同じく既定ブランチを追う。
vim.pack.add({
  { src = "https://github.com/MunifTanjim/nui.nvim" },
  { src = "https://github.com/VonHeikemen/searchbox.nvim" },
})

-- 検索欄は : のフロート(tiny-cmdline)と同じ場所・幅・見た目で出す。場所が違うと目が迷う。
--   - タイトルは tiny-cmdline と同じく枠の上辺の中央に " Search " と出す(下の title)。
--   - プロンプトを / と ? にして、: のフロートの「:echo …」と同じ見え方にする。
--   - 色は tiny-cmdline のハイライトグループに揃える。
-- 中央に置くので、カーソルが動いた先の一致がちょうど検索欄の裏に来ると隠れる。
require("searchbox").setup({
  popup = {
    border = { style = "rounded", text = { top_align = "center" } },
    win_options = {
      winhighlight = "Normal:TinyCmdlineNormal,FloatBorder:TinyCmdlineBorder,FloatTitle:TinyCmdlineTitle",
    },
  },
})

-- tiny-cmdline の geometry() と同じ計算で、位置と枠の内側の幅を出す。
-- 幅は画面の 60%(40〜80 列に収める)、位置は上下左右の中央(既定の設定。tiny-cmdline の
-- config から読むので、そちらを変えればこちらも追従する)。画面の大きさは開くたびに読む。
-- tiny-cmdline の位置は枠を含めた左上だが、nui は渡された位置を枠の内側の左上として扱い、
-- 枠はその 1 セル外に別のウィンドウで描く(nvim_win_get_position で確認した)。そのため枠の分を足す。
local function center_opts(opts)
  local cfg = require("tiny-cmdline").config
  local function dimension(value, available)
    if type(value) == "string" then
      return math.floor(available * tonumber(value:match("^(%d+)%%$")) / 100)
    end
    return math.floor(value)
  end
  local cols, lines = vim.o.columns, vim.o.lines
  local border = 1
  local width = math.max(cfg.width.min, math.min(cfg.width.max, dimension(cfg.width.value, cols)))
  width = math.min(width, cols - border * 2)
  return vim.tbl_extend("force", opts, {
    -- title は毎回渡す。タイトルを空にして試したところ、2 回目に開いたとき
    -- 「E5108: Lua: stack overflow」(vim.tbl_deep_extend の再帰)になった。title を渡すと
    -- searchbox は枠の表を毎回作り直すが、渡さないと setup() の popup.border の表をそのまま nui に
    -- 渡す。nui がその表に自分への参照を書き込み、次の合成で循環するためと考えられる。
    title = " Search ",
    position_relative = "editor",
    position_y = math.max(0, dimension(cfg.position.y, lines - 1 - border * 2)) + border,
    position_x = math.max(0, dimension(cfg.position.x, cols - width - border * 2)) + border,
    -- searchbox は文字列のときだけ幅を受け取る(数字の文字列は nui が数として読む)。
    window_width = tostring(width),
  })
end

-- 置き換えるのはノーマルモードだけ。ビジュアルモードの / や d/foo のような使い方は
-- 標準の検索のまま(tiny-cmdline の native_types で最下行に出る)。
--
-- / の後のキーがすでに届いているとき(マクロの再生や、/foo<CR> をまとめて流し込んだとき)は
-- searchbox を開かず、標準の / に任せる。searchbox は検索欄を開いて入力を受け付けるまでに
-- 間があり、その間に届いたキーが本文に書き込まれる(間を空けずに /line2 を送ると、本文の先頭に
-- line2 と入った。1 文字ずつ 20ms 以上空ければ検索欄に入る)。
-- getchar(1) はキーを消費せずに、未処理のキーがあるかだけを見る。標準の / は nvim_feedkeys の
-- "i" で、残っているキーより前に差し込む("n" で、この割り当て自身を呼び直さない)。
local function search(key, opts)
  return function()
    if vim.fn.reg_executing() ~= "" or vim.fn.getchar(1) ~= 0 then
      vim.api.nvim_feedkeys(key, "in", false)
      return
    end
    require("searchbox").incsearch(center_opts(opts))
  end
end
vim.keymap.set("n", "/", search("/", { prompt = "/" }), { desc = "searchbox: 前方に検索" })
vim.keymap.set("n", "?", search("?", { prompt = "?", reverse = true }), { desc = "searchbox: 後方に検索" })
