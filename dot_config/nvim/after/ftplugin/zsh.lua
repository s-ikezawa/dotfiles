-- zsh のスクリプト（.zshrc など）のファイルの設定。Neovim に同梱の ftplugin のあとに読まれる（after/）。

-- スペース 2 つでインデントする。zsh のスタイルガイドはないので、Google の Shell Style Guide（bash 向け）の
-- 「Indent 2 spaces. No tabs.」に合わせ、ほかのシェルスクリプトとそろえる
require('config.indent').spaces(2)
