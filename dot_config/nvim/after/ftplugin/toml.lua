-- TOML のファイルの設定。Neovim に同梱の ftplugin のあとに読まれる（after/）。

-- スペース 2 つでインデントする（TOML の整形ツール taplo の既定の indent_string。TOML の仕様には決まりがない）
require('config.indent').spaces(2)
