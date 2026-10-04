-- statuscol.nvim。行番号まわりの列('statuscolumn')を組み立てる。
-- VSCode のように、診断の印を行番号の左、Git の変更の印を行番号の右に分けて出す。
-- 既定のサインカラムは 1 列で、診断と gitsigns の印が同じ行にあると片方しか見えなかった。
--
-- version を指定していないのは、リリースタグを打っていないため。既定ブランチを追う。
vim.pack.add({
  { src = "https://github.com/luukvbaal/statuscol.nvim" },
})

-- 印はどの名前空間(extmark の namespace)に置かれたかで振り分ける。パターンは Lua のパターン。
--   診断  Neovim 0.12 では nvim.<名前>.diagnostic.signs という名前空間に置かれる。README と
--         :h statuscol の例にある 'diagnostic/signs' は古い名前で、0.12 では一致しない
--         (ドキュメントの修正は issue #171 で未対応。本体のクリック処理は diagnostic.signs で見ている)。
--   Git   gitsigns は gitsigns_signs_(ステージ済みの分は gitsigns_signs_staged)に置く。
-- どちらの名前も、印を置いたバッファで nvim_get_namespaces() を引いて確認した(0.12.5)。
-- ここに挙げていない名前空間の印は出ない。印を出すプラグインを増やしたら、ここにも足す。
--
-- 印が無い行も幅は空けたまま(auto = false が既定)にして、印が出た瞬間に本文がずれないようにする。
-- 列全体の幅は 'signcolumn' と 'numberwidth' にも従う(:h 'statuscolumn')。signcolumn = "yes" の
-- ままにしておけば、印の有無で幅が変わらない(lua/configs/options.lua)。
--
-- 各セグメントに click を書くとクリックで動くようになるが、付けない。組み込みの処理には
-- 行番号の右クリックで貼り付け・右ダブルクリックで行削除、Git の印の中クリックで変更の取り消し
-- (reset_hunk)・右クリックでステージがあり、誤クリックで内容が変わる(statuscol/builtin.lua)。
local builtin = require("statuscol.builtin")
require("statuscol").setup({
  -- relativenumber のとき、カーソル行の(絶対)行番号もほかの行と同じく右に寄せる。
  relculright = true,
  segments = {
    -- 診断の印。1 行に複数あっても、幅 2 セルに 1 つだけ出す。
    { sign = { namespace = { "diagnostic%.signs" }, maxwidth = 1, colwidth = 2 } },
    -- 行番号と、Git の印との間の空白。
    { text = { builtin.lnumfunc, " " } },
    -- Git の変更の印(gitsigns の ┃ など)。幅 2 セルで、印と本文の間を 1 セル空ける。
    { sign = { namespace = { "gitsigns" }, maxwidth = 1, colwidth = 2 } },
  },
})
