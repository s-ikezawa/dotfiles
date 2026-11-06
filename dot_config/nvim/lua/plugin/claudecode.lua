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

-- herdr で同じタブ（なければ同じワークスペース）にいる Claude のペインへ移る
local function focus_claude()
  -- 環境変数は先に読む（vim.system のコールバックの中では Neovim の関数を呼べないため）
  local tab_id, workspace_id = vim.env.HERDR_TAB_ID, vim.env.HERDR_WORKSPACE_ID
  if not tab_id then return end -- herdr の外では何もしない
  vim.system({ 'herdr', 'agent', 'list' }, { text = true }, function(res)
    if res.code ~= 0 then return end
    local ok, data = pcall(vim.json.decode, res.stdout)
    if not ok then return end
    local target
    for _, agent in ipairs(vim.tbl_get(data, 'result', 'agents') or {}) do
      if agent.agent == 'claude' then
        if agent.tab_id == tab_id then
          target = agent.pane_id
          break
        elseif not target and agent.workspace_id == workspace_id then
          target = agent.pane_id
        end
      end
    end
    if target then vim.system({ 'herdr', 'agent', 'focus', target }) end
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
