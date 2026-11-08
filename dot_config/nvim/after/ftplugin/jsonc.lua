-- JSON with Comments（tsconfig.json・.luarc.jsonc など）のファイルの設定。Neovim に同梱の ftplugin のあとに読まれる（after/）。

-- スペース 2 つでインデントする（Prettier の既定。JSON とそろえる）
require('config.indent').spaces(2)
