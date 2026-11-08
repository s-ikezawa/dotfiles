-- git の設定ファイル（.gitconfig など）の設定。Neovim に同梱の ftplugin のあとに読まれる（after/）。

-- タブでインデントする（git config コマンドがキーの行の先頭にタブを書き込むので、それとそろえる）。
-- タブの表示幅は Go とそろえて 4 桁にする
require('config.indent').tabs(4)
