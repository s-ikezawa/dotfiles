-- TypeScript（TSX）のファイルの設定。Neovim に同梱の ftplugin のあとに読まれる（after/）。

-- スペース 2 つでインデントする（Google の JavaScript スタイルガイドと Prettier の既定。
-- Google の TypeScript スタイルガイドは幅を決めず、整形ツールに任せている）
require('config.indent').spaces(2)
