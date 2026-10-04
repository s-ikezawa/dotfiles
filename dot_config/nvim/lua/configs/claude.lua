-- herdr 経由で、Claude Code の入力欄にファイルと行の参照を送る。
--
--   <leader>as  ノーマル: @パス#L行      ビジュアル: @パス#L開始-終了
--   <leader>af  @パス(ファイル全体)
--   <leader>ad  ノーマル: カーソル行の診断       ビジュアル: 選択範囲の診断
--   <leader>aD  ファイルの診断すべて
--   neo-tree の中の <leader>as は、カーソルのファイルかフォルダを送る(lua/plugins/neo-tree.lua)。
--
-- Claude Code は @パス#L開始-終了 を行範囲として読み、その行だけを添付する。公式ドキュメントでは
-- JetBrains 連携が入れる形式として載っている書き方で、ターミナルでの説明は無いが、claude -p で
-- 試すと #L2-3 は 2〜3 行目だけ、#L4 は 4 行目だけが添付された(Claude Code の更新で変わり得る)。
-- 末尾に空白を付けて、@ で開くファイル名の補完を閉じる。Enter は送らないので、続けて指示を書ける。
--
-- 送り先は herdr が見つけた Claude Code のペイン。Neovim と同じタブ、無ければ同じワークスペース、
-- 無ければすべての中から探し、1 つに決まらなければ選ばせる。パスはそのペインの作業ディレクトリ
-- からの相対パスにし、その外のファイルは絶対パスで送る(@ のパスは Claude Code の作業ディレクトリ
-- から解決される)。空白を含むパスは @ の参照が途中で切れるので送らない。
-- Neovim が herdr の中で動いていない(HERDR_ENV が 1 でない)ときは何もしない。

local function notify(msg, level)
  vim.notify("claude: " .. msg, level or vim.log.levels.WARN)
end

-- herdr の CLI を呼んで JSON を返す。失敗したときは nil とエラーの文字列。
local function herdr(args)
  local cmd = vim.list_extend({ "herdr" }, args)
  local res = vim.system(cmd, { text = true }):wait()
  if res.code ~= 0 then
    return nil, vim.trim(res.stderr ~= "" and res.stderr or res.stdout)
  end
  local ok, decoded = pcall(vim.json.decode, res.stdout)
  if not ok then
    return nil, res.stdout
  end
  return decoded, nil
end

-- 送り先の Claude Code を決め、callback(agent) に渡す。
local function pick_agent(callback)
  local list, err = herdr({ "agent", "list" })
  if not list then
    notify("herdr agent list に失敗: " .. tostring(err), vim.log.levels.ERROR)
    return
  end
  local agents = vim.tbl_filter(function(a)
    return a.agent == "claude"
  end, list.result and list.result.agents or {})
  if #agents == 0 then
    notify("Claude Code のペインが見つからない")
    return
  end

  -- 同じタブ → 同じワークスペース → すべて、の順に絞り、最初に候補が残った段で決める。
  local scopes = {
    function(a) return a.tab_id == vim.env.HERDR_TAB_ID end,
    function(a) return a.workspace_id == vim.env.HERDR_WORKSPACE_ID end,
    function() return true end,
  }
  local candidates
  for _, in_scope in ipairs(scopes) do
    candidates = vim.tbl_filter(in_scope, agents)
    if #candidates > 0 then
      break
    end
  end

  if #candidates == 1 then
    return callback(candidates[1])
  end
  vim.ui.select(candidates, {
    prompt = "送り先の Claude Code",
    format_item = function(a)
      return string.format("%s  %s  %s", a.pane_id, a.cwd, a.terminal_title_stripped or "")
    end,
  }, function(choice)
    if choice then
      callback(choice)
    end
  end)
end

-- バッファのファイルの実パス。ファイルでないバッファ(ツリーや端末など)は nil。
local function buffer_path()
  if vim.bo.buftype ~= "" then
    return nil
  end
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then
    return nil
  end
  return vim.uv.fs_realpath(name) or vim.fs.normalize(name)
end

-- 送り先を決め、build(agent) が返す文字列を入力欄へ送る。build が nil を返したら送らない。
-- opts.focus が false なら送った後もフォーカスを Neovim に残す(続けて何個も送るとき)。
local function send_text(build, opts)
  opts = opts or {}
  if vim.env.HERDR_ENV ~= "1" then
    notify("herdr の中で動いていないので送れない")
    return
  end

  pick_agent(function(agent)
    -- 承認や質問の画面を出しているときに文字を打つと、その画面への入力になってしまう。
    if agent.agent_status == "blocked" then
      notify("Claude Code が承認・質問の画面を出しているので送らない(" .. agent.pane_id .. ")")
      return
    end
    local text = build(agent)
    if not text then
      return
    end

    -- 末尾の空白で、@ で開くファイル名の補完を閉じる。
    local _, err = herdr({ "pane", "send-text", agent.pane_id, text .. " " })
    if err then
      notify("送信に失敗: " .. err, vim.log.levels.ERROR)
      return
    end
    if opts.focus ~= false then
      herdr({ "agent", "focus", agent.pane_id })
    end
  end)
