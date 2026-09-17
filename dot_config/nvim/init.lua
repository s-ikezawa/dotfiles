-- Neovim のエントリポイント。ここには設定を書かず、読み込むだけにする。
--
--   lua/configs/  Neovim 自体の設定。テーマごとに 1 ファイル
--   lua/plugins/  プラグインごとの設定。1 プラグイン 1 ファイル
--
-- require("configs.xxx") は runtimepath 配下の lua/configs/xxx.lua を読む。
-- 読み込む順に依存があるものが出てきたら、この並びで調整する。
require("configs.provider")
