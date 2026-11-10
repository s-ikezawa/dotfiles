-- Dockerfile のリンター hadolint（mise で導入）を走らせ、警告を診断として出す（after/ftplugin/dockerfile.lua から呼ぶ）。
-- hadolint は言語サーバーではないので、プラグイン（nvim-lint など）を足さずにここで呼ぶ。
-- 開いたとき・保存したとき・挿入モードを抜けたとき・ノーマルモードで変更したときに、
-- 保存前のバッファの内容を標準入力で渡すので、保存しなくても結果が変わる。
-- プロジェクトの .hadolint.yaml（無視する規則など）は、hadolint を走らせるフォルダから探されるので、
-- それがあるフォルダ（無ければ git のルート）で走らせる。

local M = {}

local ns = vim.api.nvim_create_namespace('hadolint')

-- hadolint の level を Neovim の診断の重さに直す
local severities = {
  error = vim.diagnostic.severity.ERROR,
  warning = vim.diagnostic.severity.WARN,
  info = vim.diagnostic.severity.INFO,
  style = vim.diagnostic.severity.HINT,
}

local function run(buf)
  if vim.fn.executable('hadolint') == 0 then return end
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  vim.system({ 'hadolint', '--no-fail', '--format', 'json', '-' }, {
    stdin = table.concat(lines, '\n') .. '\n',
    text = true,
    cwd = vim.fs.root(buf, { '.hadolint.yaml', '.hadolint.yml', '.git' }),
  }, function(out)
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(buf) then return end
      local ok, results = pcall(vim.json.decode, out.stdout or '')
      if not ok or type(results) ~= 'table' then return end -- 設定の誤りなどで JSON が出なかったときは何もしない
      local diagnostics = {}
      for _, r in ipairs(results) do
        table.insert(diagnostics, {
          lnum = r.line - 1,
          col = math.max((r.column or 1) - 1, 0),
          severity = severities[r.level] or vim.diagnostic.severity.WARN,
          message = r.message,
          code = r.code, -- DL3008 や SC2086 など。.hadolint.yaml の ignored に書く名前
          source = 'hadolint',
        })
      end
      vim.diagnostic.set(ns, buf, diagnostics)
    end)
  end)
end

local function group_name(buf) return 'config_hadolint_' .. buf end

-- バッファで hadolint を走らせ始める（ファイルタイプが設定されるたびに呼ばれても、二重にならない）
function M.attach(buf)
  local group = vim.api.nvim_create_augroup(group_name(buf), { clear = true })
  vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave', 'TextChanged' }, {
    group = group,
    buffer = buf,
    callback = function() run(buf) end,
  })
  run(buf)
end

-- ファイルタイプが dockerfile でなくなったときに止めて、出した診断を消す（b:undo_ftplugin から呼ぶ）
function M.detach(buf)
  pcall(vim.api.nvim_del_augroup_by_name, group_name(buf))
  vim.diagnostic.reset(ns, buf)
end

return M
