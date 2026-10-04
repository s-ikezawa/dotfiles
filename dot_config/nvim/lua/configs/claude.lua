-- herdr 経由で、Claude Code の入力欄にファイルと行の参照を送る。
--
--   <leader>as  ノーマル: @パス#L行      ビジュアル: @パス#L開始-終了
--   <leader>af  @パス(ファイル全体)
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

-- lines は nil(ファイル全体)か { 開始, 終了 }(同じなら 1 行)。
local function send(lines)
  if vim.env.HERDR_ENV ~= "1" then
    notify("herdr の中で動いていないので送れない")
    return
  end
  local path = buffer_path()
  if not path then
    notify("ファイルを開いているバッファで使う")
    return
  end
  if path:find("%s") then
    notify("空白を含むパスは @ の参照にできない: " .. path)
    return
  end

  pick_agent(function(agent)
    -- 承認や質問の画面を出しているときに文字を打つと、その画面への入力になってしまう。
    if agent.agent_status == "blocked" then
      notify("Claude Code が承認・質問の画面を出しているので送らない(" .. agent.pane_id .. ")")
      return
    end

    -- /private/tmp と /tmp のような別名でも相対パスにできるよう、作業ディレクトリも実パスにする。
    local cwd = vim.uv.fs_realpath(agent.cwd) or agent.cwd
    local ref = "@" .. (vim.fs.relpath(cwd, path) or path)
    if lines then
      local s, e = math.min(lines[1], lines[2]), math.max(lines[1], lines[2])
      ref = ref .. (s == e and ("#L" .. s) or ("#L" .. s .. "-" .. e))
    end

    local _, err = herdr({ "pane", "send-text", agent.pane_id, ref .. " " })
    if err then
      notify("送信に失敗: " .. err, vim.log.levels.ERROR)
      return
    end
    herdr({ "agent", "focus", agent.pane_id })
  end)
end

vim.keymap.set("n", "<leader>as", function()
  local line = vim.fn.line(".")
  send({ line, line })
end, { desc = "claude: ファイルと行を送る" })

-- ビジュアルモードのまま範囲を読み(line("v") は選択の始点)、送る前にビジュアルモードを抜ける。
vim.keymap.set("x", "<leader>as", function()
  local range = { vim.fn.line("v"), vim.fn.line(".") }
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
  send(range)
end, { desc = "claude: ファイルと選択範囲を送る" })

vim.keymap.set("n", "<leader>af", function()
  send(nil)
end, { desc = "claude: ファイルを送る" })
