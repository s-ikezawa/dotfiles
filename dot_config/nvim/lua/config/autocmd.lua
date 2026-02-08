-- 外部でファイルが変更された場合に自動で再読み込みする
-- autoread だけでは不十分なため、checktime を定期的に発火させる
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = vim.api.nvim_create_augroup("auto_reload", { clear = true }),
  command = "checktime",
})

-- 最後の通常バッファを :q で閉じたとき、残っているターミナルや
-- ファイルエクスプローラーなどの補助ウィンドウも一緒に閉じる
vim.api.nvim_create_autocmd("QuitPre", {
  group = vim.api.nvim_create_augroup("auto_quit", { clear = true }),
  callback = function()
    local current_win = vim.api.nvim_get_current_win()
    local wins = vim.api.nvim_list_wins()
    local closeable_wins = {}
    for _, w in ipairs(wins) do
      if w ~= current_win then
        -- フローティングウィンドウは無視する
        local config = vim.api.nvim_win_get_config(w)
        if config.relative == "" then
          local buf = vim.api.nvim_win_get_buf(w)
          if vim.bo[buf].buftype == "" then
            -- 通常のファイルバッファがまだあるので何もしない
            return
          end
          table.insert(closeable_wins, w)
        end
      end
    end
    -- 残りは全て補助ウィンドウなので閉じる
    for _, w in ipairs(closeable_wins) do
      vim.api.nvim_win_close(w, true)
    end
  end,
})
