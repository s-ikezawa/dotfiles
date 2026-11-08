-- YAML のファイルの設定。Neovim に同梱の ftplugin のあとに読まれる（after/）。

-- スペース 2 つでインデントする。YAML の仕様（1.2.2）ではインデントにタブを使えず、幅は決まっていないので、
-- Prettier の既定の 2 にする
require('config.indent').spaces(2)
