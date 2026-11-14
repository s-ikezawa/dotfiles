-- Rex の設定（~/.config/rex/init.lua）。
-- Rex はファイルの変更を見張らないので、書き換えたら `rex config reload` で読み直す。
-- 反映する前に `rex config check` で書き間違いがないか確かめられる。
-- ドキュメント: https://www.superlogical.com/rex/docs/customize/config
--
-- フォント・テーマ・Option キーは init.lua では設定できないため、
-- mise の [bootstrap.macos.defaults."com.superlogical.rex"] で管理している。

--------------------------------------------------------------------------------
-- herdr（~/.config/herdr/config.toml）と同じ tmux 風のキー
--------------------------------------------------------------------------------
local prefix = "ctrl+a"

-- prefix を 2 回押すと Ctrl+A をターミナルに送る（zsh の行頭移動のため）。
-- prefix で始まるキーシーケンスがあると、Ctrl+A 単独はターミナルに届かなくなる。
rex.bind(prefix .. ">ctrl+a", "pane.send_key", { key = "ctrl+a" })

-- | で左右に分割（縦の境界線）、- で上下に分割（横の境界線）。
-- Rex は Shift を押さない側の文字で照合するので、| は shift+\ と書く。
rex.bind(prefix .. ">shift+\\", "pane.split.right")
rex.bind(prefix .. ">-", "pane.split.down")

-- h/j/k/l でペインを移動する（herdr の初期設定と同じ）。
rex.bind(prefix .. ">h", "pane.focus.left")
rex.bind(prefix .. ">j", "pane.focus.down")
rex.bind(prefix .. ">k", "pane.focus.up")
rex.bind(prefix .. ">l", "pane.focus.right")

-- tmux と同じく、, でタブ（tmux の window）、$ でセッションの名前を変える。
-- $ は Shift を押さない側の文字で shift+4 と書く（| を shift+\ と書くのと同じ）。
rex.bind(prefix .. ">,", "client.tab.rename")
rex.bind(prefix .. ">shift+4", "session.rename")

-- herdr のナビゲートモード（prefix+w）に当たるもの。Esc で抜ける。
-- herdr と同じく j/k を Spaces（Rex ではセッション）の移動に使い、h/l はペインの左右移動にする。
-- exclusive にして、モード中にほかのキーがターミナルへ入力されないようにする。
rex.mode("navigate", { exclusive = true })
rex.bind(prefix .. ">w", "client.mode.enter", { name = "navigate" })
rex.bind("navigate/j", "session.next")
rex.bind("navigate/k", "session.previous")
rex.bind("navigate/h", "pane.focus.left")
rex.bind("navigate/l", "pane.focus.right")

-- リサイズモード（prefix+r）。h/j/k/l で境界線をその向きに 5% ずつ動かし、= で均等に戻す。Esc で抜ける。
-- 何度も続けて押すので、prefix を毎回押さずに済むようモードにしている。
rex.mode("resize", { exclusive = true })
rex.bind(prefix .. ">r", "client.mode.enter", { name = "resize" })
rex.bind("resize/h", "pane.resize", { direction = "left" })
rex.bind("resize/j", "pane.resize", { direction = "down" })
rex.bind("resize/k", "pane.resize", { direction = "up" })
rex.bind("resize/l", "pane.resize", { direction = "right" })
rex.bind("resize/=", "pane.balance")
