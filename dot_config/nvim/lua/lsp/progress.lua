-- ~/.config/nvim/lua/lsp/progress.lua
-- LSP の作業進捗 ($/progress) を nvim-notify で表示する
-- =============================================================================
-- LSP サーバーが送る workDoneProgress (begin/report/end) を LspProgress
-- autocmd で受け取り、右上の nvim-notify にスピナー付きで表示する。
-- 同じ進捗 (client + token) は通知を置き換えて更新し、完了 (end) で
-- チェックマークに変えて数秒後に消す。kotlin-lsp の "Initializing project"
-- → "Workspace is imported and indexed" のような読み込み状態が分かるようになる。
-- =============================================================================

-- ブライユ点字によるスピナー (BMP 文字なのでフォント非依存で出やすい)
local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local done_icon = "✓"

-- id ("client:token") -> { notif, msg, title, frame, done }
local records = {}
local timer = assert((vim.uv or vim.loop).new_timer()) -- 非 nil を保証 (型警告対策)
local timer_on = false

local function has_active()
  for _, r in pairs(records) do
    if not r.done then return true end
  end
  return false
end

-- スピナーを回すために、進捗中の通知を一定間隔でアイコンだけ差し替える
local function ensure_timer()
  if timer_on then return end
  timer_on = true
  timer:start(100, 100, vim.schedule_wrap(function()
    for _, r in pairs(records) do
      if not r.done then
        r.frame = (r.frame % #spinner) + 1
        r.notif = vim.notify(r.msg, vim.log.levels.INFO, {
          replace = r.notif,
          title = r.title,
          icon = spinner[r.frame],
          timeout = false,
          hide_from_history = true,
        })
      end
    end
    if not has_active() then
      timer:stop()
      timer_on = false
    end
  end))
end

-- value から表示メッセージを組み立てる (パーセンテージがあれば前置)
local function build_msg(value)
  local msg = value.message or ""
  if value.percentage then
    msg = string.format("%3d%%  %s", value.percentage, msg)
  end
  if msg == "" then
    msg = value.title or ""
  end
  return msg
end

vim.api.nvim_create_autocmd("LspProgress", {
  group = vim.api.nvim_create_augroup("user_lsp_progress", { clear = true }),
  callback = function(ev)
    local value = ev.data.params and ev.data.params.value
    if not (value and value.kind) then return end

    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local name = client and client.name or "LSP"
    local title = value.title and (name .. ": " .. value.title) or name
    local id = tostring(ev.data.client_id) .. ":" .. tostring(ev.data.params.token)
    local msg = build_msg(value)

    if value.kind == "begin" then
      local r = { msg = msg, title = title, frame = 1, done = false }
      r.notif = vim.notify(msg, vim.log.levels.INFO, {
        title = title, icon = spinner[1], timeout = false,
      })
      records[id] = r
      ensure_timer()
    elseif value.kind == "report" then
      local r = records[id]
      if r then
        r.msg, r.title = msg, title
        r.notif = vim.notify(msg, vim.log.levels.INFO, {
          replace = r.notif, title = title, icon = spinner[r.frame], timeout = false,
        })
      end
    elseif value.kind == "end" then
      local r = records[id]
      local final = value.message or "完了"
      vim.notify(final, vim.log.levels.INFO, {
        replace = r and r.notif,
        title = title,
        icon = done_icon,
        timeout = 2000,
      })
      records[id] = nil
    end
  end,
})
