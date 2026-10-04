-- ui2。Neovim 0.12 で入った、メッセージとコマンドラインの新しい表示(:h ui2)。
-- まだ実験的な機能で、モジュール名も vim._core の下にある。0.13 以降で名前や挙動が
-- 変わったら合わせる。
--
-- cmdheight = 0(lua/configs/options.lua)と組み合わせて使う。
--   - 「Press ENTER」で止まらなくなり、長い出力は pager(バッファ)で開く。:messages と g< も pager。
--   - msg.targets = "msg" で、メッセージをコマンドラインではなく右下の一時的なウィンドウに出す。
--     既定の "cmd" はコマンドラインの行に出すので、cmdheight = 0 だと見えない。
--     右下のウィンドウは msg.msg.timeout(既定 4000ms)で消える。
-- : のコマンドラインを中央のフロートにするのは tiny-cmdline(lua/plugins/tiny-cmdline.lua)。
require("vim._core.ui2").enable({
  msg = { targets = "msg" },
})
