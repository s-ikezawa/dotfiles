local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ============================================================================
-- 最後の通常バッファを閉じたら全ウィンドウを終了
-- ============================================================================

augroup("quit_all_on_last_editor", { clear = true })

autocmd("QuitPre", {
  group = "quit_all_on_last_editor",
  callback = function()
    -- 閉じようとしているウィンドウを除き、通常バッファのウィンドウが残るか確認
    local current_win = vim.api.nvim_get_current_win()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if win ~= current_win and vim.api.nvim_win_is_valid(win) then
        local buf = vim.api.nvim_win_get_buf(win)
        local bt = vim.bo[buf].buftype
        -- buftype が空のウィンドウは通常のエディターバッファ
        if bt == "" then
          return
        end
      end
    end
    -- 通常バッファが残らないので全て閉じる
    vim.cmd("qall")
  end,
  desc = "最後の通常バッファを閉じる時に補助ウィンドウも一緒に終了",
})

-- ============================================================================
-- 外部変更の自動検知 (Claude Code などの外部ツールによる編集を反映)
-- ============================================================================

augroup("auto_reload", { clear = true })

-- Neovim にフォーカスが戻った時、またはバッファに入った時にファイル変更をチェック
autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  group = "auto_reload",
  command = "checktime",
  desc = "外部でファイルが変更された場合に自動で再読み込み",
})

-- 外部 git 操作後に Snacks Explorer の git ステータスキャッシュをリフレッシュ
-- FocusGained: 外部ターミナルから戻った時
-- TermLeave: Neovim 内のターミナルモードから離れた時 (Claude Code 等から戻る)
autocmd({ "FocusGained", "TermLeave" }, {
  group = "auto_reload",
  callback = function()
    local ok, Git = pcall(require, "snacks.explorer.git")
    if ok then
      Git.refresh(vim.fn.getcwd())
      require("snacks.explorer.watch").refresh()
    end
  end,
  desc = "外部 git 操作後に Explorer の git ステータスをリフレッシュ",
})
