-- Lua のファイルの設定。Neovim に同梱の ftplugin のあとに読まれる（after/）。

-- スペース 2 つでインデントする（Neovim 本体の .stylua.toml の indent_width = 2 と同じ。この設定の書き方もこれ）。
-- Lua には Google のスタイルガイドがなく、整形ツール StyLua の既定はタブなので、Neovim に合わせる
require('config.indent').spaces(2)
