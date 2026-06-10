-- ~/.config/nvim/lua/autocmd.lua
-- オートコマンド設定

-- ============================================================
-- ファイル保存を notify で通知する (Notify on write)
-- ============================================================
-- :w の "written" は組み込みメッセージで vim.notify を経由しないため、
-- BufWritePost で自前に通知する。組み込みの written 表示は
-- shortmess の "W" (options.lua で設定) で抑制している。
vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("notify_on_write", { clear = true }),
  callback = function(args)
    local name = vim.fn.fnamemodify(args.file, ":~:.") -- カレントからの相対パス
    local lines = vim.api.nvim_buf_line_count(args.buf)
    vim.notify(string.format("%s  (%d 行)", name, lines), vim.log.levels.INFO, {
      title = "Written",
    })
  end,
})

-- ============================================================
-- :q でプラグインのウィンドウも閉じる (Close plugin windows on :q)
-- ============================================================
-- :q 実行時、プラグインが表示している補助ウィンドウ
-- (フローティング・Explorer サイドバー・ターミナル等) も一緒に閉じる。
-- ただし「メインのエディタ (実ファイル) ウィンドウが残り 1 つ = いま閉じるのが
-- 最後」のときだけ実行する。エディタを分割して片方だけ閉じた場合は補助ウィンドウ
-- を残す (全部巻き込んで閉じてしまわないように)。

-- 補助ウィンドウ (プラグイン由来) かどうかを判定する
local function is_plugin_win(win)
  local config = vim.api.nvim_win_get_config(win)           -- ウィンドウ設定
  local buf = vim.api.nvim_win_get_buf(win)                 -- 紐づくバッファ
  local buftype = vim.bo[buf].buftype                       -- バッファ種別
  local filetype = vim.bo[buf].filetype                     -- ファイルタイプ
  return config.relative ~= ""                              -- フローティングウィンドウ
    or buftype == "terminal"                                -- ターミナル (sidekick CLI 等)
    or buftype == "nofile"                                  -- 実ファイルでないバッファ
    or filetype:match("^snacks") ~= nil                     -- snacks 系 (Explorer/Picker)
    or filetype:match("^sidekick") ~= nil                   -- sidekick 系
end

vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local current = vim.api.nvim_get_current_win()
    -- いま閉じようとしているのが補助ウィンドウ自身なら何もしない
    -- (補助ウィンドウを個別に閉じただけのケース)
    if is_plugin_win(current) then
      return
    end
    -- 現在のタブに存在するメイン (非プラグイン) エディタウィンドウを数える
    local main_count = 0
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_is_valid(win) and not is_plugin_win(win) then
        main_count = main_count + 1
      end
    end
    -- メインエディタが複数残っている (= 分割の片方を閉じただけ) なら
    -- 補助ウィンドウは残す
    if main_count > 1 then
      return
    end
    -- ここに来るのは「最後のメインエディタを閉じる」とき。補助ウィンドウを畳む
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if win ~= current and vim.api.nvim_win_is_valid(win) and is_plugin_win(win) then
        pcall(vim.api.nvim_win_close, win, true)            -- 安全に閉じる
      end
    end
  end,
})
