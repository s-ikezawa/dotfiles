-- Kotlin のファイルの設定。Neovim に同梱の ftplugin のあとに読まれる（after/）。

-- スペース 4 つでインデントする（Kotlin の公式のコーディング規約「Use four spaces for indentation. Do not use tabs.」と、
-- Google の Android Kotlin スタイルガイド）
require('config.indent').spaces(4)
