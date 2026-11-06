-- 行番号の周りの列（statuscolumn）を組み立てる。
-- VS Code のように、git の変更の印（gitsigns）を行番号の右に出す。
--   [診断などのサイン 2 桁][行番号][空白][git の印 1 桁]
-- options.lua の statuscolumn から行ごとに呼ばれる。

local M = {}

-- 名前に gitsigns を含む名前空間（変更の印と、ステージ済みの印）の ID
local function is_git_ns(ns_id)
  for name, id in pairs(vim.api.nvim_get_namespaces()) do
    if id == ns_id then return name:find('gitsigns', 1, true) ~= nil end
  end
  return false
end

-- 行に付いたサインを、git のものとそれ以外に分けて、優先度の一番高いものを返す
local function signs_of(buf, lnum)
  local marks = vim.api.nvim_buf_get_extmarks(buf, -1, { lnum - 1, 0 }, { lnum - 1, -1 }, { details = true, type = 'sign' })
  local git, other
  for _, mark in ipairs(marks) do
    local d = mark[4]
    if d.sign_text then
      local sign = { text = d.sign_text, hl = d.sign_hl_group, priority = d.priority or 0 }
      if is_git_ns(d.ns_id) then
        if not git or sign.priority > git.priority then git = sign end
      elseif not other or sign.priority > other.priority then
        other = sign
      end
    end
  end
  return git, other
end

-- 印を「%#ハイライト#文字%*」の形にし、幅に足りない分は空白で埋める
local function render_sign(sign, width)
  if not sign then return (' '):rep(width) end
  local text = vim.fn.strcharpart(sign.text, 0, width)
  text = text .. (' '):rep(width - vim.fn.strdisplaywidth(text))
  return sign.hl and ('%#' .. sign.hl .. '#' .. text .. '%*') or text
end

function M.render()
  local win = vim.g.statusline_winid
  local buf = vim.api.nvim_win_get_buf(win)
  local lnum, relnum, virtnum = vim.v.lnum, vim.v.relnum, vim.v.virtnum

  local git, other = signs_of(buf, lnum)

  -- 行番号。相対行番号のときは、カーソル行だけ実際の行番号を出す。折り返した続きの行には出さない
  local num = ''
  if virtnum == 0 and (vim.wo[win].number or vim.wo[win].relativenumber) then
    if vim.wo[win].relativenumber and relnum ~= 0 then
      num = tostring(relnum)
    else
      num = tostring(lnum)
    end
  end
  local width = math.max(vim.wo[win].numberwidth - 1, #tostring(vim.api.nvim_buf_line_count(buf)))
  local num_hl = relnum == 0 and 'CursorLineNr' or 'LineNr'
  num = '%#' .. num_hl .. '#' .. (' '):rep(width - #num) .. num .. '%*'

  if virtnum ~= 0 then other = nil end -- 折り返した続きの行には診断の印を繰り返さない

  return render_sign(other, 2) .. num .. ' ' .. render_sign(git, 1) -- 行番号と git の印の間を 1 桁あける
end

return M
