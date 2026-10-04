-- incline.nvim。ウィンドウごとの右下に、診断・Git の差分・ファイル名を小さなフロートで出す。
-- ステータスラインを出さない(lua/configs/options.lua の laststatus = 0)代わりに、
-- どのウィンドウに何のファイルを開いているかをここで見せる。
--
-- version を指定していないのは、最新のタグ v0.1.0(2025-11)より後に、カラースキームを
-- 変えたときにハイライトを読み直す修正などが main にだけ入っているため。既定ブランチを追う。
vim.pack.add({
  { src = "https://github.com/b0o/incline.nvim" },
})

-- 表示の並びは README の例「Diagnostics + Git Diff + Icon + Filename」に合わせ、次の点を変えている。
--   - アイコンは nvim-web-devicons ではなく mini.icons(lua/plugins/mini-icons.lua)から取る。
--   - README は pairs で回していて並びが毎回変わり得るので、配列にして順番を固定する。
--   - 色は README の 'Diff' .. name(Diffadded などで、存在しないグループ)ではなく、
--     サインカラムの印と同じ GitSigns* のグループにする。
--   - 診断と差分の記号は lua/configs/icons.lua から取る(hint を README から変えた理由もそちら)。
--   - 末尾のウィンドウ番号(DevIconWindows)は nvim-web-devicons のハイライトに頼るので入れない。
local icons = require("configs.icons")
local diagnostics = {
  { severity = vim.diagnostic.severity.ERROR, icon = icons.diagnostics.ERROR, group = "DiagnosticSignError" },
  { severity = vim.diagnostic.severity.WARN, icon = icons.diagnostics.WARN, group = "DiagnosticSignWarn" },
  { severity = vim.diagnostic.severity.INFO, icon = icons.diagnostics.INFO, group = "DiagnosticSignInfo" },
  { severity = vim.diagnostic.severity.HINT, icon = icons.diagnostics.HINT, group = "DiagnosticSignHint" },
}
local git_diff = {
  { key = "added", icon = icons.git.added, group = "GitSignsAdd" },
  { key = "changed", icon = icons.git.changed, group = "GitSignsChange" },
  { key = "removed", icon = icons.git.removed, group = "GitSignsDelete" },
}

-- 0 件の項目は出さない。何か出したときだけ区切り ┊ を後ろに付ける。
local function diagnostic_labels(buf)
  local labels = {}
  local counts = vim.diagnostic.count(buf)
  for _, d in ipairs(diagnostics) do
    local n = counts[d.severity] or 0
    if n > 0 then
      table.insert(labels, { d.icon .. " " .. n .. " ", group = d.group })
    end
  end
  if #labels > 0 then
    table.insert(labels, "┊ ")
  end
  return labels
end

-- gitsigns がまだ差分を取っていないバッファ(Git の管理外など)では辞書が無い。
local function git_diff_labels(buf)
  local labels = {}
  local status = vim.b[buf].gitsigns_status_dict
  if not status then
    return labels
  end
  for _, g in ipairs(git_diff) do
    local n = tonumber(status[g.key]) or 0
    if n > 0 then
      table.insert(labels, { g.icon .. " " .. n .. " ", group = g.group })
    end
  end
  if #labels > 0 then
    table.insert(labels, "┊ ")
  end
  return labels
end

-- render はウィンドウごとに呼ばれ、表示する中身を返す。props.buf はそのウィンドウのバッファ。
-- ファイル名は変更済みなら太字斜体、そうでなければ太字(README の例のまま)。
--
-- 位置は右下。laststatus = 0 なので、一番下のウィンドウではコマンドラインのすぐ上に出る。
-- 背景は既定のまま NormalFloat(catppuccin では本文より一段暗い mantle)。カーソル行と
-- 重なったときは既定の hide.cursorline = "smart" でフロートが隠れる。
require("incline").setup({
  window = {
    placement = { horizontal = "right", vertical = "bottom" },
  },
  render = function(props)
    local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
    if name == "" then
      name = "[No Name]"
    end
    local icon, icon_hl = MiniIcons.get("file", name)
    return {
      diagnostic_labels(props.buf),
      git_diff_labels(props.buf),
      { icon .. " ", group = icon_hl },
      { name, gui = vim.bo[props.buf].modified and "bold,italic" or "bold" },
    }
  end,
})

-- incline が描き直すのはカーソル移動・CursorHold・保存などのときだけで、診断の更新と
-- gitsigns の差分の更新は拾わない(manager.lua の events)。どちらもすぐ反映されるように
-- 自分で描き直させる。GitSignsUpdate は gitsigns が差分を取り直すたびに出す User イベント。
local group = vim.api.nvim_create_augroup("incline-refresh", {})
local refresh = function()
  require("incline").refresh()
end
vim.api.nvim_create_autocmd("DiagnosticChanged", { group = group, callback = refresh })
vim.api.nvim_create_autocmd("User", { group = group, pattern = "GitSignsUpdate", callback = refresh })
