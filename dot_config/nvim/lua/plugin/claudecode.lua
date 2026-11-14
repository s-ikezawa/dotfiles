-- claudecode: Claude Code の IDE 連携（VS Code の拡張機能と同じ仕組み）を Neovim で使う。
-- Neovim が WebSocket のサーバーを立て、Claude Code から /ide でつなぐと、
-- 開いているファイルと選んでいる範囲が自動で Claude に伝わる。Claude からは LSP の診断も読める。
-- Claude Code は Neovim の中ではなく Rex の別のペインで動かすので、ターミナルは開かない（provider = 'none'）。
-- 接続の情報は $CLAUDE_CONFIG_DIR/ide/<port>.lock に置かれ、Claude Code はそれを見て Neovim を見つける。
-- https://github.com/coder/claudecode.nvim

-- 既定のブランチを追う。変更の提案を 1 列で出す diff_opts.layout = 'unified' が、最新のリリース（v0.3.0）にはまだないため
vim.pack.add({ { src = 'https://github.com/coder/claudecode.nvim', version = 'main' } })

-- 送ったあとに Claude へ移る focus_after_send は使わない。Neovim の外の Claude には移れず、
-- provider が 'none' 以外だと、Neovim の中に 2 つ目の Claude を起動してしまうため。
-- 送ったら、Rex のキー（Ctrl+A → h/l）で Claude のペインへ移る。
require('claudecode').setup({
  terminal = {
    provider = 'none', -- Claude Code は Rex のペインで動かすので、Neovim の中にターミナルを開かない
  },
  diff_opts = {
    layout = 'unified', -- Claude の変更の提案を 1 列で出す（delta・hunk・CodeDiff と揃える）
  },
})

-- 送るのは @<ファイル>#L<行> の参照だけで、Claude の入力欄に入る（送信はしない）。指示は Claude のペインで続けて書く。
-- IDE 連携でできるのは参照を渡すところまでで、指示の文を打ち込んだり送信したりはできない。
local map = vim.keymap.set
map('n', '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', { desc = 'このファイルを Claude に送る' })
map('x', '<leader>as', '<cmd>ClaudeCodeSend<cr>', { desc = '選んだ範囲を Claude に送る' })
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
