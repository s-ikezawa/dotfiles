-- 言語サーバーの状態（つながっているサーバーと、インデックス作業などの進み具合）を、
-- ステータスライン（lua/plugin/lualine.lua）に出すための文字列を作る。
-- Kotlin のようにインデックス作業が終わるまで LSP の機能が使えないサーバーで、待つ目安にする。

local M = {}

---@type fun()? 表示が変わったときに呼ぶ（ステータスラインの描き直しなど）
M.on_change = nil

-- 進行中の作業。[client_id][token] = { title, message, percentage }
local tasks = {}

local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' } -- 作業中に回す
local lsp_icon = '\u{f085} ' -- 作業が終わってつながっているとき（nf-fa-gears）

local function frame()
  return spinner[math.floor(vim.uv.hrtime() / 1e8) % #spinner + 1]
end

-- サーバーから届いた文を、ステータスラインにそのまま出せる形にする。
-- % は書式の記号として読まれる（「50% done」の「% 」などは E539 になる）ので %% にし、改行は空白にする
local function escape(s)
  return (s:gsub('%%', '%%%%'):gsub('[\r\n]+', ' '))
end

-- 進行中の作業を 1 つ選んで「サーバー名: 作業名 メッセージ (%)」にする
local function progress_text()
  for client_id, by_token in pairs(tasks) do
    for _, t in pairs(by_token) do
      local client = vim.lsp.get_client_by_id(client_id)
      local parts = { (client and client.name or '?') .. ':', escape(t.title or '') }
      if t.message and t.message ~= '' then table.insert(parts, escape(t.message)) end
      if t.percentage then table.insert(parts, ('(%d%%%%)'):format(t.percentage)) end -- %% は statusline でのエスケープ
      return frame() .. ' ' .. table.concat(parts, ' ')
    end
  end
end

-- ステータスラインに出す文字列。言語サーバーがつながっていなければ空
function M.text()
  local progress = progress_text()
  if progress then return progress end
  local names = {}
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    table.insert(names, client.name)
  end
  if #names == 0 then return '' end
  return lsp_icon .. table.concat(names, ', ')
end

local function has_tasks()
  for _, by_token in pairs(tasks) do
    if next(by_token) then return true end
  end
  return false
end

-- 作業が残っている間だけ、回る記号を進めるために描き直し続ける。
-- 進み具合のイベントは長い間来ないこともあり（Kotlin の Gradle の読み込み中など）、
-- イベントのときだけ描き直すと記号が止まって見えるため。
local timer = vim.uv.new_timer()
local spinning = false

local function update_spinner()
  if has_tasks() and not spinning then
    spinning = true
    timer:start(100, 100, vim.schedule_wrap(function()
      if M.on_change then M.on_change() end
    end))
  elseif not has_tasks() and spinning then
    spinning = false
    timer:stop()
  end
end

---@param opts? { on_change?: fun() }
function M.setup(opts)
  M.on_change = opts and opts.on_change
  local group = vim.api.nvim_create_augroup('config_lsp_progress', { clear = true })

  vim.api.nvim_create_autocmd('LspProgress', {
    group = group,
    desc = '言語サーバーの作業の進み具合を覚える',
    callback = function(ev)
      local client_id, params = ev.data.client_id, ev.data.params
      local value = params.value
      if type(value) ~= 'table' then return end
      tasks[client_id] = tasks[client_id] or {}
      if value.kind == 'end' then
        tasks[client_id][params.token] = nil
      else
        local t = tasks[client_id][params.token] or {}
        t.title = value.title or t.title       -- 作業名は begin のときだけ送られる
        t.message = value.message
        t.percentage = value.percentage
        tasks[client_id][params.token] = t
      end
      update_spinner()
      if M.on_change then M.on_change() end
    end,
  })

  vim.api.nvim_create_autocmd({ 'LspAttach', 'LspDetach' }, {
    group = group,
    desc = 'つながっている言語サーバーの表示を変える',
    callback = function(ev)
      if ev.event == 'LspDetach' then
        tasks[ev.data.client_id] = nil
        update_spinner()
      end
      if M.on_change then vim.schedule(M.on_change) end
    end,
  })
end

return M
