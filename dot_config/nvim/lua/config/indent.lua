-- ファイルタイプごとのインデントを設定する（after/ftplugin/<ファイルタイプ>.lua から呼ぶ）。
-- .editorconfig の indent_style・indent_size・tab_width にあたるもの。
-- プロジェクトに .editorconfig があれば、Neovim 標準の EditorConfig の対応がこのあとに効いて、そちらが優先される。
-- ファイルタイプが変わったら元（グローバルの値）に戻るよう、b:undo_ftplugin に戻し方を書き足す。

local M = {}

-- b:undo_ftplugin（同梱の ftplugin が書いたものも含む）の後ろに、戻すコマンドを足す
local function add_undo(cmd)
  vim.b.undo_ftplugin = (vim.b.undo_ftplugin and vim.b.undo_ftplugin .. ' | ' or '') .. cmd
end

-- スペースでインデントする（indent_style = space、indent_size = width）
function M.spaces(width)
  vim.opt_local.expandtab = true    -- <Tab> でスペースを入れる
  vim.opt_local.shiftwidth = width  -- >> や自動インデントの幅
  vim.opt_local.softtabstop = width -- <Tab>・<BS> で width 桁ずつ動く
  vim.opt_local.tabstop = width     -- 紛れ込んだタブ文字も同じ幅で表示する
  add_undo('setlocal et< sw< sts< ts<')
end

-- タブでインデントする（indent_style = tab、tab_width = width）
function M.tabs(width)
  vim.opt_local.expandtab = false -- <Tab> でタブ文字を入れる
  vim.opt_local.shiftwidth = 0    -- >> や自動インデントの幅を tabstop に合わせる
  vim.opt_local.softtabstop = 0   -- <Tab>・<BS> でタブ 1 文字ずつ動く
  vim.opt_local.tabstop = width   -- タブを width 桁で表示する
  -- タブの印（options.lua の listchars の »）は、ほかのファイルとそろえてそのまま出す
  -- （言語によって出たり出なかったりすると、見るたびに考えることが増えるため）
  add_undo('setlocal et< sw< sts< ts<')
end

return M
