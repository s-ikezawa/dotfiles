-- Makefile のファイルの設定。Neovim に同梱の ftplugin のあとに読まれる（after/）。

-- タブでインデントする。GNU make のマニュアルのとおり、レシピ（コマンドの行）の先頭はタブでないと動かない
-- （.RECIPEPREFIX で変えられるが、ふつうは変えない）。タブの表示幅は Go とそろえて 4 桁にする
require('config.indent').tabs(4)
