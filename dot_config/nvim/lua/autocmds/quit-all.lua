-- ============================================================================
-- 最後のメインエディターで :q したら Neovim ごと終了する
-- ============================================================================
-- メインのエディター（通常ファイルを表示する非フロートウィンドウ）が 1 つだけで、
-- それ以外にエクスプローラーやターミナルなどの補助ウィンドウが開いている状態で
-- そのエディターを :q すると、通常は補助ウィンドウだけが取り残されてしまう。
-- そこで補助ウィンドウを先に閉じ、保留中の :q を「最後の 1 ウィンドウ」に効かせて
-- Neovim 自体を終了させる（このnvimは AI 変更レビュー用で基本シングルタブ運用）。

-- カレントタブの「メインエディター」かどうか。
-- buftype が空 = 通常ファイルバッファ。snacks 製ウィンドウ（エクスプローラー/ピッカー等）は
-- buftype=nofile、ターミナルは buftype=terminal なので、これで補助ウィンドウを除外できる。
-- フロート（which-key / noice / hover など一時 UI）も数えない。
local function is_editor_win(win)
  if vim.api.nvim_win_get_config(win).relative ~= "" then
    return false -- フロートは対象外
  end
  local buf = vim.api.nvim_win_get_buf(win)
  if vim.bo[buf].buftype ~= "" then
    return false -- terminal / nofile / quickfix / help など補助バッファ
  end
  -- 念のため snacks 系の特殊 filetype は明示的に除外（buftype が空でも保険）
  return not vim.startswith(vim.bo[buf].filetype, "snacks_")
end

-- フロート以外の補助ウィンドウ（エクスプローラー / ターミナル / quickfix 等）か。
local function is_aux_split(win)
  return vim.api.nvim_win_get_config(win).relative == "" and not is_editor_win(win)
end

-- QuitPre は :q / :wq / :q! / ZZ などの実行直前に発火する（nvim_win_close では発火しないため、
-- ここで補助ウィンドウを閉じても再帰しない）。
vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    -- :q の対象（カレントウィンドウ）がメインエディターでなければ通常動作に任せる。
    -- 例: エクスプローラー上で :q した場合はそのエクスプローラーだけが閉じる。
    if not is_editor_win(vim.api.nvim_get_current_win()) then
      return
    end

    local editors, aux = 0, {}
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if is_editor_win(win) then
        editors = editors + 1
      elseif is_aux_split(win) then
        aux[#aux + 1] = win
      end
    end

    -- メインエディターが 1 つだけ、かつ補助ウィンドウが残っている場合のみ一気に閉じる。
    if editors == 1 and #aux > 0 then
      for _, win in ipairs(aux) do
        pcall(vim.api.nvim_win_close, win, true)
      end
      -- ここで補助が消え、保留中の :q が最後のエディターに効いて Neovim が終了する。
    end
  end,
})
