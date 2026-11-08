-- JSON のファイルの設定。Neovim に同梱の ftplugin のあとに読まれる（after/）。

-- スペース 2 つでインデントする（Prettier の既定。npm が書く package.json も 2。
-- JSON の仕様と Google のガイドには、インデントの決まりがない）
require('config.indent').spaces(2)
