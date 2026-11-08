-- シェルスクリプト（sh）のファイルの設定。Neovim に同梱の ftplugin のあとに読まれる（after/）。

-- スペース 2 つでインデントする（Google の Shell Style Guide「Indent 2 spaces. No tabs.」。
-- 例外は、<<- のヒアドキュメントの本文だけタブを使うこと）
require('config.indent').spaces(2)