end

-- @ の参照。Claude Code の作業ディレクトリの下なら相対パス、外なら絶対パスにする。
-- /private/tmp と /tmp のような別名でも相対パスにできるよう、作業ディレクトリも実パスにする。
-- lines は nil(ファイル全体)か { 開始, 終了 }(同じなら 1 行)。
local function ref(agent, path, lines)
  local cwd = vim.uv.fs_realpath(agent.cwd) or agent.cwd
  local text = "@" .. (vim.fs.relpath(cwd, path) or path)
  if lines then
    local s, e = math.min(lines[1], lines[2]), math.max(lines[1], lines[2])
    text = text .. (s == e and ("#L" .. s) or ("#L" .. s .. "-" .. e))
  end
  return text
end

-- 空白を含むパスは @ の参照が途中で切れるので送らない。
local function sendable(path)
  if path:find("%s") then
    notify("空白を含むパスは @ の参照にできない: " .. path)
    return false
  end
  return true
end

local M = {}

-- パスを指定して送る。neo-tree(lua/plugins/neo-tree.lua)からも使う。
function M.send_path(path, lines, opts)
  path = vim.uv.fs_realpath(path) or vim.fs.normalize(path)
  if not sendable(path) then
    return
  end
  send_text(function(agent)
    return ref(agent, path, lines)
  end, opts)
end

-- 今のバッファのファイルを送る。
local function send_buffer(lines)
  local path = buffer_path()
  if not path then
    notify("ファイルを開いているバッファで使う")
    return
  end
  M.send_path(path, lines)
end

-- 診断を「@パス#L行 [重大度] 内容」を空白でつないだ 1 行にして送る。@パス#L行 の部分で、
-- その行も Claude Code に添付される。
-- 改行も送れる(herdr は改行を LF で送り、Claude Code は LF(Ctrl+J)を改行の挿入として扱う)が、
-- 複数行の中の @ の参照が解決されるかは確かめていないので、1 行にまとめる。
-- 内容の中の改行は空白にする。件数が多すぎると入力欄が溢れるので、先頭から 100 件までにする。
-- 今のバッファの診断を送る。range は { 開始行, 終了行 } で、その範囲の診断だけにする。
local MAX_DIAGNOSTICS = 100
local SEVERITY = { "ERROR", "WARN", "INFO", "HINT" }

local function send_diagnostics(range)
  local path = buffer_path()
  if not path then
    notify("ファイルを開いているバッファで使う")
    return
  end
  if not sendable(path) then
    return
  end
  local items = {}
  for _, d in ipairs(vim.diagnostic.get(0)) do
    local line = d.lnum + 1
    if not range or (line >= math.min(range[1], range[2]) and line <= math.max(range[1], range[2])) then
      table.insert(items, { line = line, diagnostic = d })
    end
  end
  if #items == 0 then
    notify("送る診断が無い", vim.log.levels.INFO)
    return
  end
  table.sort(items, function(a, b)
    if a.line ~= b.line then
      return a.line < b.line
    end
    return a.diagnostic.severity < b.diagnostic.severity
  end)
  if #items > MAX_DIAGNOSTICS then
    notify(string.format("診断が %d 件あるので先頭の %d 件だけ送る", #items, MAX_DIAGNOSTICS))
    items = vim.list_slice(items, 1, MAX_DIAGNOSTICS)
  end

  send_text(function(agent)
    local parts = {}
    for _, item in ipairs(items) do
      local d = item.diagnostic
      local message = vim.trim((d.message:gsub("%s+", " ")))
      local source = d.source and (" (" .. d.source .. ")") or ""
      table.insert(parts, string.format("%s [%s] %s%s", ref(agent, path, { item.line, item.line }), SEVERITY[d.severity] or "?", message, source))
    end
    return table.concat(parts, " ")
  end)
end

vim.keymap.set("n", "<leader>as", function()
  local line = vim.fn.line(".")
  send_buffer({ line, line })
end, { desc = "claude: ファイルと行を送る" })

-- ビジュアルモードのまま範囲を読み(line("v") は選択の始点)、送る前にビジュアルモードを抜ける。
local function visual_range()
  local range = { vim.fn.line("v"), vim.fn.line(".") }
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
  return range
end

vim.keymap.set("x", "<leader>as", function()
  send_buffer(visual_range())
end, { desc = "claude: ファイルと選択範囲を送る" })

vim.keymap.set("n", "<leader>af", function()
  send_buffer(nil)
end, { desc = "claude: ファイルを送る" })

vim.keymap.set("n", "<leader>ad", function()
  local line = vim.fn.line(".")
  send_diagnostics({ line, line })
end, { desc = "claude: カーソル行の診断を送る" })

vim.keymap.set("x", "<leader>ad", function()
  send_diagnostics(visual_range())
end, { desc = "claude: 選択範囲の診断を送る" })

vim.keymap.set("n", "<leader>aD", function()
  send_diagnostics(nil)
end, { desc = "claude: ファイルの診断をすべて送る" })

return M
