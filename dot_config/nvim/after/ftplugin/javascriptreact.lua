-- JavaScript（JSX）のファイルの設定。Neovim に同梱の ftplugin のあとに読まれる（after/）。

-- スペース 2 つでインデントする（Google の JavaScript スタイルガイドと Prettier の既定。タブは使わない）
require('config.indent').spaces(2)
