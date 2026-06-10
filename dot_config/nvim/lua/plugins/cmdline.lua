-- ~/.config/nvim/lua/plugins/cmdline.lua
-- コマンドライン (tiny-cmdline) + 通知 (nvim-notify)
-- =============================================================================
-- rachartier/tiny-cmdline.nvim:
--   Neovim 0.12 標準の ui2 システムを使い、コマンドライン入力を画面中央の
--   フローティングウィンドウに表示する。nui.nvim 等の依存は不要。
--   利用には ui2 の有効化と cmdheight=0 が必須(cmdheight は options.lua で設定済み)。
--
-- rcarriga/nvim-notify:
--   vim.notify をリッチなトースト風 UI に置き換える。tiny-cmdline は一般
--   メッセージ/通知を扱わないため、通知系はこちらが担当する。
--
-- 詳細: https://github.com/rachartier/tiny-cmdline.nvim
--       https://github.com/rcarriga/nvim-notify
-- =============================================================================

-- ui2 (0.12 のネイティブ UI 拡張) を有効化する。tiny-cmdline の前提。
require("vim._core.ui2").enable({})

require("tiny-cmdline").setup({
  width = {
    value = "60%", -- "N%"(画面幅に対する割合)または整数(絶対カラム数)
    min = 40,      -- 最小幅
    max = 80,      -- 最大幅
  },
  position = {
    x = "50%", -- 水平位置(0%=左 / 50%=中央 / 100%=右)
    y = "50%", -- 垂直位置(0%=上 / 50%=中央 / 100%=下)
  },
})

-- vim.notify を nvim-notify に差し替える
local notify = require("notify")
notify.setup({
  stages = "fade",       -- 通知の表示/消去アニメーション
  timeout = 3000,        -- 通知の表示時間(ms)
  render = "compact",    -- コンパクトな表示スタイル
  top_down = true,       -- 画面上から下へ積む(右上に表示)
})
vim.notify = notify
