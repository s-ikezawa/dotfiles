-- Neovim の設定。chezmoi が ~/.config/nvim/ として配置する。
-- Neovim は元から XDG に従うので、.zshenv 側で置き場を指定する必要はない。
--
--   lua/configs/  Neovim 本体の設定
--   lua/plugins/  プラグインごとの vim.pack.add() と設定
--
-- 読み込み順はこの 1 ファイルに並べる。zsh でプラグインマネージャを使わず
-- .zshrc に直接 source しているのと同じ理由で、順序が各ファイルへ散ると
-- 追えなくなるため。
--
-- options を最初に読む。<leader> はキーマップの定義時に評価されるので、
-- keymaps より前に決まっていないと、<leader> を含む定義が別のキーに付く。

require("configs.options")
require("configs.providers")
require("configs.keymaps")
require("configs.autocmds")

require("plugins.catppuccin")
