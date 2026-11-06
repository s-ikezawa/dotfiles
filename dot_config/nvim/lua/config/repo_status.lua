-- いまのフォルダ（:pwd）の git リポジトリ全体で、変更されたファイルの数を数える。
-- ステータスライン（lua/plugin/lualine.lua）に出し、ファイルのツリーを開かなくても変更に気付けるようにする。
-- Claude Code などの書き換えにも気付けるよう、裏で git status を 2 秒ごとに実行する（非同期）。

local M = {}

---@type { modified: integer, added: integer, deleted: integer, untracked: integer }?
M.counts = nil -- git リポジトリの外では nil

---@type fun()? 数が変わったときに呼ぶ（ステータスラインの描き直しなど）
M.on_change = nil

local running = false

-- git status --porcelain の 1 行目の 2 文字（インデックス側・作業ツリー側）から種類を決める
local function classify(xy, counts)
  if xy == '??' then
    counts.untracked = counts.untracked + 1
  elseif xy:find('D') then
    counts.deleted = counts.deleted + 1
  elseif xy:find('A') then
    counts.added = counts.added + 1
  else -- M（変更）・R（名前の変更）・T（種類の変更）・U（衝突）
    counts.modified = counts.modified + 1
  end
end

function M.update()
  if running then return end
  running = true
  vim.system({ 'git', 'status', '--porcelain=v1', '--untracked-files=all' }, { cwd = vim.fn.getcwd(), text = true }, function(res)
    running = false
    local counts
    if res.code == 0 then
      counts = { modified = 0, added = 0, deleted = 0, untracked = 0 }
      for line in res.stdout:gmatch('[^\n]+') do
        classify(line:sub(1, 2), counts)
      end
    end
    if vim.deep_equal(counts, M.counts) then return end
    M.counts = counts
    if M.on_change then vim.schedule(M.on_change) end
  end)
end

-- 種類ごとのアイコン（Nerd Font の Octicons）。lualine の diff でも同じものを使う
M.icons = {
  modified = '\u{f459} ',  -- 変更（nf-oct-diff_modified）
  added = '\u{f457} ',     -- 追加（nf-oct-diff_added）
  deleted = '\u{f458} ',   -- 削除（nf-oct-diff_removed）
  untracked = '\u{f420} ', -- 未追跡（nf-oct-question）
}

-- ステータスラインに出す文字列（例: <変更のアイコン>3 <追加のアイコン>1）。変更がなければ空
function M.text()
  local c = M.counts
  if not c then return '' end
  local parts = {}
  for _, kind in ipairs({ 'modified', 'added', 'deleted', 'untracked' }) do
    if c[kind] > 0 then table.insert(parts, M.icons[kind] .. c[kind]) end
  end
  return table.concat(parts, ' ')
end

---@param opts? { on_change?: fun() }
function M.setup(opts)
  M.on_change = opts and opts.on_change
  vim.api.nvim_create_autocmd({ 'VimEnter', 'FocusGained', 'DirChanged', 'BufWritePost' }, {
    group = vim.api.nvim_create_augroup('config_repo_status', { clear = true }),
    desc = 'リポジトリ全体の変更の数を数え直す',
    callback = M.update,
  })
  -- タイマーの中では getcwd などを呼べないので、メインループで動かす
  vim.uv.new_timer():start(2000, 2000, vim.schedule_wrap(M.update))
end

return M
