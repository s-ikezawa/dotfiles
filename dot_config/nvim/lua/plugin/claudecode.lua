-- claudecode: Claude Code の IDE 連携（VS Code の拡張機能と同じ仕組み）を Neovim で使う。
-- Neovim が WebSocket のサーバーを立て、Claude Code から /ide でつなぐと、
-- 開いているファイルと選んでいる範囲が自動で Claude に伝わる。Claude からは LSP の診断も読める。
-- Claude Code は Neovim の中ではなく herdr のペインで動かすので、ターミナルは開かない（provider = 'none'）。
-- 接続の情報は $CLAUDE_CONFIG_DIR/ide/<port>.lock に置かれ、Claude Code はそれを見て Neovim を見つける。
-- https://github.com/coder/claudecode.nvim

-- 既定のブランチを追う。変更の提案を 1 列で出す diff_opts.layout = 'unified' が、最新のリリース（v0.3.0）にはまだないため
vim.pack.add({ { src = 'https://github.com/coder/claudecode.nvim', version = 'main' } })

require('claudecode').setup({
  terminal = {
    provider = 'none', -- Claude Code は herdr のペインで動かすので、Neovim の中にターミナルを開かない
  },
  diff_opts = {
    layout = 'unified', -- Claude の変更の提案を 1 列で出す（delta・hunk・CodeDiff と揃える）
  },
})

-- herdr で同じタブ（なければ同じワークスペース）にいる Claude のペインを探し、
-- 見つかったら callback(agent) をメインループで呼ぶ。agent は herdr agent list の 1 件（pane_id・cwd など）
local function find_claude(callback)
  -- 環境変数は先に読む（vim.system のコールバックの中では Neovim の関数を呼べないため）
  local tab_id, workspace_id = vim.env.HERDR_TAB_ID, vim.env.HERDR_WORKSPACE_ID
  if not tab_id then -- herdr の外では何もしない
    vim.notify('herdr の外では Claude のペインを探せません', vim.log.levels.WARN)
    return
  end
  vim.system({ 'herdr', 'agent', 'list' }, { text = true }, function(res)
    local ok, data = pcall(vim.json.decode, res.code == 0 and res.stdout or '')
    local found
    for _, agent in ipairs(ok and vim.tbl_get(data, 'result', 'agents') or {}) do
      if agent.agent == 'claude' then
        if agent.tab_id == tab_id then
          found = agent
          break
        elseif not found and agent.workspace_id == workspace_id then
          found = agent
        end
      end
    end
    vim.schedule(function()
      if found then
        callback(found)
      else
        vim.notify('herdr の同じタブ・ワークスペースに Claude のペインが見つかりません', vim.log.levels.WARN)
      end
    end)
  end)
end

-- Claude のペインへ移る
local function focus_claude()
  find_claude(function(agent) vim.system({ 'herdr', 'agent', 'focus', agent.pane_id }) end)
end

-- カーソル行（ビジュアルモードなら選んだ範囲）を指示を付けて Claude に送り、送信まで済ませる。
-- 送る文は「@<ファイル>#L<開始>-<終了> <指示>」。パスは Claude のペインの作業フォルダからの相対パス。
local function prompt_claude()
  local file = vim.api.nvim_buf_get_name(0)
  if file == '' or vim.bo.buftype ~= '' then
    vim.notify('ファイルを開いているバッファで使ってください', vim.log.levels.WARN)
    return
  end
  local first, last = vim.fn.line('v'), vim.fn.line('.') -- ノーマルモードではどちらもカーソル行
  if first > last then first, last = last, first end
  if vim.fn.mode():find('^[vV\22]') then vim.cmd('normal! \27') end -- ビジュアルモードを抜ける

  local range = first == last and ('#L%d'):format(first) or ('#L%d-%d'):format(first, last)
  vim.ui.input({ prompt = ('Claude へ（%s%s）: '):format(vim.fn.fnamemodify(file, ':t'), range) }, function(input)
    if not input or input == '' then return end -- 何も打たずに閉じたら送らない
    find_claude(function(agent)
      local path = vim.fs.relpath(agent.cwd, file) or file -- 作業フォルダの外なら絶対パス
      local text = ('@%s%s %s'):format(path, range, input)
      vim.system({ 'herdr', 'agent', 'prompt', agent.pane_id, text }, { text = true }, function(res)
        vim.schedule(function()
          if res.code == 0 then
            vim.notify('Claude に送りました: ' .. text)
          else
            vim.notify('Claude に送れませんでした: ' .. (res.stderr ~= '' and res.stderr or res.stdout), vim.log.levels.ERROR)
          end
        end)
      end)
    end)
  end)
end

-- 選んだ範囲やファイルを送ったら、続けて Claude に打ち込めるよう Claude のペインへ移る
vim.api.nvim_create_autocmd('User', {
  group = vim.api.nvim_create_augroup('config_claudecode_focus', { clear = true }),
  pattern = 'ClaudeCodeSendComplete',
  desc = '送ったあとに herdr の Claude のペインへ移る',
  callback = focus_claude,
})

local map = vim.keymap.set
map('n', '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', { desc = 'このファイルを Claude に送る' })
map('x', '<leader>as', '<cmd>ClaudeCodeSend<cr>', { desc = '選んだ範囲を Claude に送る' })
map({ 'n', 'x' }, '<leader>ap', prompt_claude, { desc = 'この行（選んだ範囲）に指示を付けて Claude に送る（herdr）' })
map('n', '<leader>af', focus_claude, { desc = 'Claude のペインへ移る（herdr）' })
map('n', '<leader>aS', '<cmd>ClaudeCodeStatus<cr>', { desc = 'Claude との接続の状態を出す' })
map('n', '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', { desc = 'Claude の変更の提案を受け入れる' })
map('n', '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', { desc = 'Claude の変更の提案を断る' })

-- neo-tree の中では、カーソルのファイルを Claude に送る
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('config_claudecode_tree', { clear = true }),
  pattern = 'neo-tree',
  desc = 'neo-tree で <leader>as をファイルを送るキーにする',
  callback = function(args)
    map('n', '<leader>as', '<cmd>ClaudeCodeTreeAdd<cr>', { buffer = args.buf, desc = 'このファイルを Claude に送る' })
  end,
})
