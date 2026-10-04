-- 自動コマンド(autocmd)。
--
-- ここに置くのは Neovim 自体の動きを補うものだけにする。プラグイン固有の autocmd は
-- lua/plugins/<プラグイン>.lua 側に書く(keymaps.lua と同じ考え方)。

-- 外での変更の読み込み直し -------------------------------------------------
-- ファイルが外で書き換えられたら、開いているバッファを読み込み直す。
--
-- Claude Code などが herdr の別のペインでファイルを書き換えても、Neovim のバッファは古い内容の
-- ままになる。そのまま保存すると、外での変更を上書きしてしまう。
-- 'autoread' は既定で有効だが、外での変更を確かめる(:checktime)のは、フォーカスが戻ったときや
-- バッファに入ったときなど決まったときだけ。そこで、それらのイベントに加えて 1 秒ごとにも確かめる。
-- Neovim のペインにフォーカスが無い間に書き換えられることが多いため。
--
-- バッファを編集中(未保存の変更あり)に外でも書き換えられたときは、:checktime が
-- 「W12: ファイルもバッファも変更されている」と尋ねる。どちらを残すかは自分で選ぶ。
-- 1 秒ごとの確認はノーマルモードのときだけにする。挿入中やコマンドラインの入力中に
-- その問いが割り込まないように。
local group = vim.api.nvim_create_augroup("autoread-checktime", {})

local function checktime()
  if vim.fn.getcmdwintype() ~= "" then
    return
  end
  pcall(vim.cmd.checktime)
end

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI", "TermLeave" }, {
  group = group,
  callback = checktime,
})

local timer = vim.uv.new_timer()
timer:start(1000, 1000, vim.schedule_wrap(function()
  if vim.api.nvim_get_mode().mode == "n" then
    checktime()
  end
end))

-- 読み込み直したことを知らせる。どのファイルが外で変わったかが分かるように。
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = group,
  callback = function(args)
    vim.notify("外で変更されたので読み込み直した: " .. vim.fn.fnamemodify(args.file, ":~:."), vim.log.levels.INFO)
  end,
})
