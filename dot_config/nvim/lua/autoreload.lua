-- ============================================================================
-- 外部変更の自動取り込み（AI エージェントがディスクに書いたファイルを反映）
-- ============================================================================
-- AI（Claude Code CLI など）は Neovim の外でファイルを書き換える。
-- autoread だけでは「フォーカス復帰 / カーソル静止」まで反映されないため、
-- それらのタイミングで :checktime を発火させて外部変更を取り込む。
--
-- tmux 別ペインで AI を動かす構成では、Neovim のペインに戻ったときに
-- FocusGained を受け取る必要がある。tmux 側で次の設定が必須:
--   set -g focus-events on
-- （updatetime は options.lua で 250ms に設定済み → CursorHold が速く効く）

vim.o.autoread = true -- 外部変更を検知したらバッファを再読込する

local grp = vim.api.nvim_create_augroup("auto_checktime", { clear = true })

-- フォーカス復帰 / バッファ移動 / カーソル静止時に外部変更をチェック
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = grp,
  callback = function()
    -- コマンドライン中は checktime しない（プロンプトを壊さないため）
    if vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

-- 外部変更で再読込されたら通知する
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = grp,
  callback = function()
    vim.notify("ファイルが外部で変更されたため再読込しました", vim.log.levels.WARN)
  end,
})
