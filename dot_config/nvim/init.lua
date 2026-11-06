-- Neovim の設定。主に Claude Code の変更をじっくりレビューするために使う（簡単な差分は hunk）。

require('config.options')
require('config.keymaps')
require('config.lsp')
require('config.autocmds')

-- プラグインは標準の vim.pack で入れる（更新は :lua vim.pack.update()）。
-- ロックファイル（nvim-pack-lock.json）は chezmoi で管理せず、マシンごとに nvim に任せる。
-- 設定は lua/plugin/<プラグイン名>.lua に 1 つずつ置き、ここで名前順にすべて読み込む。
local plugin_dir = vim.fn.stdpath('config') .. '/lua/plugin'
local files = {}
for name, type in vim.fs.dir(plugin_dir) do
  if type == 'file' and name:match('%.lua$') then table.insert(files, name) end
end
table.sort(files)
for _, name in ipairs(files) do
  require('plugin.' .. name:gsub('%.lua$', ''))
end
