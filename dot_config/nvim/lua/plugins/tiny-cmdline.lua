-- tiny-cmdline.nvim。ui2(lua/configs/ui2.lua)のコマンドラインのウィンドウを、: を押したとき
-- 画面中央のフロートに動かす。CmdlineEnter で中央に移し、CmdlineLeave で元の位置に戻す。
-- noice.nvim の代わり。noice は 2025-11 から更新が止まっていて、ui2 とは同時に使えない。
--
-- version を指定していないのは、リリースタグを打っていないため。既定ブランチを追う。
--
-- cmdheight = 0 を先に済ませておく必要があり、lua/configs/options.lua が plugins より先に
-- 読まれるので間に合う。枠は winborder("rounded")を引き継ぐ。
--
-- / と ? は既定の native_types で最下行のまま残る。ノーマルモードの / と ? は
-- searchbox(lua/plugins/searchbox.lua)に置き換えているので、ここに来るのはビジュアルモードや
-- d/foo のような使い方だけ。中央に寄せる設定(native_types = {})もあるが、検索の間だけ
-- cmdheight が 1 に戻って本文が 1 行ずれ、入力中の一致のハイライトも効かない
-- (tiny-cmdline の issue #6、Neovim の issue #36846。どちらも未解決)。
vim.pack.add({
  { src = "https://github.com/rachartier/tiny-cmdline.nvim" },
})

-- 枠の上辺の中央にタイトルを出す。入力の中身で変わり、ふつうは " CmdLine "、:lua なら " Lua "、
-- :! なら " Shell " など(tiny-cmdline の title.formats の既定)。searchbox の検索欄も同じ位置に
-- " Search " を出して、見た目を揃える(lua/plugins/searchbox.lua)。
-- 位置と幅は既定のまま(画面中央、幅は画面の 60% を 40〜80 列に収める)。searchbox はこの
-- config を読んで同じ場所に出す。
require("tiny-cmdline").setup({
  title = { enabled = true },
})
