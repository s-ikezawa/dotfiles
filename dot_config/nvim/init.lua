-- Neovim のエントリポイント。ここには設定を書かず、読み込むだけにする。
--
--   lua/configs/  Neovim 自体の設定。テーマごとに 1 ファイル
--                 icons.lua だけは共通のアイコンの表で、ここでは読まず使う側が require する
--   lua/plugins/  プラグインごとの設定。1 プラグイン 1 ファイル
--
-- require("configs.xxx") は runtimepath 配下の lua/configs/xxx.lua を読む。
-- 読み込む順に依存があるものが出てきたら、この並びで調整する。
require("configs.provider")
require("configs.options")
require("configs.keymaps")
require("configs.diagnostic")
-- cmdheight = 0(configs.options)の後、tiny-cmdline より前に有効にする。
require("configs.ui2")

require("plugins.catppuccin")
require("plugins.tree-sitter-manager")
-- アイコンを使うプラグインより前に読む。
require("plugins.mini-icons")
require("plugins.fzf-lua")
require("plugins.render-markdown")
require("plugins.gitsigns")
require("plugins.statuscol")
require("plugins.incline")
require("plugins.tiny-cmdline")
require("plugins.searchbox")
require("plugins.csvview")
require("plugins.neo-tree")
