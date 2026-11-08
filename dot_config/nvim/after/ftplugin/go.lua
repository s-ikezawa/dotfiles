-- Go のファイルの設定。Neovim に同梱の ftplugin のあとに読まれる（after/）。

-- タブでインデントする（Effective Go「We use tabs for indentation and gofmt emits them by default.」。
-- 同梱の ftplugin も同じ設定をする）。タブの表示幅は決まりがないので、VS Code の Go と同じ 4 桁にする
require('config.indent').tabs(4)
